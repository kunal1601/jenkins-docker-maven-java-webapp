pipeline {

    agent {
        label "agent1"
    } 
    environment {
        JAVA_HOME = "/usr/lib/jvm/java-21-amazon-corretto.x86_64"
        PATH = "${JAVA_HOME}/bin:${env.PATH}"
       }
    stages {
        stage('SCM') {
            steps {
                git 'https://github.com/kunal1601/jenkins-docker-maven-java-webapp.git'
            }
        }
        stage('build stage-by Maven'){
            steps {
                echo "this is mvn stage..."
                sh 'mvn clean package'
            }
        }
         stage('build Docker image'){
            steps {
                echo "building docker image"
                sh 'sudo docker build -t kunal0816/java-maven-web-app:v${BUILD_NUMBER} .'
            }
        }
        stage('Push docker image'){
            steps {
                echo "Push docker image"
               withCredentials([string(credentialsId: 'Docker_hub_pass', variable: 'git_pass')]) {
               sh 'sudo docker login -u kunal0816 -p $git_pass'
}                
                sh 'sudo docker push kunal0816/java-maven-web-app:v${BUILD_NUMBER}'
            }
        }
        stage('Deploying the image'){
            steps {
                echo "Deployig web_app on tomcat server"
                sh 'sudo docker rm -f web_app'
                sh 'sudo docker run -d -p 8080:8080 --name web_app kunal0816/java-maven-web-app:v${BUILD_NUMBER}'
            }
        }    
       stage('QA Team') {
         steps {
             sshagent(['QA_env_id']) {
              sh """
                ssh -o StrictHostKeyChecking=no ec2-user@65.2.83.119 '
                sudo yum install docker -y
                sudo systemctl start docker
                sudo systemctl enable docker
                sudo docker rm -f web_app || true
                sudo docker run -d -p 8080:8080 --name web_app kunal0816/java-maven-web-app:v${BUILD_NUMBER}
            '
            """ 
          }
        }
    }  
        stage('QAT Test') {
            steps {

                    retry(10) {
                    sh 'curl --silent http://65.2.83.119:8080/ |  grep -i kunal'
                }
            }
        }    
        
          stage('approved') {
            steps {
            script {
                Boolean userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
                echo 'userInput: ' + userInput

                if(userInput == true) {
                    // do action
                } else {
                    // not do action
                    echo "Action was aborted."
                }
            }
        }
        }

      stage('Production environment') {
         steps {
             sshagent(['QA_env_id']) {
              sh """
                ssh -o StrictHostKeyChecking=no ec2-user@13.203.101.95 '
                sudo yum install docker -y
                sudo systemctl start docker
                sudo systemctl enable docker
                sudo docker rm -f web_app || true
                sudo docker run -d -p 8080:8080 --name web_app kunal0816/java-maven-web-app:v${BUILD_NUMBER}
            '
            """ 
          }
        }
    }  

   }
}
