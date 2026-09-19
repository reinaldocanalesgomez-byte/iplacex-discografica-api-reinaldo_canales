# ---------- STAGE 1: build del .jar con el Gradle Wrapper ----------
FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /home/gradle/project

COPY . .

RUN chmod +x gradlew && ./gradlew build -x test --no-daemon

# ---------- STAGE 2: ejecución con OpenJDK (Eclipse Temurin) ----------
FROM eclipse-temurin:21-jre-jammy AS run
WORKDIR /app

# discografia-1.jar = rootProject.name (settings.gradle) + version (build.gradle)
COPY --from=build /home/gradle/project/build/libs/discografia-1.jar discografia-1.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "discografia-1.jar"]