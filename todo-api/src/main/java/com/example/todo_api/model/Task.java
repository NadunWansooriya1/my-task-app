// src/main/java/com/example/todo_api/model/Task.java
package com.example.todo_api.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;

@Data
@Entity
public class Task {
    @Id @GeneratedValue
    private Long id;

    @Column(nullable = false)
    private String title;

    private boolean completed = false;

    @Column(nullable = false)
    private String userId; // Stores username from JWT

    @Column(nullable = false)
    private LocalDate taskDate;

    @Column(length = 500)
    private String description;

    @Column(nullable = false)
    private String priority = "medium";

    @Column(nullable = false)
    private String category = "Other";
}