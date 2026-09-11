package com.example.nihongo_app.exception;

/**
 * Exception nghiệp vụ khi user không đủ điều kiện làm bài kiểm tra đầu vào —
 * đã có lesson COMPLETED thật (không phải tài khoản mới) nên không cho "nhảy cóc"
 * để tránh lạm dụng phá tiến trình đã học.
 */
public class PlacementNotEligibleException extends RuntimeException {
    public PlacementNotEligibleException(String message) {
        super(message);
    }
}
