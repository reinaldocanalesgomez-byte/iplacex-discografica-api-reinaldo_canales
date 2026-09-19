# ---------- STAGE 1: build del .jar con Gradle ----------
FROM gradle:8.10.2-jdk21 AS build
WORKDIR /home/gradle/project

COPY --chown=gradle:gradle . .

RUN gradle build -x test --no-daemon

# ---------- STAGE 2: ejecución con OpenJDK ----------
FROM openjdk:21-jdk-slim AS run
WORKDIR /app

# discografia-1.jar = rootProject.name (settings.gradle) + version (build.gradle)
COPY --from=build /home/gradle/project/build/libs/discografia-1.jar discografia-1.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "discografia-1.jar"]