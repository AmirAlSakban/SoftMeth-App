# Tutorial Management App - Testing Guide

This guide provides step-by-step instructions to test the complete functionality of the Tutorial Management App.

## 📋 Prerequisites

Before testing, ensure you have the following installed:

- **Java 17 or higher** (for Spring Boot backend)
- **Maven 3.6+** (for building backend)
- **Flutter SDK 3.0.0+** (for frontend)
- **Android Studio or VS Code** (recommended IDEs)
- **Git** (for version control)

### Verify Prerequisites

```cmd
# Check Java version
java -version

# Check Maven version
mvn -version

# Check Flutter version
flutter --version

# Check Flutter doctor (diagnoses issues)
flutter doctor
```

## 🚀 Step-by-Step Testing Instructions

### Phase 1: Backend Testing (Spring Boot API)

#### Step 1.1: Navigate to Backend Directory
```cmd
cd "c:\Users\LenovoT580\Documents\GitHub\SoftMeth App\backend"
```

#### Step 1.2: Clean and Test Backend
```cmd
# Clean previous builds and run tests
mvn clean test

# This should show:
# - All tests passing
# - No compilation errors
# - Success message
```

#### Step 1.3: Start Backend Server
```cmd
# Start the Spring Boot server
mvn spring-boot:run

# Expected output:
# - Server starts on port 8080
# - "Started SpringBootRestControllerUnitTestApplication"
# - No error messages
```

**⚠️ Keep this terminal open - the server must stay running for frontend testing**

#### Step 1.4: Test Backend API Endpoints

Open a **new terminal** and run:

```cmd
cd "c:\Users\LenovoT580\Documents\GitHub\SoftMeth App"

# Test 1: Get all tutorials (should return empty array)
powershell -Command "Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials' -Method Get"

# Expected: [] (empty array)
```

```cmd
# Test 2: Create a tutorial
powershell -Command "$body = @{ title = 'Test Tutorial'; description = 'Testing the API'; category = 'Testing'; author = 'Test Author'; difficultyLevel = 'Beginner'; durationMinutes = 30; published = $true; featured = $false } | ConvertTo-Json; Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials' -Method Post -Body $body -ContentType 'application/json'"

# Expected: Tutorial object with id=1
```

```cmd
# Test 3: Get all tutorials (should now return the created tutorial)
powershell -Command "Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials' -Method Get"

# Expected: Array with one tutorial object
```

```cmd
# Test 4: Get tutorial by ID
powershell -Command "Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials/1' -Method Get"

# Expected: Single tutorial object
```

```cmd
# Test 5: Update tutorial
powershell -Command "$body = @{ title = 'Updated Test Tutorial'; description = 'Updated description'; category = 'Testing'; author = 'Test Author'; difficultyLevel = 'Intermediate'; durationMinutes = 45; published = $true; featured = $true } | ConvertTo-Json; Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials/1' -Method Put -Body $body -ContentType 'application/json'"

# Expected: Updated tutorial object
```

```cmd
# Test 6: Search tutorials
powershell -Command "Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials?title=Updated' -Method Get"

# Expected: Array with matching tutorials
```

**✅ Backend Testing Complete** if all tests return expected results.

### Phase 2: Frontend Testing (Flutter App)

#### Step 2.1: Navigate to Frontend Directory
```cmd
cd "c:\Users\LenovoT580\Documents\GitHub\SoftMeth App\frontend"
```

#### Step 2.2: Install Flutter Dependencies
```cmd
# Get Flutter packages
flutter pub get

# Expected: "Got dependencies!" message
```

#### Step 2.3: Verify Flutter Setup
```cmd
# Check for issues
flutter doctor

# Check available devices
flutter devices

# Expected: At least one device available (emulator, web, or physical device)
```

#### Step 2.4: Run Flutter App
```cmd
# Start the Flutter app (choose your preferred method)

# Option A: Run on Chrome (web)
flutter run -d chrome

# Option B: Run on Android emulator (if available)
flutter run -d android

# Option C: Run on any available device
flutter run
```

**Expected Flutter app startup sequence:**
1. App compiles successfully
2. App launches on selected device/browser
3. Tutorial Management App opens
4. Tutorial list screen appears

### Phase 3: End-to-End Functionality Testing

With both backend (port 8080) and frontend running:

#### Test 3.1: Tutorial List Screen
- ✅ App loads without errors
- ✅ Tutorial list appears (may show the test tutorial created earlier)
- ✅ Search bar is visible and functional
- ✅ Filter toggle works (Published/All)
- ✅ Refresh button works
- ✅ FAB (+ button) is visible

#### Test 3.2: Add Tutorial Functionality
1. **Tap the + (FAB) button**
   - ✅ Add Tutorial screen opens
   
2. **Fill out the form:**
   - Title: "Flutter UI Testing"
   - Description: "Learn how to test Flutter user interfaces"
   - Category: "Mobile Development"
   - Author: "UI Tester"
   - Difficulty: Select "Intermediate"
   - Duration: "60"
   - Image URL: "https://flutter.dev/images/flutter-logo-sharing.png"
   - Video URL: "https://youtube.com/watch?v=test"
   - Toggle "Published" to ON
   - Toggle "Featured" to ON

3. **Tap "CREATE TUTORIAL"**
   - ✅ Loading indicator appears
   - ✅ Success message shows
   - ✅ Returns to tutorial list
   - ✅ New tutorial appears in list

#### Test 3.3: Search Functionality
1. **In the search bar, type "Flutter"**
   - ✅ Results filter in real-time
   - ✅ Only matching tutorials show

2. **Clear search**
   - ✅ All tutorials appear again

#### Test 3.4: Edit Tutorial Functionality
1. **Tap the edit icon on any tutorial card**
   - ✅ Edit screen opens with pre-filled data
   
2. **Modify some fields:**
   - Change title to add " - Updated"
   - Change duration to "75"
   - Toggle "Featured" status

3. **Tap "UPDATE TUTORIAL"**
   - ✅ Loading indicator appears
   - ✅ Success message shows
   - ✅ Returns to tutorial list
   - ✅ Changes are reflected in the list

#### Test 3.5: Tutorial Detail View
1. **Tap on any tutorial card (not the edit button)**
   - ✅ Detail screen opens
   - ✅ All tutorial information displays correctly
   - ✅ Back button returns to list

#### Test 3.6: Delete Tutorial Functionality
1. **Go to edit screen of any tutorial**
2. **Tap "Delete Tutorial" button**
   - ✅ Confirmation dialog appears
3. **Confirm deletion**
   - ✅ Success message shows
   - ✅ Returns to tutorial list
   - ✅ Tutorial is removed from list

#### Test 3.7: Filter Functionality
1. **Toggle "Show Published Only" filter**
   - ✅ Only published tutorials show
2. **Toggle back to "Show All"**
   - ✅ All tutorials appear again

## 🔄 Automated Testing Script

For quick API testing, run the comprehensive test script:

```cmd
cd "c:\Users\LenovoT580\Documents\GitHub\SoftMeth App"
test-api-comprehensive.bat
```

This script will:
- Test all API endpoints
- Create sample data
- Verify CRUD operations
- Test search functionality

## 🐛 Troubleshooting

### Backend Issues

**Port 8080 already in use:**
```cmd
# Find process using port 8080
netstat -ano | findstr :8080

# Kill the process (replace XXXX with actual PID)
taskkill /PID XXXX /F

# Restart backend
mvn spring-boot:run
```

**Maven build fails:**
```cmd
# Clean and retry
mvn clean
mvn compile
mvn spring-boot:run
```

### Frontend Issues

**Flutter build fails:**
```cmd
# Clean Flutter build
flutter clean
flutter pub get
flutter run
```

**No devices available:**
```cmd
# For web testing
flutter run -d chrome

# For Android emulator (if Android Studio installed)
flutter emulators --launch <emulator_name>
```

**API connection fails:**
- ✅ Verify backend is running on port 8080
- ✅ Check CORS settings in backend
- ✅ Ensure no firewall blocking localhost connections

### Network Issues

**CORS errors:**
- Backend CORS is configured for `http://localhost:3000`
- If Flutter runs on different port, update backend CORS configuration

**Connection refused:**
- Ensure backend is running and accessible at `http://localhost:8080`
- Test backend API directly before testing frontend

## ✅ Success Criteria

The application is working correctly if:

1. **Backend**: All API endpoints respond correctly
2. **Frontend**: App loads and displays tutorials
3. **Integration**: Can create, read, update, delete tutorials through UI
4. **Search**: Search functionality filters results
5. **Validation**: Form validation prevents invalid submissions
6. **Error Handling**: Appropriate error messages for failures
7. **Navigation**: Can navigate between all screens

## 📊 Test Results Checklist

- [ ] Backend starts without errors
- [ ] All API endpoints return expected responses
- [ ] Frontend builds and runs successfully
- [ ] Tutorial list loads and displays data
- [ ] Can create new tutorials through UI
- [ ] Can edit existing tutorials
- [ ] Can delete tutorials with confirmation
- [ ] Search functionality works
- [ ] Form validation prevents invalid data
- [ ] Navigation between screens works
- [ ] Error messages appear for failures
- [ ] Loading states show during API calls

**🎉 If all items are checked, the Tutorial Management App is fully functional!**
