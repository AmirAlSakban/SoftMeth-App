@echo off
echo ========================================
echo Tutorial Management App - Quick Start
echo ========================================
echo.

echo This script will help you start both backend and frontend servers.
echo.

echo Step 1: Starting Backend Server...
echo Opening new command window for backend...
start "Backend Server" cmd /k "cd /d \"%~dp0backend\" && echo Starting Spring Boot server... && mvn spring-boot:run"

echo.
echo Step 2: Waiting for backend to start...
echo Please wait 10 seconds for the backend to initialize...
timeout /t 10 /nobreak

echo.
echo Step 3: Starting Frontend...
echo Opening new command window for frontend...
start "Frontend App" cmd /k "cd /d \"%~dp0frontend\" && echo Getting Flutter dependencies... && flutter pub get && echo Starting Flutter app... && flutter run"

echo.
echo ========================================
echo Quick Start Complete!
echo ========================================
echo.
echo Two new command windows should have opened:
echo 1. Backend Server (Spring Boot on port 8080)
echo 2. Frontend App (Flutter)
echo.
echo If you encounter any issues, refer to TESTING_GUIDE.md
echo.
pause
