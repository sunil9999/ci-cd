pipeline {
    agent {
        docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }
    stages {
        stage ('SCM checkout'){
          steps {
            git branch: 'test', url: 'https://github.com/sunil9999/ci-cd.git'
        }
    }
        stage ('Build and Test') {
          steps {
            sh 'mvn clean package'
          }
        }
        stage ('Sonarqube code analysis') {
            environment {
                SONAR_URL = "http://15.207.110.224:9000/"
            }
          steps {
            withCredentials([string(credentialsId: 'Sonarqube', variable: 'sonarqube')]) {
              sh 'mvn sonar:sonar -Dsonar.login=$sonarqube -Dsonar.host.url=${SONAR_URL}'
          }
        }
    }
        stage ('build and push docker image') {
            environment {
                DOCKER_IMAGE = "sunilraju99/ci-cd:${BUILD_NUMBER}"
                REGISTRY_CREDENTIALS = credentials('dockerhub')
            }
          steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
                def dockerImage = docker.image("${DOCKER_IMAGE}")
                docker.withRegistry('https://index.docker.io/v1/', "dockerhub") {
                  dockerImage.push()

            }
        }
}
}
}
