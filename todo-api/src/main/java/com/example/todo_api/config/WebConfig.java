package com.example.todo_api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.Arrays;
import java.util.List;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.setAllowedOriginPatterns(Arrays.asList(
                "https://task-vm.nadunwansooriya.online*",
                "http://task-vm.nadunwansooriya.online*",
                "https://104.154.52.39*",
                "http://104.154.52.39*",
                "http://localhost*"
        ));
        config.setAllowedHeaders(List.of("*"));
        config.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH", "HEAD"));
        config.setMaxAge(3600L);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        
        return new CorsFilter(source);
    }
    
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins(
                        // Domain with HTTPS
                        "https://task-vm.nadunwansooriya.online",
                        "https://task-vm.nadunwansooriya.online:3000",
                        "https://task-vm.nadunwansooriya.online:8080",
                        // Domain with HTTP
                        "http://task-vm.nadunwansooriya.online",
                        "http://task-vm.nadunwansooriya.online:3000",
                        "http://task-vm.nadunwansooriya.online:8080",
                        // IP with HTTPS
                        "https://104.154.52.39",
                        "https://104.154.52.39:3000",
                        "https://104.154.52.39:8080",
                        // IP with HTTP
                        "http://104.154.52.39",
                        "http://104.154.52.39:3000",
                        "http://104.154.52.39:8080",
                        // Local development
                        "http://localhost:3000",
                        "http://localhost:8080"
                )
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH", "HEAD")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}