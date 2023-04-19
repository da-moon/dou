FROM debian:buster-slim

RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install -y openjdk-11-jre

ADD build/libs/catalog-0.0.1-SNAPSHOT.jar /opt/catalog.jar

CMD ["java", "-Dspring.profiles.active=docker", "-jar", "/opt/catalog.jar"]
