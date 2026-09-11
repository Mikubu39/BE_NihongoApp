package com.example.nihongo_app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import com.example.nihongo_app.entity.UserVocabularyProgress;
import com.example.nihongo_app.repository.UserVocabularyProgressRepository;
import com.example.nihongo_app.repository.VocabularyRepository;
import java.time.LocalDateTime;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

/**
 * Test cho {@link VocabularyServiceImpl#backfillSkippedProgress}: bù lịch SM-2 cho từ vựng
 * của các bài bị JUMP_TEST/bài kiểm tra đầu vào nhảy cóc qua mà không hề chấm bài thật
 * (xem {@link LessonAttemptServiceImpl#markAllTopicsUpToCompleted}).
 */
@ExtendWith(MockitoExtension.class)
class VocabularyServiceImplTest {

    @Mock private VocabularyRepository vocabularyRepository;
    @Mock private UserVocabularyProgressRepository progressRepository;

    private VocabularyServiceImpl service;

    private static final Long USER_ID = 1L;

    @BeforeEach
    void setUp() {
        service = new VocabularyServiceImpl(vocabularyRepository, progressRepository, new Sm2Scheduler());
    }

    @Test
    void backfillSkippedProgress_tuChuaTungCoProgress_duocTaoMoiVaDenHanNgay() {
        when(vocabularyRepository.findTargetVocabularyByQuestionIds(List.of(1L, 2L))).thenReturn(List.of(
                new Object[] {1L, 100L},
                new Object[] {2L, 200L}));
        // Vocab 100 nguoi hoc da tung gap that (vi du hoc truoc do); vocab 200 thi chua.
        when(progressRepository.findAllByUserIdAndVocabularyIdIn(eq(USER_ID), eq(List.of(100L, 200L))))
                .thenReturn(List.of(
                        UserVocabularyProgress.builder().userId(USER_ID).vocabularyId(100L).build()));

        service.backfillSkippedProgress(USER_ID, List.of(1L, 2L));

        ArgumentCaptor<List<UserVocabularyProgress>> captor = ArgumentCaptor.forClass(List.class);
        verify(progressRepository).saveAll(captor.capture());

        List<UserVocabularyProgress> created = captor.getValue();
        assertThat(created).hasSize(1);
        UserVocabularyProgress backfilled = created.get(0);
        assertThat(backfilled.getVocabularyId()).isEqualTo(200L);
        assertThat(backfilled.getRepetitions()).isEqualTo(0);
        // Danh dau tới han NGAY -- khong duoc giong nhu vua tra loi dung that,
        // vi nguoi hoc chua he duoc hoi tu nay.
        assertThat(backfilled.getFirstLearnedAt()).isNotNull();
        assertThat(backfilled.getNextDueAt()).isBeforeOrEqualTo(LocalDateTime.now());
    }

    @Test
    void backfillSkippedProgress_tatCaTuDaCoProgress_khongTaoGiThem() {
        when(vocabularyRepository.findTargetVocabularyByQuestionIds(List.of(1L))).thenReturn(List.<Object[]>of(
                new Object[] {1L, 100L}));
        when(progressRepository.findAllByUserIdAndVocabularyIdIn(eq(USER_ID), eq(List.of(100L))))
                .thenReturn(List.of(
                        UserVocabularyProgress.builder().userId(USER_ID).vocabularyId(100L).build()));

        service.backfillSkippedProgress(USER_ID, List.of(1L));

        verify(progressRepository, never()).saveAll(org.mockito.ArgumentMatchers.any());
    }

    @Test
    void backfillSkippedProgress_khongCoQuestionId_boQuaKhongGoiRepository() {
        service.backfillSkippedProgress(USER_ID, List.of());

        verifyNoInteractions(vocabularyRepository, progressRepository);
    }
}
