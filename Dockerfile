# Multi-stage build para Java
FROM maven:3.8.1-adoptopenjdk-11 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Compilar aplicación
RUN mvn clean package -DskipTests

# Imagen de runtime
FROM adoptopenjdk:11-jre-hotspot

WORKDIR /app

# Copiar JAR desde la etapa de build
COPY --from=build /app/target/*.jar app.jar

# Crear usuario no-root
RUN adduser --system --group spring
USER spring:spring

# Exponer puerto
EXPOSE 8080

# Comando de ejecución
ENTRYPOINT ["java", "-jar", "app.jar"]
