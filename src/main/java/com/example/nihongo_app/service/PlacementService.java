package com.example.nihongo_app.service;

import com.example.nihongo_app.dto.request.PlacementAnswerRequest;
import com.example.nihongo_app.dto.response.PlacementRoundResponse;

/**
 * Bài kiểm tra đầu vào (Placement Test): dò nhị phân qua danh sách Topic (sắp theo
 * {@code order_index}) để tìm điểm xuất phát phù hợp cho user mới, tránh bắt người đã
 * có kiến thức phải học lại từ đầu.
 *
 * <p>Mỗi vòng rút mẫu vài câu hỏi từ đúng ngân hàng câu hỏi {@code JUMP_TEST} đã có sẵn
 * của 1 Topic (không tạo ngân hàng câu hỏi riêng) — xem {@code PlacementServiceImpl} để
 * biết chi tiết thuật toán.</p>
 */
public interface PlacementService {

    /**
     * Bắt đầu (hoặc resume nếu đang có 1 attempt IN_PROGRESS) bài kiểm tra đầu vào.
     *
     * @throws com.example.nihongo_app.exception.PlacementNotEligibleException nếu user đã có
     *         tiến trình học thật (không phải tài khoản mới).
     */
    PlacementRoundResponse start(Long userId);

    /**
     * Nộp câu trả lời của vòng hiện tại. Nếu đã hội tụ (hoặc hết số vòng cho phép) thì kết
     * thúc bài test và trả kết quả cuối; ngược lại trả về câu hỏi của vòng tiếp theo.
     */
    PlacementRoundResponse answer(Long userId, Long attemptId, PlacementAnswerRequest request);
}
