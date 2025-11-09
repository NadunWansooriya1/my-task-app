package com.example.todo_api.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins(
                        "https://task-vm.nadunwansooriya.online",
                        "http://task-vm.nadunwansooriya.online",
                        "https://task-vm.nadunwansooriya.online:3000",
                        "http://task-vm.nadunwansooriya.online:3000",
                        "https://104.154.52.39",
                        "http://104.154.52.39",
                        "https://104.154.52.39:3000",
                        "http://104.154.52.39:3000",
                        "http://localhost:3000"       // For local testing
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowCredentials(true)
                .maxAge(3600);
    }
}