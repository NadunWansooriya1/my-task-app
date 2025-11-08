package com.example.todo_api.repository;

import com.example.todo_api.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional; // <-- Make sure this is imported

public interface TaskRepository extends JpaRepository<Task, Long> {

    // --- NEW METHODS FOR MULTI-USER SUPPORT ---

    // Finds a single task by ID and Username (for update/delete)
    Optional<Task> findByIdAndUserId(Long id, String userId);

    // Finds all tasks for a specific user on a specific date
    List<Task> findByUserIdAndTaskDate(String userId, LocalDate date);

    // Gets total count for a user on a specific date
    long countByUserIdAndTaskDate(String userId, LocalDate date);

    // Gets completed count for a user on a specific date
    long countByUserIdAndTaskDateAndCompleted(String userId, LocalDate date, boolean completed);

    // Gets pending dates for a specific user
    @Query("SELECT DISTINCT t.taskDate FROM Task t WHERE t.userId = :userId AND t.completed = false ORDER BY t.taskDate ASC")
    List<LocalDate> findPendingTaskDatesByUserId(String userId);


    // --- Your old methods (can be kept or removed) ---
    List<Task> findByTaskDate(LocalDate date);
    long countByTaskDate(LocalDate date);
    long countByTaskDateAndCompleted(LocalDate date, boolean completed);

    @Query("SELECT DISTINCT t.taskDate FROM Task t WHERE t.completed = false ORDER BY t.taskDate ASC")
    List<LocalDate> findPendingTaskDates();
}