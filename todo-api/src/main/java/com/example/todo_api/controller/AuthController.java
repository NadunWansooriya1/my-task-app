package com.example.todo_api.controller;

import com.example.todo_api.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Username and password are required");
            return ResponseEntity.badRequest().body(error);
        }
        
        // Demo: Accept hardcoded user OR any user (for demo purposes)
        // In production, you would validate against a database
        if ("admin".equals(username) && "pass".equals(password)) {
            return ResponseEntity.ok(jwtUtil.generateToken("admin"));
        }
        
        // For demo: allow any valid username/password combination
        if (password.length() >= 4) {
            return ResponseEntity.ok(jwtUtil.generateToken(username));
        }
        
        Map<String, String> error = new HashMap<>();
        error.put("message", "Invalid credentials");
        return ResponseEntity.status(401).body(error);
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Username and password are required");
            return ResponseEntity.badRequest().body(error);
        }
        
        if (password.length() < 4) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Password must be at least 4 characters");
            return ResponseEntity.badRequest().body(error);
        }
        
        // Demo: In a real application, you would:
        // 1. Check if username already exists
        // 2. Hash the password
        // 3. Save user to database
        // For now, we'll just accept registration and return success
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Registration successful! Please sign in.");
        response.put("username", username);
        return ResponseEntity.ok(response);
    }
}