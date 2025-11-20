# Multi-stage build for Java Web Application
FROM maven:3.9.7-eclipse-temurin-21 AS build

# Build arguments
ARG VERSION=development
ARG SEMANTIC_VERSION=0.0.0-dev
ARG BRANCH=unknown
ARG COMMIT=unknown
ARG BUILD_DATE
ARG BUILD_TIME
ARG GITHUB_SHA
ARG GITHUB_REF

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
ARG SEMANTIC_VERSION=0.0.0-dev
ARG BRANCH=unknown
ARG COMMIT=unknown
ARG BUILD_DATE
ARG BUILD_TIME
ARG GITHUB_SHA
ARG GITHUB_REF

# Add comprehensive metadata labels
LABEL org.opencontainers.image.title="Maven Tomcat Web Application" \
      org.opencontainers.image.description="Java Web Application built with Maven and deployed on Tomcat - Branch: ${BRANCH}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${COMMIT}" \
      org.opencontainers.image.created="${BUILD_DATE}T${BUILD_TIME}Z" \
      org.opencontainers.image.source="https://github.com/shivamsingh163248/Maven-Tomcat-CI-CD" \
      org.opencontainers.image.url="https://github.com/shivamsingh163248/Maven-Tomcat-CI-CD" \
      org.opencontainers.image.documentation="https://github.com/shivamsingh163248/Maven-Tomcat-CI-CD/blob/main/README.md" \
      org.opencontainers.image.vendor="shivamsingh163248" \
      \
      app.version="${VERSION}" \
      app.semantic-version="${SEMANTIC_VERSION}" \
      app.branch="${BRANCH}" \
      app.commit="${COMMIT}" \
      app.build-date="${BUILD_DATE}" \
      app.build-time="${BUILD_TIME}" \
      app.github-sha="${GITHUB_SHA}" \
      app.github-ref="${GITHUB_REF}" \
      app.java-version="21" \
      app.maven-version="3.9.7" \
      app.tomcat-version="10.1" \
      app.port="8080"

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
    chmod +x /usr/local/tomcat/bin/*.sh

# Set environment variables
ENV CATALINA_HOME=/usr/local/tomcat \
    PATH=$CATALINA_HOME/bin:$PATH \
    JAVA_OPTS="-Djava.awt.headless=true -Xmx512m -XX:+UseG1GC -XX:+UseStringDeduplication" \
    CATALINA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=UTC" \
    APP_VERSION="${VERSION}" \
    APP_BRANCH="${BRANCH}" \
    APP_COMMIT="${COMMIT}"

# Use the existing tomcat user from base image or create if not exists
RUN if ! id tomcat > /dev/null 2>&1; then \
        groupadd -r tomcat && useradd -r -g tomcat tomcat; \
    fi && \
    chown -R tomcat:tomcat /usr/local/tomcat

USER tomcat

# Expose port
EXPOSE 8080

# Health check with better endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/webapp-demo/ || exit 1

# Create startup script for better logging
RUN echo '#!/bin/bash\n\
echo "==================================="\n\
echo "Starting Tomcat Web Application"\n\
echo "Version: ${APP_VERSION:-unknown}"\n\
echo "Branch: ${APP_BRANCH:-unknown}"\n\
echo "Commit: ${APP_COMMIT:-unknown}"\n\
echo "Java Version: $(java -version 2>&1 | head -n 1)"\n\
echo "Tomcat Version: $(catalina.sh version | grep '\''Server version'\'')"\n\
echo "==================================="\n\
exec catalina.sh run' > /usr/local/tomcat/bin/startup-with-info.sh && \
    chmod +x /usr/local/tomcat/bin/startup-with-info.sh

# Start Tomcat with info
CMD ["/usr/local/tomcat/bin/startup-with-info.sh"]