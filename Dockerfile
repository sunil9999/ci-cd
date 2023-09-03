FROM openjdk:8
ADD /var/lib/jenkins/workspace/ci-cd/target/spring-boot-web.jar webapp.jar
ENTRYPOINT [ "java", "-jar", "webapp.jar"]