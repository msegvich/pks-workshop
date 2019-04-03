FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
# ENV ELASTICSEARCH_SERVICE_HOST elasticsearch
# ENV ELASTICSEARCH_SERVICE_PORT 9200
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
