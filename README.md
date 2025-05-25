# Tutorial Management App

A unified full-stack application combining Spring Boot backend and Flutter frontend for managing educational tutorials.

## Project Structure

```
├── backend/           # Spring Boot REST API
│   ├── src/
│   ├── pom.xml
│   └── README.md
├── frontend/          # Flutter mobile app
│   ├── lib/
│   ├── pubspec.yaml
│   └── README.md
├── README.md         # Main documentation (this file)
├── TESTING_GUIDE.md  # Comprehensive testing instructions
├── PROJECT_COMPLETION_SUMMARY.md # Development summary
├── CHANGELOG.md      # Version history
├── start-app.bat     # Quick start script
├── test-api-comprehensive.bat # API testing script
├── .gitignore        # Git ignore rules
└── package.json      # Project metadata
```

## Features

### Backend (Spring Boot)
- RESTful API for tutorial management
- CRUD operations (Create, Read, Update, Delete)
- H2 in-memory database for development
- Comprehensive tutorial model with fields:
  - Basic info: title, description, category, author
  - Metadata: difficulty level, duration, publication status
  - Media: image URL, video URL
  - Timestamps: created/updated dates

### Frontend (Flutter)
- Modern Material Design UI
- Tutorial list with search and filtering
- Add new tutorials with form validation
- Edit existing tutorials
- Tutorial detail view
- Responsive design for various screen sizes

## Tutorial Model

The unified Tutorial model includes:

```json
{
  "id": 1,
  "title": "Getting Started with Flutter",
  "description": "Learn the basics of Flutter development",
  "category": "Mobile Development",
  "author": "John Doe",
  "difficultyLevel": "Beginner",
  "durationMinutes": 30,
  "published": true,
  "featured": false,
  "imageUrl": "https://example.com/image.jpg",
  "videoUrl": "https://example.com/video.mp4",
  "createdAt": "2025-05-25T10:00:00Z",
  "updatedAt": "2025-05-25T10:00:00Z"
}
```

## Getting Started

### Quick Start (Recommended)
For the fastest setup, run the automated startup script:
```cmd
start-app.bat
```
This will automatically start both backend and frontend servers.

### Manual Setup

#### Prerequisites
- Java 17 or higher
- Maven 3.6+
- Flutter SDK 3.0.0+
- Android Studio or VS Code

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies and run tests:
   ```bash
   mvn clean test
   ```

3. Start the Spring Boot server:
   ```bash
   mvn spring-boot:run
   ```

   The backend will be available at `http://localhost:8080`

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the Flutter app:
   ```bash
   flutter run
   ```

   The app will connect to the backend at `http://localhost:8080/api`

## API Endpoints

### Tutorials
- `GET /api/tutorials` - Get all tutorials
- `GET /api/tutorials/{id}` - Get tutorial by ID
- `GET /api/tutorials/published` - Get only published tutorials
- `POST /api/tutorials` - Create new tutorial
- `PUT /api/tutorials/{id}` - Update tutorial
- `DELETE /api/tutorials/{id}` - Delete tutorial
- `GET /api/tutorials?title={keyword}` - Search tutorials by title

## Configuration

### CORS Settings
The backend is configured to accept requests from `http://localhost:3000` (Flutter's default development port).

### Database
Uses H2 in-memory database for development. Database console available at:
`http://localhost:8080/h2-console`

Default connection:
- JDBC URL: `jdbc:h2:mem:testdb`
- Username: `sa`
- Password: (empty)

## Testing

For comprehensive testing instructions, see **[TESTING_GUIDE.md](TESTING_GUIDE.md)**.

### Quick API Test
```cmd
test-api-comprehensive.bat
```

### Development

### Adding New Features

1. **Backend**: Add new endpoints in `TutorialController.java`
2. **Frontend**: Create new screens in `lib/screens/`
3. **Models**: Update both backend and frontend models to maintain consistency

### Testing

- **Backend**: Run `mvn test` in the backend directory
- **Frontend**: Run `flutter test` in the frontend directory

## Build and Deployment

### Backend
```bash
cd backend
mvn clean package
java -jar target/tutorial-management-app-0.0.1-SNAPSHOT.jar
```

### Frontend
```bash
cd frontend
flutter build apk  # for Android
flutter build ios  # for iOS (requires macOS)
```

## Architecture

- **Backend**: Spring Boot with Spring Data JPA
- **Frontend**: Flutter with Material Design
- **Database**: H2 (development), can be configured for PostgreSQL/MySQL in production
- **API**: RESTful with JSON responses
- **State Management**: StatefulWidget with setState (can be upgraded to Provider/Riverpod)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly using `TESTING_GUIDE.md`
5. Submit a pull request

## Additional Resources

- **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Comprehensive step-by-step testing instructions
- **[PROJECT_COMPLETION_SUMMARY.md](PROJECT_COMPLETION_SUMMARY.md)** - Detailed summary of all completed features
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes
- **start-app.bat** - Quick start script to launch both backend and frontend
- **test-api-comprehensive.bat** - Automated API testing script

## Disclaimer

This is a school project created for educational purposes only.
