package com.example.nihongo_app.controller;

import com.example.nihongo_app.dto.request.PlacementAnswerRequest;
import com.example.nihongo_app.dto.response.PlacementRoundResponse;
import com.example.nihongo_app.security.AppUserPrincipal;
import com.example.nihongo_app.service.PlacementService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * Bài kiểm tra đầu vào (Placement Test) — dò nhị phân qua các Topic để tìm điểm xuất phát
 * phù hợp cho user mới, dùng ngay trong onboarding sau khi chọn "Tôi đã biết một chút tiếng Nhật".
 */
@RestController
@RequestMapping("/api/v1/placement")
@RequiredArgsConstructor
@Tag(name = "Placement", description = "Bài kiểm tra đầu vào: dò nhị phân qua các Topic")
public class PlacementController {

    private final PlacementService placementService;

    @PostMapping("/start")
    @Operation(summary = "Bắt đầu (hoặc resume) bài kiểm tra đầu vào, trả về câu hỏi vòng đầu")
    public ResponseEntity<PlacementRoundResponse> start(Authentication authentication) {
        Long userId = requireUserId(authentication);
        return ResponseEntity.ok(placementService.start(userId));
    }

    @PostMapping("/{attemptId}/answer")
    @Operation(summary = "Nộp câu trả lời vòng hiện tại, trả về vòng tiếp theo hoặc kết quả cuối")
    public ResponseEntity<PlacementRoundResponse> answer(@PathVariable Long attemptId,
                                                         @Valid @RequestBody PlacementAnswerRequest request,
                                                         Authentication authentication) {
        Long userId = requireUserId(authentication);
        return ResponseEntity.ok(placementService.answer(userId, attemptId, request));
    }

    private Long requireUserId(Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof AppUserPrincipal principal)) {
            throw new ResponseStatusException(
                    org.springframework.http.HttpStatus.UNAUTHORIZED,
                    "Missing authenticated principal");
        }
        return principal.getUserId();
    }
}
