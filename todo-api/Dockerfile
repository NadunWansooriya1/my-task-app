# ==============================
# Stage 1: Build JAR (Maven + JDK)
# ==============================
FROM maven:3.9-eclipse-temurin-21-alpine AS builder
WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source + build
COPY src ./src
RUN mvn clean package -DskipTests -B

# ==============================
# Stage 2: Runtime (JRE only)
# ==============================
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy JAR
COPY --from=builder /app/target/*.jar app.jar

# Security: non-root user
USER 1001

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]