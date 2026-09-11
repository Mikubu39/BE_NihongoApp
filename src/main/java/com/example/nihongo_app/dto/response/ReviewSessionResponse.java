package com.example.nihongo_app.dto.response;

import com.example.nihongo_app.entity.LessonQuestion.QuestionType;
import java.util.List;
import lombok.Builder;
import lombok.Value;
import tools.jackson.databind.JsonNode;

/**
 * Response cho {@code POST /api/v1/reviews/mistakes/start}.
 *
 * <p>KhÃ¡c {@code StartLessonResponse}: khÃ´ng trá»« nÄƒng lÆ°á»£ng, vÃ  option KHÃ”NG kÃ¨m cá» Ä‘Ã¡p Ã¡n
 * Ä‘Ãºng (server tá»± cháº¥m á»Ÿ {@code /submit}, khÃ´ng Ä‘á»ƒ lá»™ Ä‘Ã¡p Ã¡n lÃºc lÃ m bÃ i Ã´n táº­p).</p>
 */
@Value
@Builder
public class ReviewSessionResponse {

    /** Danh sÃ¡ch cÃ¢u há»i Ä‘Ã£ shuffle (rá»—ng náº¿u user khÃ´ng cÃ³ mistake ACTIVE nÃ o). */
    List<ReviewQuestion> questions;

    /** ThÃ´ng bÃ¡o ngáº¯n cho FE hiá»ƒn thá»‹, Ä‘áº·c biá»‡t khi {@code questions} rá»—ng. */
    String message;

    @Value
    @Builder
    public static class ReviewQuestion {
        Long questionId;
        QuestionType questionType;
        String content;
        String audioUrl;
        String imageUrl;
        JsonNode metadataJson;
        List<ReviewOption> options;
    }

    @Value
    @Builder
    public static class ReviewOption {
        Long optionId;
        String content;
        String imageUrl;
        String audioUrl;
        JsonNode metadataJson;
        Boolean isCorrect;
        Integer order;
    }
}
