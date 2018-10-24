pipeline{
    agent none
    environment{
        version = "tw1"
    }
    stages{
        stage('download code'){
            agent any
            steps{
                echo 'prepare code'
                git 'https://github.com/JasonYLong/testweb.git'
            }
        }
        stage('test code'){
            agent { docker 'maven:3-alpine' }
            steps{
                echo 'test'
                sh "mvn clean && mvn test"
            }
        }
        stage('build code'){
            agent { docker 'maven:3-alpine' }    
            steps{
                echo 'build code'
                sh "mvn package -Dmaven.test.skip=true"
            }
        }
        stage('dockerfile a tomcat container'){
            agent any
            steps{
                echo 'dockerfile a tomcat container'
                sh """
                   cp ${WORKSPACE}/target/testweb_svn.war .
                   docker build -t tomcat:${version} .
                   """
            }
        }
        stage('Deploy to test'){
            agent any
            steps{
                echo 'Deploy to test'
                sh """
                  docker rm -f tomcat || true
                  docker run -d -p 8888:8080 --name tomcat tomcat:${version}
                """
            }
        }
        stage('save tomcat local registry'){
          agent any
          steps{
            //sh "docker save --output tw_v1.tar tomcat:${version}"
              sh """
                docker tag tomcat:${version} development:443/tomcat:${version}
                docker push development:443/tomcat:${version}
              """
          }
        }
        stage('check website status'){
          agent any
          steps{
              script {
                try{
                    sh "curl -s --head  --request GET http://localhost:8888/testweb_svn/ |grep 200"
                    return true
                }catch (Exception e){
                    return false
                } 
            }
          }
        }
        stage('Sanity check test'){
            agent any
            steps{
                echo 'Sanity check'
                input "Does the test environment look ok?"
            }
        }
        stage('Deploy to production'){
            agent any
            steps{
                echo 'Deploy to production'
                //echo "docker load --input tw_v1.tar"
                //echo "docker run -d -p 8888:8080 --name tomcat tomcat:${version}"
                sh """
                  sudo ssh root@production 'docker run -d -p 8888:8080 --name tomcat development:443/tomcat:${version}'
                """
            }
        }
    }
}
