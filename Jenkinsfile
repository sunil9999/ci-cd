pipeline {
    agent any
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
