package com.example.todo_api.controller;

import com.example.todo_api.model.Task;
import com.example.todo_api.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
// Import the new annotation
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
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
            @AuthenticationPrincipal String username) { // <-- Get logged-in user
        // Use new repository method
        return repository.findByUserIdAndTaskDate(username, date);
    }

    @PostMapping
    public Task create(
            @RequestBody Task task,
            @AuthenticationPrincipal String username) { // <-- Get logged-in user

        task.setUserId(username); // <-- Set user from token

        if (task.getTaskDate() == null) {
            task.setTaskDate(LocalDate.now());
        }
        // Set defaults for new fields if they are null
        if (task.getPriority() == null) {
            task.setPriority("medium");
        }
        if (task.getCategory() == null) {
            task.setCategory("Other");
        }
        return repository.save(task);
    }

    @PutMapping("/{id}")
    public Task update(
            @PathVariable Long id,
            @RequestBody Task updatedTask,
            @AuthenticationPrincipal String username) { // <-- Get logged-in user

        // Find task and ensure it belongs to the logged-in user
        Task task = repository.findByIdAndUserId(id, username)
                .orElseThrow(() -> new RuntimeException("Task not found"));

        // Update title
        if (updatedTask.getTitle() != null) {
            task.setTitle(updatedTask.getTitle());
        }
        // Update description
        if (updatedTask.getDescription() != null) {
            task.setDescription(updatedTask.getDescription());
        }
        // Update priority
        if (updatedTask.getPriority() != null) {
            task.setPriority(updatedTask.getPriority());
        }
        // Update category
        if (updatedTask.getCategory() != null) {
            task.setCategory(updatedTask.getCategory());
        }
        // Update completed status
        if (updatedTask.isCompleted() != task.isCompleted()) {
            task.setCompleted(updatedTask.isCompleted());
        }
        return repository.save(task);
    }

    @DeleteMapping("/{id}")
    public void delete(
            @PathVariable Long id,
            @AuthenticationPrincipal String username) { // <-- Get logged-in user

        // Find task to ensure user can delete it
        Task task = repository.findByIdAndUserId(id, username)
                .orElseThrow(() -> new RuntimeException("Task not found"));

        repository.delete(task);
    }

    @GetMapping("/analytics")
    public Map<String, Long> analytics(
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @AuthenticationPrincipal String username) { // <-- Get logged-in user

        // Get analytics only for the logged-in user
        long total = repository.countByUserIdAndTaskDate(username, date);
        long completed = repository.countByUserIdAndTaskDateAndCompleted(username, date, true);
        return Map.of("total", total, "completed", completed, "pending", total - completed);
    }

    @GetMapping("/pending-dates")
    public List<LocalDate> getPendingDates(@AuthenticationPrincipal String username) { // <-- Get logged-in user
        // Get pending dates only for the logged-in user
        return repository.findPendingTaskDatesByUserId(username);
    }
}