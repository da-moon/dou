FROM adoptopenjdk:11-jre-hotspot
VOLUME /tmp
EXPOSE 8080
ADD /target/openhouselandingrest-1.0.0.jar openhouselandingrest.jar
ENTRYPOINT ["java", "-jar","/openhouselandingrest.jar"]
