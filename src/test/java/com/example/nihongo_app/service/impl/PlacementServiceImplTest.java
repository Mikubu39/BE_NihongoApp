package com.example.nihongo_app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.example.nihongo_app.dto.request.AnswerItem;
import com.example.nihongo_app.dto.request.PlacementAnswerRequest;
import com.example.nihongo_app.dto.response.PlacementCompletionResult;
import com.example.nihongo_app.dto.response.PlacementRoundResponse;
import com.example.nihongo_app.dto.response.StartLessonResponse.StartLessonOption;
import com.example.nihongo_app.dto.response.StartLessonResponse.StartLessonQuestion;
import com.example.nihongo_app.entity.Lesson;
import com.example.nihongo_app.entity.Lesson.LessonType;
import com.example.nihongo_app.entity.LessonQuestion;
import com.example.nihongo_app.entity.LessonQuestionOption;
import com.example.nihongo_app.entity.PlacementAttempt;
import com.example.nihongo_app.entity.Topic;
import com.example.nihongo_app.entity.UserLessonProgress;
import com.example.nihongo_app.entity.UserLessonProgress.ProgressStatus;
import com.example.nihongo_app.exception.PlacementNotEligibleException;
import com.example.nihongo_app.repository.LessonQuestionOptionRepository;
import com.example.nihongo_app.repository.LessonQuestionRepository;
import com.example.nihongo_app.repository.LessonRepository;
import com.example.nihongo_app.repository.PlacementAttemptRepository;
import com.example.nihongo_app.repository.TopicRepository;
import com.example.nihongo_app.repository.UserLessonProgressRepository;
import com.example.nihongo_app.service.LessonAttemptService;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

/**
 * Test cho {@link PlacementServiceImpl}: thuật toán dò nhị phân qua Topic của bài kiểm
 * tra đầu vào.
 *
 * <p>Dùng 1 harness chung ({@link #runFullTest(int)}) cho cả 3 kịch bản (đúng hết / sai hết /
 * đúng một phần) thay vì hardcode từng bước trả lời: harness trả lời ĐÚNG cho mọi vòng có
 * {@code topic.orderIndex <= knownUpToOrderIndex} cho trước, SAI cho phần còn lại — đây chính
 * là định nghĩa "người học biết tới đâu" mà bài test đang cố dò ra. Test chạy đúng thuật toán
 * thật (không mock kết quả từng vòng), nên nếu hội tụ đúng {@code knownUpToOrderIndex} với cả
 * 3 ngưỡng khác nhau (0, giữa, tối đa) thì có thể tin thuật toán đúng với mọi ngưỡng khác ở giữa.</p>
 */
@ExtendWith(MockitoExtension.class)
class PlacementServiceImplTest {

    private static final int TOPIC_COUNT = 8;
    private static final Long USER_ID = 1L;

    @Mock private PlacementAttemptRepository attemptRepository;
    @Mock private TopicRepository topicRepository;
    @Mock private LessonRepository lessonRepository;
    @Mock private LessonQuestionRepository questionRepository;
    @Mock private LessonQuestionOptionRepository optionRepository;
    @Mock private UserLessonProgressRepository progressRepository;
    @Mock private LessonAttemptService lessonAttemptService;

    @InjectMocks
    private PlacementServiceImpl service;

    private final AtomicReference<PlacementAttempt> stored = new AtomicReference<>();

    @BeforeEach
    void setUp() {
        lenient().when(progressRepository.findAllByUserId(USER_ID)).thenReturn(List.of());
        lenient().when(attemptRepository.findByUserIdAndStatus(any(), any())).thenReturn(Optional.empty());
        lenient().when(attemptRepository.save(any())).thenAnswer(inv -> {
            PlacementAttempt a = inv.getArgument(0);
            if (a.getId() == null) {
                a.setId(1L);
            }
            stored.set(a);
            return a;
        });
        lenient().when(attemptRepository.findById(1L)).thenAnswer(inv -> Optional.ofNullable(stored.get()));

        // Stub mac dinh cho completePlacement: echo lai cutoffTopicId duoc truyen vao, gia lap
        // dung hanh vi that (null -> khong thuong; co topic -> thuong co dinh 50 exp/15 xu).
        lenient().when(lessonAttemptService.completePlacement(eq(USER_ID), any())).thenAnswer(inv -> {
            Long cutoffTopicId = inv.getArgument(1);
            return PlacementCompletionResult.builder()
                    .topicId(cutoffTopicId)
                    .topicTitle(cutoffTopicId == null ? null : "Topic " + cutoffTopicId)
                    .expEarned(cutoffTopicId == null ? 0 : 50)
                    .coinsEarned(cutoffTopicId == null ? 0 : 15)
                    .build();
        });

        List<Topic> topics = new ArrayList<>();
        for (int oi = 1; oi <= TOPIC_COUNT; oi++) {
            long topicId = oi;
            Topic topic = Topic.builder().id(topicId).title("Topic " + oi).orderIndex(oi).build();
            topics.add(topic);
            lenient().when(topicRepository.findByIdAndDeletedAtIsNull(topicId)).thenReturn(Optional.of(topic));

            long jumpTestLessonId = 1000 + oi;
            Lesson jumpTestLesson = Lesson.builder().id(jumpTestLessonId).topicId(topicId)
                    .lessonType(LessonType.JUMP_TEST).build();
            lenient().when(lessonRepository.findAllByTopicIdOrdered(topicId))
                    .thenReturn(List.of(jumpTestLesson));

            List<LessonQuestion> questions = new ArrayList<>();
            for (int qi = 1; qi <= 4; qi++) {
                long questionId = oi * 100L + qi;
                questions.add(LessonQuestion.builder().id(questionId).lessonId(jumpTestLessonId).build());

                long correctOptionId = oi * 10000L + qi * 10L + 1;
                long wrongOptionId = oi * 10000L + qi * 10L + 2;
                lenient().when(optionRepository.findAllByQuestionIdOrderByOrderIndexAscIdAsc(questionId))
                        .thenReturn(List.of(
                                LessonQuestionOption.builder().id(correctOptionId).questionId(questionId)
                                        .correct(true).orderIndex(1).build(),
                                LessonQuestionOption.builder().id(wrongOptionId).questionId(questionId)
                                        .correct(false).orderIndex(2).build()));
                lenient().when(optionRepository.findById(correctOptionId)).thenReturn(Optional.of(
                        LessonQuestionOption.builder().id(correctOptionId).questionId(questionId)
                                .correct(true).build()));
                lenient().when(optionRepository.findById(wrongOptionId)).thenReturn(Optional.of(
                        LessonQuestionOption.builder().id(wrongOptionId).questionId(questionId)
                                .correct(false).build()));
                lenient().when(questionRepository.findById(questionId)).thenReturn(Optional.of(
                        LessonQuestion.builder().id(questionId).lessonId(jumpTestLessonId).build()));
            }
            lenient().when(questionRepository.findAllByLessonIdOrderByIdAsc(jumpTestLessonId))
                    .thenReturn(questions);
        }
        lenient().when(topicRepository.findAllActiveWithLessons()).thenReturn(topics);
    }

    /** Chạy hết bài test, trả lời ĐÚNG cho mọi vòng có topic.orderIndex <= knownUpToOrderIndex. */
    private PlacementRoundResponse runFullTest(int knownUpToOrderIndex) {
        PlacementRoundResponse round = service.start(USER_ID);
        int safety = 0;
        while (!Boolean.TRUE.equals(round.getFinished())) {
            if (++safety > 20) {
                throw new IllegalStateException("Thuat toan khong hoi tu sau 20 vong -- nghi ngo bug vong lap vo han");
            }
            boolean shouldPass = round.getProbeTopicId().intValue() <= knownUpToOrderIndex;

            List<AnswerItem> answers = new ArrayList<>();
            for (StartLessonQuestion q : round.getQuestions()) {
                StartLessonOption chosen = q.getOptions().stream()
                        .filter(o -> Boolean.TRUE.equals(o.getIsCorrect()) == shouldPass)
                        .findFirst()
                        .orElseThrow();
                AnswerItem item = new AnswerItem();
                item.setQuestionId(q.getQuestionId());
                item.setSelectedOptionId(chosen.getOptionId());
                answers.add(item);
            }

            PlacementAnswerRequest req = new PlacementAnswerRequest();
            req.setAnswers(answers);
            round = service.answer(USER_ID, round.getAttemptId(), req);
        }
        return round;
    }

    @Test
    void allCorrect_capsAtMaxPlacementTopic_neverReachesLastTopic() {
        // Biet het ca 8 topic -- nhung Placement Test KHONG duoc phep xoa sach ca khoa hoc.
        // Phai dung lai o topic 3 (MAX_PLACEMENT_TOPIC_INDEX = 2, 0-indexed), du dung het.
        // Nguoi thuc su gioi hon se dung JUMP_TEST (thi vuot tung topic) de tu vuot tiep,
        // khong phai bai dau vao gom het trong 1 lan.
        PlacementRoundResponse result = runFullTest(TOPIC_COUNT);

        assertThat(result.getResultTopicId()).isEqualTo(3L);
        assertThat(result.getExpEarned()).isEqualTo(50);
        assertThat(result.getCoinsEarned()).isEqualTo(15);
        verify(lessonAttemptService).completePlacement(USER_ID, 3L);
    }

    @Test
    void allWrong_noTopicCompletedAndNoReward() {
        PlacementRoundResponse result = runFullTest(0); // khong biet gi ca, sai het moi vong

        assertThat(result.getResultTopicId()).isNull();
        assertThat(result.getExpEarned()).isZero();
        assertThat(result.getCoinsEarned()).isZero();
        verify(lessonAttemptService).completePlacement(USER_ID, null);
    }

    @Test
    void mixedAnswers_belowCap_convergesExactlyToKnownCutoff_notMoreNotLess() {
        int knownUpTo = 2; // biet topic 1-2, khong biet 3-8 -- nam duoi tran (topic 3)

        PlacementRoundResponse result = runFullTest(knownUpTo);

        // Phai dung CHINH XAC topic 2 -- khong duoc thua (vd topic 3, "nhay lo cho" nguoc)
        // cung khong duoc thieu (vd topic 1, bat hoc lai thu da biet).
        assertThat(result.getResultTopicId()).isEqualTo((long) knownUpTo);
        verify(lessonAttemptService).completePlacement(USER_ID, (long) knownUpTo);
    }

    @Test
    void mixedAnswers_aboveCap_stillCapsAtMaxPlacementTopic() {
        int knownUpTo = 5; // biet topic 1-5 -- vuot tran, nhung Placement Test khong duoc phep bao gio hoi qua topic 3

        PlacementRoundResponse result = runFullTest(knownUpTo);

        assertThat(result.getResultTopicId()).isEqualTo(3L);
        verify(lessonAttemptService).completePlacement(USER_ID, 3L);
    }

    @Test
    void mixedAnswers_worksForEveryCutoffUpToCap_andCapsBeyondIt() {
        // Quet toan bo nguong co the co (0..TOPIC_COUNT). Duoi tran (topic 3): phai hoi tu
        // dung chinh xac nguong that. Tu tran tro len: luon dung o topic 3, khong bao gio hoi.
        for (int knownUpTo = 0; knownUpTo <= TOPIC_COUNT; knownUpTo++) {
            PlacementRoundResponse result = runFullTest(knownUpTo);
            Long expectedId = knownUpTo == 0 ? null : (long) Math.min(knownUpTo, 3);
            assertThat(result.getResultTopicId())
                    .as("knownUpTo=%d", knownUpTo)
                    .isEqualTo(expectedId);
        }
    }

    @Test
    void start_rejectsUserWithExistingProgress() {
        when(progressRepository.findAllByUserId(USER_ID)).thenReturn(List.of(
                UserLessonProgress.builder()
                        .userId(USER_ID).lessonId(999L)
                        .status(ProgressStatus.COMPLETED)
                        .build()));

        assertThatThrownBy(() -> service.start(USER_ID))
                .isInstanceOf(PlacementNotEligibleException.class);
    }
}
