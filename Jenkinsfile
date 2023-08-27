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
    }
}
