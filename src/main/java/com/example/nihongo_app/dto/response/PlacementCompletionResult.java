package com.example.nihongo_app.dto.response;

import lombok.Builder;
import lombok.Value;

/**
 * Kết quả nội bộ khi {@code LessonAttemptService#completePlacement} đánh dấu hoàn thành
 * các Topic từ đầu tới {@code topicId} (bao gồm). Dùng để {@code PlacementService} build
 * {@link PlacementRoundResponse} trả về FE.
 */
@Value
@Builder
public class PlacementCompletionResult {
    Long topicId;
    String topicTitle;
    int expEarned;
    int coinsEarned;
}
