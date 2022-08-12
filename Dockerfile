# syntax=docker/dockerfile:experimental
FROM openjdk:8-jdk-alpine AS build
WORKDIR /workspace/app

COPY . /workspace/app
RUN chmod -R 0777 /workspace/app/gradle
RUN sdk install gradle 7.5.1 && ./gradlew build
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)

FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG DEPENDENCY=/workspace/app/build/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","hello.Application"]
