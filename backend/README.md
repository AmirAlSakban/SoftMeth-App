# Tutorial Management System - Spring Boot REST API

This project is a Spring Boot application that implements a CRUD API for managing tutorials. It follows a three-layer architecture (Controller, Service, Repository) and uses an H2 in-memory database. Comprehensive unit tests cover both Service and Controller layers for both successful operations and error scenarios.

## Project Architecture

### Layers
- **Controller Layer**: Handles HTTP requests/responses and input validation
- **Service Layer**: Contains business logic and workflow
- **Repository Layer**: Manages data persistence using Spring Data JPA
- **Model**: Data model representing tutorial entities

### Key Features
- Complete CRUD operations for tutorial management
- Search capabilities (by ID, title, or published status)
- Well-defined error handling
- Comprehensive test coverage

## Technology Stack

- **Framework**: Spring Boot 3.1.0
- **Database**: H2 In-Memory 
- **ORM**: Spring Data JPA
- **Testing**: JUnit 5 & Mockito
- **Build Tool**: Maven

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tutorials` | Get all tutorials or search by title |
| GET | `/api/tutorials/{id}` | Get tutorial by ID |
| POST | `/api/tutorials` | Create a new tutorial |
| PUT | `/api/tutorials/{id}` | Update tutorial by ID |
| DELETE | `/api/tutorials/{id}` | Delete tutorial by ID |
| DELETE | `/api/tutorials` | Delete all tutorials |
| GET | `/api/tutorials/published` | Get all published tutorials |

## Running the Application

### Option 1: Using the provided Run Configuration
1. Open the project in your IDE
2. Use the run configuration in `.run/application.run.json`

### Option 2: Using Maven
```bash
mvn spring-boot:run
```

## Running the Tests

### Option 1: Using the provided Run Configuration
1. Use the run configuration in `.run/tests.run.json`

### Option 2: Using Maven Command
```bash
mvn test
```

## H2 Database Console

Access the H2 in-memory database console at:
- URL: http://localhost:8080/h2-ui
- JDBC URL: `jdbc:h2:mem:testdb`
- Username: `sa`
- Password: (leave empty)

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/amiral/spring/tutorial/
│   │       ├── controller/
│   │       │   └── TutorialController.java
│   │       ├── model/
│   │       │   └── Tutorial.java
│   │       ├── repository/
│   │       │   └── TutorialRepository.java
│   │       ├── service/
│   │       │   ├── TutorialService.java
│   │       │   └── TutorialServiceImpl.java
│   │       └── TutorialManagementApplication.java
│   └── resources/
│       └── application.properties
├── test/
│   └── java/
│       └── com/amiral/spring/tutorial/
│           ├── service/
│           │   └── TutorialServiceTests.java
│           ├── TutorialControllerTests.java
│           └── TutorialManagementApplicationTests.java
└── .run/
    ├── application.run.json
    └── tests.run.json
```

## Testing Strategy

### Service Layer Tests
- Test all business methods with both valid and invalid inputs
- Mock repository responses for isolation
- Test error handling and edge cases

### Controller Layer Tests
- Use MockMVC to simulate HTTP requests
- Test response status codes and response bodies
- Cover both success and error scenarios

## Run Spring Boot application
```
mvn spring-boot:run
```

