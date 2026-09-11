package com.example.nihongo_app.dto.response;

import com.example.nihongo_app.dto.response.StartLessonResponse.StartLessonQuestion;
import java.util.List;
import lombok.Builder;
import lombok.Value;

/**
 * Response dùng chung cho {@code POST /api/v1/placement/start} và
 * {@code POST /api/v1/placement/{attemptId}/answer}.
 *
 * <p>Khi {@code finished = false}: đang ở giữa bài, {@code questions} là bộ câu hỏi rút mẫu
 * của {@code probeTopicId} cho vòng này (xem {@code PlacementAttempt} — thuật toán dò nhị phân).</p>
 *
 * <p>Khi {@code finished = true}: đã chốt điểm dừng. {@code resultTopicId/Title = null} nghĩa
 * là không có Topic nào được xác nhận qua (rớt ngay từ vòng đầu) — user học từ đầu như bình
 * thường, không có gì bị đánh dấu hoàn thành.</p>
 */
@Value
@Builder
public class PlacementRoundResponse {

    Long attemptId;
    Boolean finished;

    // ----- Khi finished = false -----
    Integer roundNumber;
    Long probeTopicId;
    String probeTopicTitle;
    List<StartLessonQuestion> questions;

    // ----- Khi finished = true -----
    Long resultTopicId;
    String resultTopicTitle;
    Integer expEarned;
    Integer coinsEarned;
}
