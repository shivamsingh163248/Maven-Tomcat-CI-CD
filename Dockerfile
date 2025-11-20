# Multi-stage build for Java Web Application
FROM maven:3.9.7-eclipse-temurin-21 AS build

# Build arguments
ARG VERSION=development
ARG BRANCH=unknown
ARG COMMIT=unknown

# Set working directory
WORKDIR /app

# Copy pom.xml first for better caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application with version info
RUN mvn clean package -DskipTests -Dproject.version=${VERSION}

# Production stage
FROM tomcat:10.1-jdk21-temurin

# Build arguments for metadata
ARG VERSION=development
ARG BRANCH=unknown
ARG COMMIT=unknown
ARG BUILD_DATE
ARG GITHUB_SHA

# Add metadata labels
LABEL org.opencontainers.image.title="Maven Tomcat Web Application" \
      org.opencontainers.image.description="Java Web Application built with Maven and deployed on Tomcat" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${COMMIT}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      app.version="${VERSION}" \
      app.branch="${BRANCH}" \
      app.commit="${COMMIT}" \
      app.build-date="${BUILD_DATE}"

# Install curl for health checks
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file to Tomcat webapps directory (from CI or build stage)
COPY target/*.war /usr/local/tomcat/webapps/webapp-demo.war

# Copy tomcat configuration
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

# Create directories and set permissions
RUN mkdir -p /usr/local/tomcat/logs && \
    chmod +x /usr/local/tomcat/bin/*.sh && \
    chown -R 1000:1000 /usr/local/tomcat

# Set environment variables
ENV CATALINA_HOME=/usr/local/tomcat \
    PATH=$CATALINA_HOME/bin:$PATH \
    JAVA_OPTS="-Djava.awt.headless=true -Xmx512m -XX:+UseG1GC -XX:+UseStringDeduplication" \
    CATALINA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=UTC" \
    APP_VERSION="${VERSION}" \
    APP_BRANCH="${BRANCH}" \
    APP_COMMIT="${COMMIT}"

# Create non-root user for security
RUN groupadd -r tomcat && useradd -r -g tomcat -u 1000 tomcat
USER tomcat

# Expose port
EXPOSE 8080

# Health check with better endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/webapp-demo/ || exit 1

# Add startup script for better logging
COPY --chown=tomcat:tomcat <<EOF /usr/local/tomcat/bin/startup-with-info.sh
#!/bin/bash
echo "==================================="
echo "Starting Tomcat Web Application"
echo "Version: \${APP_VERSION:-unknown}"
echo "Branch: \${APP_BRANCH:-unknown}" 
echo "Commit: \${APP_COMMIT:-unknown}"
echo "Java Version: \$(java -version 2>&1 | head -n 1)"
echo "Tomcat Version: \$(catalina.sh version | grep 'Server version')"
echo "==================================="
exec catalina.sh run
EOF

RUN chmod +x /usr/local/tomcat/bin/startup-with-info.sh

# Start Tomcat with info
CMD ["/usr/local/tomcat/bin/startup-with-info.sh"]