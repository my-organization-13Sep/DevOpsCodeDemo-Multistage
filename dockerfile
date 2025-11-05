# ---------- Stage 1: Build the WAR using Maven ----------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the rest of the source code and build the WAR
COPY . .
RUN mvn clean package -DskipTests

# ---------- Stage 2: Deploy the WAR to Tomcat ----------
FROM tomcat:10.1-jdk17-temurin

# Remove default ROOT app (optional)
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the WAR file from the build stage
COPY --from=builder /app/target/addressbook.war /usr/local/tomcat/webapps/addressbook.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
