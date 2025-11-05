# ---------- Stage 1: Build the WAR using Maven ----------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

# Copy pom.xml and run dependencies
COPY . .
RUN mvn dependency:go-offline -B

# Package the code
RUN mvn clean package -DskipTests

# ---------- Stage 2: Deploy the WAR to Tomcat ----------
FROM tomcat:9

# Copy the WAR file from the build stage
COPY --from=builder /target/addressbook.war /usr/local/tomcat/webapps/addressbook.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
