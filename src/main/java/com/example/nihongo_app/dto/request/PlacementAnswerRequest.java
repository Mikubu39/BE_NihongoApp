package com.example.nihongo_app.dto.request;

import jakarta.validation.constraints.NotNull;
import java.util.List;
import lombok.Data;

/**
 * Request cho {@code POST /api/v1/placement/{attemptId}/answer} — nộp câu trả lời của
 * VÒNG HIỆN TẠI trong bài kiểm tra đầu vào. BE tự đối chiếu {@code selectedOptionId} với
 * DB để chấm (không tin FE khai đúng/sai), giống hệt {@link SubmitLessonRequest}.
 */
@Data
public class PlacementAnswerRequest {

    @NotNull
    private List<AnswerItem> answers;
}
