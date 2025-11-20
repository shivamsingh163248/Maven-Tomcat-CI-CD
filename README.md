# Maven Tomcat Web Application

## Project Overview
This is a basic Java web application built with Maven and designed to run on Apache Tomcat server.

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

## Configuration Files
- **pom.xml**: Maven project configuration
- **web.xml**: Web application deployment descriptor
- **tomcat-users.xml**: Tomcat user configuration for manager access

## Development Notes
- Uses Jakarta EE 9+ specifications (not javax)
- Configured for Java 21
- WAR packaging for web application deployment
- Includes Tomcat Maven plugin for easy development

## Troubleshooting
1. **Port 8080 already in use**: Change port in Tomcat configuration
2. **Java version mismatch**: Ensure Java 21 is installed and JAVA_HOME is set
3. **Maven not found**: Ensure Maven is installed and added to PATH
4. **Servlet errors**: Check that jakarta.servlet dependencies are resolved

## Build Status
- Clean compile: `mvn clean compile`
- Run tests: `mvn test`
- Package: `mvn clean package`
- Deploy: `mvn tomcat7:deploy` (requires running Tomcat with manager)