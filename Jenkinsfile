def registry = 'https://cdpipe.jfrog.io'
def imageName = 'cdpipe.jfrog.io/cdpipe-docker/webapp'
def version   = "1"
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
        
        stage ("Jar Publish") {
          steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog_cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "target/(*)",
                              "target": "libs-release-local",
                              "flat": "false",
                              "props" : "${properties}"
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
     stage(" Docker Build ") {
      steps {
        script {
           echo '<--------------- Docker Build Started --------------->'
           app = docker.build(imageName+":"+version)
           echo '<--------------- Docker Build End --------------->'
        }
      }
    }

            stage (" Docker Publish "){
        steps {
            script {
               echo '<--------------- Docker Publish Started --------------->'  
                docker.withRegistry(registry, 'jfrog_cred'){
                    app.push()
                }    
               echo '<--------------- Docker Publish End --------------->'  
            }
        }
    }
    stage ("Deploy") {
      steps {
        script {
          sh '/home/ubuntu/kubernetes/./deploy.sh'
        }
      }
    }  
    }
}
       