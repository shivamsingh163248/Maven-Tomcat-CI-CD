# Maven Tomcat Web Application - CI/CD Pipeline

This repository contains a comprehensive CI/CD pipeline for a Java web application built with Maven and deployed on Tomcat.

## CI/CD Pipeline Features

### 🚀 **Automated Build & Test**
- **Java 21** with Maven 3.9.7
- Automated compilation and testing
- Test report generation
- WAR artifact creation and upload

### 🔍 **Code Quality & Security**
- **Static Analysis**: SpotBugs for bug detection
- **Code Style**: Checkstyle for consistent formatting
- **Security Scanning**: OWASP Dependency Check for vulnerabilities
- **Code Coverage**: JaCoCo for test coverage reports

### 🐳 **Containerization**
- **Multi-stage Docker build** for optimization
- **Docker Compose** for local development
- **Health checks** and monitoring
- **Automated image building and pushing**

### 🚦 **Deployment Stages**
- **Staging Environment**: Auto-deploy from `develop` branch
- **Production Environment**: Auto-deploy from `main` branch with approvals
- **Health checks** after deployment
- **Rollback capabilities**

## Workflow Triggers

The CI/CD pipeline runs on:
- **Push** to `main` or `develop` branches
- **Pull Request** to `main` branch  
- **Manual trigger** via GitHub Actions UI

## Pipeline Jobs

### 1. **Build and Test**
```yaml
- Checkout code
- Setup JDK 21
- Cache Maven dependencies
- Compile and run tests
- Generate test reports
- Package WAR file
- Upload artifacts
```

### 2. **Code Quality Analysis**
```yaml
- Run SpotBugs analysis
- Execute Checkstyle checks
- Generate quality reports
```

### 3. **Security Scan**
```yaml
- OWASP Dependency Check
- Vulnerability assessment
- Security report generation
```

### 4. **Docker Build** (Main branch only)
```yaml
- Build optimized Docker image
- Push to Docker registry
- Multi-platform support
```

### 5. **Deploy to Staging** (Develop branch)
```yaml
- Download artifacts
- Deploy to staging environment
- Run staging tests
```

### 6. **Deploy to Production** (Main branch)
```yaml
- Require manual approval
- Deploy to production
- Health checks
- Notification on completion
```

## Required Secrets

Add these secrets to your GitHub repository:

```
DOCKER_USERNAME          # Docker Hub username
DOCKER_PASSWORD          # Docker Hub password or token
STAGING_SERVER_HOST      # Staging server hostname
STAGING_SERVER_USER      # Staging server username
STAGING_SSH_KEY          # SSH private key for staging
PRODUCTION_SERVER_HOST   # Production server hostname
PRODUCTION_SERVER_USER   # Production server username
PRODUCTION_SSH_KEY       # SSH private key for production
```

## Local Development

### Using Maven
```bash
# Build and test
mvn clean package

# Run with embedded Tomcat
mvn tomcat7:run

# Run with Jetty
mvn jetty:run
```

### Using Docker
```bash
# Build and run with Docker Compose
docker-compose up --build

# Access application
# http://localhost:8080/webapp-demo
```

## Environment Configuration

### Staging Environment
- **Branch**: `develop`
- **Auto-deployment**: Yes
- **Tests**: Automated testing after deployment

### Production Environment  
- **Branch**: `main`
- **Auto-deployment**: Yes (with approval)
- **Health Checks**: Mandatory
- **Rollback**: Available

## Code Quality Standards

- **Java Code Style**: Google Java Style Guide
- **Test Coverage**: Minimum 70%
- **Security**: No high-severity vulnerabilities
- **Performance**: Response time < 2 seconds

## Monitoring & Notifications

- **Build Status**: GitHub status checks
- **Deployment Status**: Environment-specific notifications
- **Security Alerts**: Automated CVE notifications
- **Performance**: Health check monitoring

## Getting Started

1. **Fork this repository**
2. **Configure secrets** in repository settings
3. **Update server configurations** in workflow files
4. **Push changes** to trigger the pipeline
5. **Monitor** build status in Actions tab

## Support

For issues with the CI/CD pipeline:
1. Check the **Actions** tab for build logs
2. Review **artifact uploads** for test reports
3. Check **environment configurations**
4. Verify **secrets and permissions**