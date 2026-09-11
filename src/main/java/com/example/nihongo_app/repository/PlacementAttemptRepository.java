package com.example.nihongo_app.repository;

import com.example.nihongo_app.entity.PlacementAttempt;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlacementAttemptRepository extends JpaRepository<PlacementAttempt, Long> {

    Optional<PlacementAttempt> findByUserIdAndStatus(Long userId, PlacementAttempt.Status status);
}
