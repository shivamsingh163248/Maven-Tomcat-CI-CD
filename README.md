# Maven Tomcat Web Application

[![Build, Test & Docker Deploy](https://github.com/shivamsingh163248/Maven-Tomcat-CI-CD/actions/workflows/docker-build-deploy.yml/badge.svg)](https://github.com/shivamsingh163248/Maven-Tomcat-CI-CD/actions/workflows/docker-build-deploy.yml)
[![Simple CI](https://github.com/shivamsingh163248/Maven-Tomcat-CI-CD/actions/workflows/simple-ci.yml/badge.svg)](https://github.com/shivamsingh163248/Maven-Tomcat-CI-CD/actions/workflows/simple-ci.yml)

## Project Overview
This is a comprehensive Java web application built with Maven, designed to run on Apache Tomcat server, and equipped with complete CI/CD pipeline including Docker containerization.

## Technologies Used
- **Java**: 21 (LTS)
- **Maven**: 3.9.7
- **Servlet API**: Jakarta Servlet 6.0
- **JSP**: Jakarta Server Pages 3.1
- **Server**: Apache Tomcat 10+

## Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/example/
│   │       └── HelloServlet.java
│   └── webapp/
│       ├── index.jsp
│       └── WEB-INF/
│           └── web.xml
├── pom.xml
└── tomcat-users.xml
```

## How to Run Locally

### Prerequisites
- Java 21 (JDK)
- Maven 3.6+
- Apache Tomcat 10+ (for standalone deployment)

### Method 1: Using Maven with Jetty (Recommended for Development)
1. **Clean and compile the project:**
   ```bash
   mvn clean compile
   ```

2. **Package the application:**
   ```bash
   mvn clean package
   ```

3. **Run with embedded Jetty server:**
   ```bash
   mvn jetty:run
   ```
   - Access the application at: http://localhost:8080/webapp-demo

### Method 1b: Using Tomcat Maven Plugin
1. **Run with Tomcat plugin:**
   ```bash
   mvn tomcat7:run
   ```
   - Access the application at: http://localhost:8080/webapp-demo

### Method 2: Deploy to Standalone Tomcat
1. **Build the WAR file:**
   ```bash
   mvn clean package
   ```

2. **Copy the WAR file to Tomcat:**
   - Copy `target/webapp-demo.war` to `TOMCAT_HOME/webapps/`

3. **Start Tomcat:**
   - Windows: `TOMCAT_HOME/bin/startup.bat`
   - Linux/Mac: `TOMCAT_HOME/bin/startup.sh`

4. **Access the application:**
   - URL: http://localhost:8080/webapp-demo

### Method 3: Using Tomcat Manager (Deployment)
1. **Ensure Tomcat is running with manager app**
2. **Configure Maven settings** (if not already done)
3. **Deploy using Maven:**
   ```bash
   mvn tomcat7:deploy
   ```

## Application Features
- **Welcome Page**: `index.jsp` with a form to enter your name
- **Servlet Response**: `HelloServlet` processes the form and displays personalized greeting
- **Server Information**: Displays current server info and timestamp

## URLs
- **Home Page**: http://localhost:8080/webapp-demo/
- **Hello Servlet**: http://localhost:8080/webapp-demo/hello?name=YourName

## 🐳 Docker Usage

### Pull from GitHub Container Registry
```bash
# Pull the latest image
docker pull ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:latest

# Pull a specific version
docker pull ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:main-20241121-abcd1234
```

### Run with Docker
```bash
# Run the container
docker run -d -p 8080:8080 \
  --name webapp-demo \
  ghcr.io/shivamsingh163248/maven-tomcat-ci-cd:latest

# View logs
docker logs webapp-demo

# Access application
curl http://localhost:8080/webapp-demo/
```

### Using Docker Compose
```bash
# Start the application
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the application
docker-compose down
```

## 🚀 CI/CD Pipeline

The project includes comprehensive GitHub Actions workflows:

### **Docker Build & Deploy Workflow**
- **Triggers**: Push to main/develop, tags, manual dispatch
- **Features**:
  - ✅ Build and test with Maven
  - ✅ Create multi-platform Docker images (amd64/arm64)
  - ✅ Push to GitHub Container Registry
  - ✅ Branch-based tagging
  - ✅ Security vulnerability scanning
  - ✅ Automated deployment notifications

### **Available Docker Tags**
- `latest` - Latest main branch build
- `main-YYYYMMDD-commit` - Main branch with date and commit
- `develop-YYYYMMDD-commit` - Develop branch builds
- `v1.0.0` - Tagged releases
- `pr-123` - Pull request builds

## Configuration Files
- **pom.xml**: Maven project configuration with CI/CD plugins
- **web.xml**: Web application deployment descriptor
- **tomcat-users.xml**: Tomcat user configuration for manager access
- **Dockerfile**: Multi-stage Docker build configuration
- **docker-compose.yml**: Local development setup

## Development Notes
- Uses Jakarta EE 9+ specifications (not javax)
- Configured for Java 21
- WAR packaging for web application deployment
- Includes comprehensive testing with JUnit 5 and Mockito
- Code quality checks with SpotBugs and Checkstyle
- Security scanning with OWASP Dependency Check
- Multi-platform Docker support (AMD64/ARM64)

## Troubleshooting
1. **Port 8080 already in use**: Change port in Tomcat configuration or Docker run command
2. **Java version mismatch**: Ensure Java 21 is installed and JAVA_HOME is set
3. **Maven not found**: Ensure Maven is installed and added to PATH
4. **Docker build fails**: Check Docker daemon is running and you have permissions
5. **GitHub Actions fails**: Check repository secrets and permissions

## Build Commands
```bash
# Local development
mvn clean compile          # Compile only
mvn test                  # Run tests
mvn clean package         # Build WAR file
mvn tomcat7:run           # Run with embedded Tomcat
mvn jetty:run             # Run with embedded Jetty

# Docker commands
docker build -t webapp-demo .                    # Build image
docker run -p 8080:8080 webapp-demo             # Run container
docker-compose up --build                       # Build and run with compose

# CI/CD commands
git push origin main                             # Trigger main branch workflow
git push origin develop                         # Trigger develop branch workflow
git tag v1.0.0 && git push origin v1.0.0       # Trigger release workflow
```