# syntax=docker/dockerfile:experimental
FROM openjdk:8-jdk-alpine AS build
RUN mkdir -p -m 0700 ./hello/target
WORKDIR ./hello

COPY . ./ 
RUN ./gradlew clean build
RUN jar -xf ../libs/*.jar)

FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG DEPENDENCY=/workspace/app/build
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","spring-boot-application"]
