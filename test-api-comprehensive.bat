@echo off
echo ========================================
echo Testing Tutorial Management API
echo ========================================
echo.

echo Waiting for server to start...
timeout /t 5 /nobreak > nul
echo.

echo 1. Testing GET /api/tutorials (should return empty array initially)
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials' -Method Get; Write-Host 'Success: Found' $response.Count 'tutorials'; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo 2. Testing POST /api/tutorials (creating a new tutorial)
powershell -Command "try { $body = @{ title = 'Flutter Basics'; description = 'Learn Flutter development from scratch with practical examples'; category = 'Mobile Development'; author = 'Jane Doe'; difficultyLevel = 'Beginner'; durationMinutes = 45; published = $true; featured = $false; imageUrl = 'https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png'; videoUrl = 'https://www.youtube.com/watch?v=example' } | ConvertTo-Json; $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials' -Method Post -Body $body -ContentType 'application/json'; Write-Host 'Success: Created tutorial with ID' $response.id; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo 3. Testing POST /api/tutorials (creating another tutorial)
powershell -Command "try { $body = @{ title = 'React Native Guide'; description = 'Complete guide to React Native development'; category = 'Mobile Development'; author = 'John Smith'; difficultyLevel = 'Intermediate'; durationMinutes = 60; published = $true; featured = $true; imageUrl = 'https://reactnative.dev/img/header_logo.svg' } | ConvertTo-Json; $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials' -Method Post -Body $body -ContentType 'application/json'; Write-Host 'Success: Created tutorial with ID' $response.id; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo 4. Testing GET /api/tutorials (should now return tutorials)
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials' -Method Get; Write-Host 'Success: Found' $response.Count 'tutorials'; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo 5. Testing GET /api/tutorials/published (published tutorials only)
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials/published' -Method Get; Write-Host 'Success: Found' $response.Count 'published tutorials'; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo 6. Testing GET /api/tutorials/1 (get specific tutorial)
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials/1' -Method Get; Write-Host 'Success: Retrieved tutorial:' $response.title; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo 7. Testing PUT /api/tutorials/1 (update tutorial)
powershell -Command "try { $body = @{ title = 'Flutter Basics - Updated'; description = 'Learn Flutter development from scratch with practical examples and new content'; category = 'Mobile Development'; author = 'Jane Doe'; difficultyLevel = 'Beginner'; durationMinutes = 50; published = $true; featured = $true; imageUrl = 'https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png'; videoUrl = 'https://www.youtube.com/watch?v=updated' } | ConvertTo-Json; $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials/1' -Method Put -Body $body -ContentType 'application/json'; Write-Host 'Success: Updated tutorial:' $response.title; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo 8. Testing search functionality - GET /api/tutorials?title=Flutter
powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:8080/api/tutorials?title=Flutter' -Method Get; Write-Host 'Success: Found' $response.Count 'tutorials matching Flutter'; $response | ConvertTo-Json -Depth 3 } catch { Write-Host 'Error:' $_.Exception.Message }"
echo.

echo ========================================
echo API Testing Complete
echo ========================================
pause
