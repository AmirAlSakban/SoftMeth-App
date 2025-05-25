# Development Guide - Tutorial Management App

This guide provides detailed information for developers working on the Tutorial Management App.

## 🏗️ Architecture Overview

### System Architecture
```
┌─────────────────┐    HTTP/REST    ┌─────────────────┐
│   Flutter App   │ ──────────────► │  Spring Boot    │
│   (Frontend)    │                 │   (Backend)     │
│                 │ ◄────────────── │                 │
│ Port: 3000      │     JSON        │ Port: 8080      │
└─────────────────┘                 └─────────────────┘
                                              │
                                              ▼
                                    ┌─────────────────┐
                                    │   H2 Database   │
                                    │  (In-Memory)    │
                                    └─────────────────┘
```

### Technology Stack

#### Backend (Spring Boot)
- **Framework**: Spring Boot 3.1.0
- **Language**: Java 17+
- **Database**: H2 (development), configurable for production
- **Build Tool**: Maven
- **Testing**: JUnit 5, Spring Boot Test
- **API**: RESTful services with JSON

#### Frontend (Flutter)
- **Framework**: Flutter 3.0.0+
- **Language**: Dart
- **UI Framework**: Material Design
- **HTTP Client**: Built-in Dart HTTP package
- **State Management**: StatefulWidget (expandable to Provider/Bloc)

## 🛠️ Development Setup

### IDE Configuration

#### VS Code (Recommended)
Install these extensions:
- Extension Pack for Java
- Flutter
- Dart
- Spring Boot Extension Pack

#### Android Studio
- Pre-configured for Flutter development
- Good debugging tools
- Built-in emulator support

### Environment Variables
Create a `.env` file in the backend directory for production configurations:
```properties
# Database Configuration
SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/tutorial_db
SPRING_DATASOURCE_USERNAME=your_username
SPRING_DATASOURCE_PASSWORD=your_password

# Server Configuration
SERVER_PORT=8080
CORS_ALLOWED_ORIGINS=http://localhost:3000,https://yourfrontend.com

# Logging
LOGGING_LEVEL_ROOT=INFO
LOGGING_LEVEL_COM_TUTORIALMANAGER=DEBUG
```

## 📝 Code Standards

### Backend (Java)
- Follow Google Java Style Guide
- Use meaningful variable and method names
- Add JavaDoc comments for public methods
- Use `@RestController` for API endpoints
- Implement proper exception handling
- Use DTOs for API responses

Example controller method:
```java
/**
 * Retrieves all tutorials with optional title filtering
 * @param title Optional title filter
 * @return List of tutorials
 */
@GetMapping("/tutorials")
public ResponseEntity<List<Tutorial>> getAllTutorials(@RequestParam(required = false) String title) {
    try {
        List<Tutorial> tutorials = tutorialService.findByTitleContaining(title);
        return ResponseEntity.ok(tutorials);
    } catch (Exception e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}
```

### Frontend (Flutter/Dart)
- Follow Dart Style Guide
- Use meaningful widget and variable names
- Separate UI logic from business logic
- Use const constructors where possible
- Implement proper error handling
- Use async/await for API calls

Example API service method:
```dart
/// Fetches all tutorials from the backend
/// Returns a list of Tutorial objects or throws an exception
Future<List<Tutorial>> getAllTutorials() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/tutorials'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Tutorial.fromJson(json)).toList();
    } else {
      throw ApiException('Failed to load tutorials: ${response.statusCode}');
    }
  } catch (e) {
    throw ApiException('Network error: $e');
  }
}
```

## 🧪 Testing Strategy

### Backend Testing
1. **Unit Tests**: Test individual service methods
2. **Integration Tests**: Test API endpoints
3. **Repository Tests**: Test data access layer

Run backend tests:
```cmd
cd backend
mvn test
```

### Frontend Testing
1. **Widget Tests**: Test individual widgets
2. **Integration Tests**: Test app flow
3. **Unit Tests**: Test service classes

Run frontend tests:
```cmd
cd frontend
flutter test
```

## 📊 Database Design

### Tutorial Entity
```sql
CREATE TABLE tutorial (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    author VARCHAR(100),
    difficulty_level VARCHAR(50),
    duration_minutes INTEGER,
    published BOOLEAN DEFAULT FALSE,
    featured BOOLEAN DEFAULT FALSE,
    image_url VARCHAR(500),
    video_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Indexes for Performance
```sql
CREATE INDEX idx_tutorial_title ON tutorial(title);
CREATE INDEX idx_tutorial_category ON tutorial(category);
CREATE INDEX idx_tutorial_published ON tutorial(published);
CREATE INDEX idx_tutorial_featured ON tutorial(featured);
```

## 🔧 Configuration

### Backend Configuration (application.properties)
```properties
# Server Configuration
server.port=8080

# Database Configuration (H2 for development)
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# JPA Configuration
spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# H2 Console (development only)
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# CORS Configuration
tutorial.app.cors.allowed-origins=http://localhost:3000
```

### Frontend Configuration
The base API URL is configured in `lib/services/api_service.dart`:
```dart
class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  // For production: 'https://your-api-domain.com/api'
}
```

## 🚀 Deployment Guide

### Backend Deployment
1. **Build JAR file**:
   ```cmd
   mvn clean package
   ```

2. **Run with production profile**:
   ```cmd
   java -jar target/tutorial-management-app-1.0.0.jar --spring.profiles.active=prod
   ```

### Frontend Deployment
1. **Build for web**:
   ```cmd
   flutter build web
   ```

2. **Build APK for Android**:
   ```cmd
   flutter build apk --release
   ```

3. **Build iOS app**:
   ```cmd
   flutter build ios --release
   ```

## 🔍 Debugging Tips

### Backend Debugging
- Use H2 console: `http://localhost:8080/h2-console`
- Enable SQL logging in `application.properties`
- Use Postman or curl for API testing
- Check server logs for errors

### Frontend Debugging
- Use Flutter Inspector in your IDE
- Enable debug mode: `flutter run --debug`
- Use `print()` statements for quick debugging
- Check Flutter logs: `flutter logs`

## 📈 Performance Optimization

### Backend
- Use database indexes for frequent queries
- Implement pagination for large datasets
- Use caching for frequently accessed data
- Optimize SQL queries

### Frontend
- Use `const` constructors where possible
- Implement lazy loading for large lists
- Optimize image loading and caching
- Use `ListView.builder` for large lists

## 🤝 Contributing Guidelines

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** following the code standards
4. **Run tests** to ensure everything works
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to the branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Commit Message Format
```
type(scope): description

[optional body]

[optional footer]
```

Examples:
- `feat(api): add search functionality for tutorials`
- `fix(ui): resolve tutorial card layout issue`
- `docs(readme): update installation instructions`

## 📝 Additional Resources

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [RESTful API Design Best Practices](https://restfulapi.net/)
- [Material Design Guidelines](https://material.io/design)
