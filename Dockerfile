FROM openjdk:8
ADD target/spring-boot-web.jar webapp.jar
ENTRYPOINT [ "java", "-jar", "webapp.jar"]