package com.example.nihongo_app.service.impl;

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
import com.example.nihongo_app.exception.PlacementNotEligibleException;
import com.example.nihongo_app.exception.ResourceNotFoundException;
import com.example.nihongo_app.repository.LessonQuestionOptionRepository;
import com.example.nihongo_app.repository.LessonQuestionRepository;
import com.example.nihongo_app.repository.LessonRepository;
import com.example.nihongo_app.repository.PlacementAttemptRepository;
import com.example.nihongo_app.repository.TopicRepository;
import com.example.nihongo_app.repository.UserLessonProgressRepository;
import com.example.nihongo_app.service.LessonAttemptService;
import com.example.nihongo_app.service.PlacementService;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implementation của {@link PlacementService}.
 *
 * <h3>Thuật toán: dò nhị phân qua Topic</h3>
 * <p>Topic được sắp theo {@code order_index} thành 1 danh sách vị trí {@code 0..N-1}.
 * {@code lowIndex} (khởi tạo -1) là vị trí Topic cuối cùng XÁC NHẬN QUA, {@code highIndex}
 * (khởi tạo N) là vị trí Topic đầu tiên XÁC NHẬN RỚT. Mỗi vòng đo Topic ở giữa khoảng, thu hẹp
 * dần tới khi {@code highIndex - lowIndex <= 1} (hội tụ) hoặc hết số vòng cho phép
 * ({@code ceil(log2(N)) + 1}, đủ dư so với lý thuyết để tránh lệch do làm tròn).</p>
 *
 * <p>Đây là lý do tổng số câu hỏi cho CẢ bài test chỉ tăng theo {@code log2(N)} chứ không phải
 * theo N: 14 Topic hiện tại chỉ cần ~4 vòng x 4 câu = ~16 câu, không phải chạy hết cả 14 Topic.</p>
 *
 * <h3>Nguồn câu hỏi</h3>
 * <p>Không tạo ngân hàng câu hỏi riêng cho Placement — mỗi vòng rút mẫu ngẫu nhiên
 * {@value #SAMPLE_SIZE_PER_ROUND} câu từ đúng lesson {@code JUMP_TEST} đã có sẵn của Topic đang
 * đo (đã được soạn thủ công, đại diện đúng nội dung Topic đó).</p>
 *
 * <h3>Không "nhảy lỗ chỗ"</h3>
 * <p>Khi hội tụ, điểm dừng là 1 con số DUY NHẤT ({@code lowIndex}) — việc đánh dấu hoàn thành
 * được uỷ thác cho {@link LessonAttemptService#completePlacement} (dùng chung logic cascade
 * với JUMP_TEST), không có nhánh nào tự ý đánh dấu 1 Topic riêng lẻ.</p>
 */
@Service
@RequiredArgsConstructor
public class PlacementServiceImpl implements PlacementService {

    private final PlacementAttemptRepository attemptRepository;
    private final TopicRepository topicRepository;
    private final LessonRepository lessonRepository;
    private final LessonQuestionRepository questionRepository;
    private final LessonQuestionOptionRepository optionRepository;
    private final UserLessonProgressRepository progressRepository;
    private final LessonAttemptService lessonAttemptService;

    private static final int SAMPLE_SIZE_PER_ROUND = 4;
    /** Ti le dung toi thieu de coi la "qua" 1 vong (3/4 cau voi sample size mac dinh). */
    private static final double PASS_RATIO = 0.75;
    /**
     * Tran cung cho ket qua Placement Test: du dung het TAT CA cau hoi, khong bao gio duoc
     * xep xa hon topic tai vi tri nay (0-indexed) -- vd = 2 nghia la toi da la topic thu 3.
     *
     * <p>Ly do: bai kiem tra dau vao chi nen tim mot diem xuat phat vua phai (giong Duolingo
     * chi de xuat toi da "Phan 2"), khong duoc phep xoa sach ca khoa hoc ngay ngay dau -- neu
     * khong user se khong con gi de hoc. Nguoi thuc su gioi hon muc nay se tu dung JUMP_TEST
     * (thi vuot tung topic, luc nao cung bam duoc) de tiep tuc nhay xa hon dan dan theo thoi
     * gian, thay vi don het vao 1 lan luc moi tao tai khoan.</p>
     */
    private static final int MAX_PLACEMENT_TOPIC_INDEX = 2;

    @Override
    @Transactional
    public PlacementRoundResponse start(Long userId) {
        boolean alreadyLearning = progressRepository.findAllByUserId(userId).stream()
                .anyMatch(p -> p.getStatus() == UserLessonProgress.ProgressStatus.COMPLETED);
        if (alreadyLearning) {
            throw new PlacementNotEligibleException(
                    "Tài khoản đã có tiến trình học, không thể làm bài kiểm tra đầu vào nữa.");
        }

        PlacementAttempt existing = attemptRepository
                .findByUserIdAndStatus(userId, PlacementAttempt.Status.IN_PROGRESS)
                .orElse(null);
        if (existing != null) {
            return buildRoundResponse(existing);
        }

        List<Topic> topics = topicRepository.findAllActiveWithLessons();
        if (topics.isEmpty()) {
            throw new ResourceNotFoundException("Hệ thống chưa có chủ đề nào");
        }

        int n = topics.size();
        // Tran cung: khoang tim kiem khong bao gio vuot qua MAX_PLACEMENT_TOPIC_INDEX, du
        // he thong co bao nhieu topic di nua. highIndex duoc cap o day va luu lai trong DB --
        // moi vong sau chi doc lai highIndex da cap nay (khong tinh lai tu topics.size()),
        // nen tran duoc giu xuyen suot ca bai test, khong chi o vong dau.
        int effectiveHigh = Math.min(n, MAX_PLACEMENT_TOPIC_INDEX + 1);
        int probeIndex = (-1 + effectiveHigh) / 2;

        PlacementAttempt attempt = PlacementAttempt.builder()
                .userId(userId)
                .status(PlacementAttempt.Status.IN_PROGRESS)
                .lowIndex(-1)
                .highIndex(effectiveHigh)
                .roundsUsed(0)
                .probeTopicId(topics.get(probeIndex).getId())
                .build();
        attempt = attemptRepository.save(attempt);

        return buildRoundResponse(attempt);
    }

    @Override
    @Transactional
    public PlacementRoundResponse answer(Long userId, Long attemptId, PlacementAnswerRequest request) {
        PlacementAttempt attempt = attemptRepository.findById(attemptId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Không tìm thấy bài kiểm tra đầu vào với id=" + attemptId));
        if (!Objects.equals(attempt.getUserId(), userId)) {
            throw new PlacementNotEligibleException("Bài kiểm tra này không thuộc về tài khoản hiện tại");
        }
        if (attempt.getStatus() != PlacementAttempt.Status.IN_PROGRESS) {
            throw new PlacementNotEligibleException("Bài kiểm tra đầu vào này đã kết thúc");
        }

        Lesson jumpTestLesson = findJumpTestLesson(attempt.getProbeTopicId());
        boolean passed = gradeRound(jumpTestLesson.getId(), request.getAnswers());

        List<Topic> topics = topicRepository.findAllActiveWithLessons();
        int n = topics.size();
        int probeIndex = indexOfTopic(topics, attempt.getProbeTopicId());

        if (passed) {
            attempt.setLowIndex(probeIndex);
        } else {
            attempt.setHighIndex(probeIndex);
        }
        attempt.setRoundsUsed(attempt.getRoundsUsed() + 1);

        boolean converged = attempt.getHighIndex() - attempt.getLowIndex() <= 1;
        boolean roundsExhausted = attempt.getRoundsUsed() >= maxRounds(n);

        if (converged || roundsExhausted) {
            return finishAttempt(userId, attempt, topics);
        }

        int nextProbeIndex = (attempt.getLowIndex() + attempt.getHighIndex()) / 2;
        attempt.setProbeTopicId(topics.get(nextProbeIndex).getId());
        attempt = attemptRepository.save(attempt);

        return buildRoundResponse(attempt);
    }

    private PlacementRoundResponse finishAttempt(Long userId, PlacementAttempt attempt, List<Topic> topics) {
        Long cutoffTopicId = attempt.getLowIndex() >= 0 ? topics.get(attempt.getLowIndex()).getId() : null;

        attempt.setStatus(PlacementAttempt.Status.FINISHED);
        attempt.setResultTopicId(cutoffTopicId);
        attempt.setProbeTopicId(null);
        attempt.setFinishedAt(LocalDateTime.now());
        attemptRepository.save(attempt);

        PlacementCompletionResult result = lessonAttemptService.completePlacement(userId, cutoffTopicId);

        return PlacementRoundResponse.builder()
                .attemptId(attempt.getId())
                .finished(true)
                .resultTopicId(result.getTopicId())
                .resultTopicTitle(result.getTopicTitle())
                .expEarned(result.getExpEarned())
                .coinsEarned(result.getCoinsEarned())
                .build();
    }

    /**
     * Cham 1 vong: BE tu doi chieu {@code selectedOptionId} voi DB (khong tin FE khai dung/sai),
     * giong het {@code LessonAttemptServiceImpl.recordAnswers}. Cau hoi khong thuoc dung lesson
     * JUMP_TEST dang do (vd FE gui nham/gian lan) bi bo qua, khong tinh vao mau so.
     */
    private boolean gradeRound(Long jumpTestLessonId, List<AnswerItem> answers) {
        if (answers == null || answers.isEmpty()) {
            return false;
        }
        int gradedCount = 0;
        int correctCount = 0;
        for (AnswerItem item : answers) {
            if (item.getQuestionId() == null || item.getSelectedOptionId() == null) {
                continue;
            }
            LessonQuestionOption option = optionRepository.findById(item.getSelectedOptionId()).orElse(null);
            if (option == null || !Objects.equals(option.getQuestionId(), item.getQuestionId())) {
                continue;
            }
            LessonQuestion question = questionRepository.findById(item.getQuestionId()).orElse(null);
            if (question == null || !Objects.equals(question.getLessonId(), jumpTestLessonId)) {
                continue;
            }
            gradedCount++;
            if (Boolean.TRUE.equals(option.getCorrect())) {
                correctCount++;
            }
        }
        return gradedCount > 0 && correctCount >= Math.ceil(gradedCount * PASS_RATIO);
    }

    private PlacementRoundResponse buildRoundResponse(PlacementAttempt attempt) {
        Topic topic = topicRepository.findByIdAndDeletedAtIsNull(attempt.getProbeTopicId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Chủ đề id=" + attempt.getProbeTopicId() + " không tồn tại"));
        Lesson jumpTestLesson = findJumpTestLesson(attempt.getProbeTopicId());

        List<LessonQuestion> pool = questionRepository.findAllByLessonIdOrderByIdAsc(jumpTestLesson.getId());
        List<LessonQuestion> shuffled = ShuffleUtil.shuffle(pool);
        List<LessonQuestion> picked = shuffled.size() <= SAMPLE_SIZE_PER_ROUND
                ? shuffled : shuffled.subList(0, SAMPLE_SIZE_PER_ROUND);

        List<StartLessonQuestion> questionResponses = new ArrayList<>(picked.size());
        for (LessonQuestion q : picked) {
            List<LessonQuestionOption> options = optionRepository
                    .findAllByQuestionIdOrderByOrderIndexAscIdAsc(q.getId());
            List<LessonQuestionOption> shuffledOptions = ShuffleUtil.shuffle(options);
            List<StartLessonOption> optionResponses = shuffledOptions.stream()
                    .map(o -> StartLessonOption.builder()
                            .optionId(o.getId())
                            .content(o.getOptionText())
                            .imageUrl(o.getImageUrl())
                            .audioUrl(o.getAudioUrl())
                            .metadataJson(o.getMetadataJson())
                            .isCorrect(o.getCorrect())
                            .order(o.getOrderIndex())
                            .build())
                    .toList();
            questionResponses.add(StartLessonQuestion.builder()
                    .questionId(q.getId())
                    .questionType(q.getQuestionType())
                    .content(q.getQuestionText())
                    .audioUrl(q.getAudioUrl())
                    .imageUrl(q.getImageUrl())
                    .metadataJson(q.getMetadataJson())
                    .isNew(false)
                    .options(optionResponses)
                    .build());
        }

        return PlacementRoundResponse.builder()
                .attemptId(attempt.getId())
                .finished(false)
                .roundNumber(attempt.getRoundsUsed() + 1)
                .probeTopicId(topic.getId())
                .probeTopicTitle(topic.getTitle())
                .questions(questionResponses)
                .build();
    }

    private Lesson findJumpTestLesson(Long topicId) {
        return lessonRepository.findAllByTopicIdOrdered(topicId).stream()
                .filter(l -> l.getLessonType() == LessonType.JUMP_TEST)
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Chủ đề id=" + topicId + " chưa có bài học vượt cấp JUMP_TEST"));
    }

    private int indexOfTopic(List<Topic> topics, Long topicId) {
        for (int i = 0; i < topics.size(); i++) {
            if (topics.get(i).getId().equals(topicId)) {
                return i;
            }
        }
        throw new ResourceNotFoundException("Chủ đề id=" + topicId + " không còn trong danh sách hoạt động");
    }

    /** ceil(log2(N)) + 1 vong du -- vi du 14 topic ~ 4 vong ly thuyet + 1 du = 5 vong toi da. */
    private int maxRounds(int topicCount) {
        if (topicCount <= 1) {
            return 1;
        }
        return (int) Math.ceil(Math.log(topicCount) / Math.log(2)) + 1;
    }
}
