def registry = 'https://cdpipe.jfrog.io'
pipeline {
    agent {
        docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }

  }
    stages {
        stage ('Build and Test') {
          steps {
            sh 'mvn clean package'
          }
        }
        stage ('Sonarqube code analysis') {
            environment {
              SONAR_URL = "http://43.204.144.20:9000/"
            }
          steps {
            withCredentials([string(credentialsId: 'Sonarqube', variable: 'sonarqube')]) {
              sh 'mvn sonar:sonar -Dsonar.login=$sonarqube -Dsonar.host.url=${SONAR_URL}'
          }
        }
    }
        
        stage("Jar Publish") {
         steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog_cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "target/(.jar)",
                              "target": "libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish End --------------->'  
            
            }
        }   
    }   
    }
}
       