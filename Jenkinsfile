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
                SONAR_URL = "http://13.233.78.121:9000/"
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
              REGISTRY_CREDENTIALS = credentials('docker')
            }
          steps {
            script {
                sh 'docker build -t ${DOCKER_IMAGE} .'
                def dockerImage = docker.image("${DOCKER_IMAGE}")
                docker.withRegistry('https://index.docker.io/v1/', "docker") {
                  dockerImage.push()
                }
            }
        }
}
        stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "ci-cd"
            GIT_USER_NAME = "sunil9999"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "sunilraju20111@gmail.com"
                    git config user.name "Sunil"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" spring-boot-app-manifests/deployment.yml
                    git add spring-boot-app-manifests/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:test
                '''
            }
}
}
}
}
