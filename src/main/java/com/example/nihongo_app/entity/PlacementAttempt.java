package com.example.nihongo_app.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Trạng thái 1 lượt làm bài kiểm tra đầu vào (Placement Test) của 1 user.
 *
 * <p>Thuật toán dò nhị phân qua danh sách Topic đã sắp theo {@code order_index}:
 * {@code lowIndex} là vị trí Topic cuối cùng đã XÁC NHẬN QUA (-1 = chưa xác nhận topic
 * nào), {@code highIndex} là vị trí Topic đầu tiên đã XÁC NHẬN RỚT (= số lượng Topic
 * nghĩa là chưa rớt topic nào). Mỗi vòng đo 1 Topic ở giữa khoảng [lowIndex, highIndex],
 * thu hẹp dần tới khi hội tụ hoặc hết số vòng cho phép.</p>
 *
 * <p>Khi FINISHED, {@code resultTopicId} là Topic tại {@code lowIndex} (hoặc null nếu
 * lowIndex = -1) — mọi Topic có {@code order_index <= } Topic này sẽ được đánh dấu
 * COMPLETED, đảm bảo không có "lỗ chỗ" (xem {@code LessonAttemptServiceImpl#completePlacement}).</p>
 */
@Entity
@Table(name = "placement_attempts")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlacementAttempt {

    public enum Status {
        IN_PROGRESS, FINISHED
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private Status status;

    @Column(name = "low_index", nullable = false)
    private Integer lowIndex;

    @Column(name = "high_index", nullable = false)
    private Integer highIndex;

    @Column(name = "probe_topic_id")
    private Long probeTopicId;

    @Column(name = "rounds_used", nullable = false)
    private Integer roundsUsed;

    @Column(name = "result_topic_id")
    private Long resultTopicId;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "finished_at")
    private LocalDateTime finishedAt;
}
