# Multi-stage build for Java Web Application
FROM maven:3.9.7-eclipse-temurin-21 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml first for better caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Production stage
FROM tomcat:10.1-jdk21-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file to Tomcat webapps directory
COPY --from=build /app/target/webapp-demo.war /usr/local/tomcat/webapps/webapp-demo.war

# Copy tomcat configuration
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

# Create logs directory
RUN mkdir -p /usr/local/tomcat/logs

# Set environment variables
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=256m"

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/webapp-demo/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]