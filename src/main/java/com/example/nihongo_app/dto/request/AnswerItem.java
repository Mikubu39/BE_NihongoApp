package com.example.nihongo_app.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 1 câu trả lời của user: câu hỏi nào, chọn option nào. Dùng chung cho
 * {@link SubmitLessonRequest} (nộp bài học thường) và phiên ôn lỗi sai
 * ({@code ReviewSubmitRequest}) — BE ưu tiên đối chiếu {@code selectedOptionId}
 * với DB để xác định đúng/sai; với các câu hỏi không có option trắc nghiệm
 * (sắp xếp, nói...), BE tiếp nhận {@code isCorrect} do client gửi lên.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AnswerItem {

    private Long questionId;

    private Long selectedOptionId;

    private Boolean isCorrect;
}

