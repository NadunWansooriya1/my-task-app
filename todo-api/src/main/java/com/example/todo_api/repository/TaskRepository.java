// src/main/java/com/example/todo_api/repository/TaskRepository.java
package com.example.todo_api.repository;

import com.example.todo_api.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface TaskRepository extends JpaRepository<Task, Long> {

    // === USER-SPECIFIC QUERIES ===
    Optional<Task> findByIdAndUserId(Long id, String userId);

    List<Task> findByUserIdAndTaskDate(String userId, LocalDate date);

    long countByUserIdAndTaskDate(String userId, LocalDate date);

    long countByUserIdAndTaskDateAndCompleted(String userId, LocalDate date, boolean completed);

    @Query("SELECT DISTINCT t.taskDate FROM Task t WHERE t.userId = :userId AND t.completed = false ORDER BY t.taskDate ASC")
    List<LocalDate> findPendingTaskDatesByUserId(String userId);

    // === LEGACY (can be removed later) ===
    List<Task> findByTaskDate(LocalDate date);
    long countByTaskDate(LocalDate date);
    long countByTaskDateAndCompleted(LocalDate date, boolean completed);
    @Query("SELECT DISTINCT t.taskDate FROM Task t WHERE t.completed = false ORDER BY t.taskDate ASC")
    List<LocalDate> findPendingTaskDates();
}