# Setup Guide for Tutorial Management App

This guide provides step-by-step instructions to set up all the necessary tools and dependencies for the Tutorial Management App.

## Prerequisites Installation

### 1. Java Development Kit (JDK)

1. Download and install JDK 17 or higher from [Oracle's website](https://www.oracle.com/java/technologies/javase-downloads.html) or use OpenJDK.
2. Set the `JAVA_HOME` environment variable:
   ```
   setx JAVA_HOME "C:\Path\To\Your\JDK"
   ```
3. Add Java to your PATH:
   ```
   setx PATH "%PATH%;%JAVA_HOME%\bin"
   ```
4. Verify installation:
   ```
   java -version
   ```

### 2. Maven

1. Download Maven from [Apache Maven website](https://maven.apache.org/download.cgi)
2. Extract it to a directory, e.g., `C:\Program Files\Apache\maven`
3. Set the `M2_HOME` environment variable:
   ```
   setx M2_HOME "C:\Program Files\Apache\maven"
   ```
4. Add Maven to your PATH:
   ```
   setx PATH "%PATH%;%M2_HOME%\bin"
   ```
5. Verify installation:
   ```
   mvn -version
   ```

### 3. Flutter SDK

1. Download Flutter SDK from [Flutter website](https://flutter.dev/docs/get-started/install/windows)
2. Extract the ZIP file to a location like `C:\flutter`
3. Add Flutter to your PATH:
   ```
   setx PATH "%PATH%;C:\flutter\bin"
   ```
4. Verify installation and dependencies:
   ```
   flutter doctor
   ```
5. Accept Android licenses if needed:
   ```
   flutter doctor --android-licenses
   ```

### 4. Python

1. Download and install Python 3.8+ from [Python's website](https://www.python.org/downloads/)
2. Ensure "Add Python to PATH" is checked during installation
3. Verify installation:
   ```
   python --version
   pip --version
   ```

## Installing Project Dependencies

After installing the prerequisites, follow these steps to set up the project:

### 1. Clone the Repository

```
git clone https://github.com/AmirAlSakban/SoftMeth-App.git
cd "SoftMeth App"
```

### 2. Backend Setup

```
cd backend
mvn clean install
```

### 3. Frontend Setup

```
cd frontend
flutter pub get
```

### 4. Additional Tools

```
pip install -r requirements.txt
```

## Running the Application

### Start the Backend

```
cd backend
mvn spring-boot:run
```

### Start the Frontend

```
cd frontend
flutter run
```

Alternatively, use the provided script to start both:

```
start-app.bat
```

## Troubleshooting

### Java/Maven Issues

- Ensure JAVA_HOME is set correctly
- Ensure Maven is in your PATH
- Try cleaning the Maven cache: `mvn clean`

### Flutter Issues

- Run `flutter doctor` to diagnose issues
- Update Flutter: `flutter upgrade`
- Clean the build: `flutter clean`

### Python Issues

- Use a virtual environment:
  ```
  python -m venv venv
  venv\Scripts\activate
  pip install -r requirements.txt
  ```
