// src/main/java/com/example/todo_api/controller/TaskController.java
package com.example.todo_api.controller;

import com.example.todo_api.model.Task;
import com.example.todo_api.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/tasks")
public class TaskController {

    @Autowired
    private TaskRepository repository;

    @GetMapping
    public List<Task> getAll(
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @AuthenticationPrincipal String username) {

        if (username == null) {
            return Collections.emptyList(); // Safety
        }
        List<Task> tasks = repository.findByUserIdAndTaskDate(username, date);
        return tasks != null ? tasks : Collections.emptyList();
    }

    @PostMapping
    public Task create(
            @RequestBody Task task,
            @AuthenticationPrincipal String username) {

        if (username == null) {
            throw new RuntimeException("Unauthorized");
        }

        task.setUserId(username);
        if (task.getTaskDate() == null) {
            task.setTaskDate(LocalDate.now());
        }
        if (task.getPriority() == null || task.getPriority().isBlank()) {
            task.setPriority("medium");
        }
        if (task.getCategory() == null || task.getCategory().isBlank()) {
            task.setCategory("Other");
        }
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Title is required");
        }

        return repository.save(task);
    }

    @PutMapping("/{id}")
    public Task update(
            @PathVariable Long id,
            @RequestBody Task updatedTask,
            @AuthenticationPrincipal String username) {

        if (username == null) {
            throw new RuntimeException("Unauthorized");
        }

        Task task = repository.findByIdAndUserId(id, username)
                .orElseThrow(() -> new RuntimeException("Task not found or access denied"));

        if (updatedTask.getTitle() != null && !updatedTask.getTitle().trim().isEmpty()) {
            task.setTitle(updatedTask.getTitle().trim());
        }
        if (updatedTask.getDescription() != null) {
            task.setDescription(updatedTask.getDescription());
        }
        if (updatedTask.getPriority() != null && !updatedTask.getPriority().isBlank()) {
            task.setPriority(updatedTask.getPriority());
        }
        if (updatedTask.getCategory() != null && !updatedTask.getCategory().isBlank()) {
            task.setCategory(updatedTask.getCategory());
        }
        task.setCompleted(updatedTask.isCompleted());

        return repository.save(task);
    }

    @DeleteMapping("/{id}")
    public void delete(
            @PathVariable Long id,
            @AuthenticationPrincipal String username) {

        if (username == null) {
            throw new RuntimeException("Unauthorized");
        }

        Task task = repository.findByIdAndUserId(id, username)
                .orElseThrow(() -> new RuntimeException("Task not found or access denied"));

        repository.delete(task);
    }

    @GetMapping("/analytics")
    public Map<String, Long> analytics(
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @AuthenticationPrincipal String username) {

        if (username == null) {
            return Map.of("total", 0L, "completed", 0L, "pending", 0L);
        }

        long total = repository.countByUserIdAndTaskDate(username, date);
        long completed = repository.countByUserIdAndTaskDateAndCompleted(username, date, true);
        long pending = total - completed;

        return Map.of("total", total, "completed", completed, "pending", pending);
    }

    @GetMapping("/pending-dates")
    public List<LocalDate> getPendingDates(@AuthenticationPrincipal String username) {
        if (username == null) {
            return Collections.emptyList();
        }
        return repository.findPendingTaskDatesByUserId(username);
    }
}