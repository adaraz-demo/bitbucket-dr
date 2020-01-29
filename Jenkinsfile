pipeline {
   agent any
    environment {
      AZURE_STORAGE_ACCOUNT     = credentials('jenkins-azure-blob-account-id')
      AZURE_STORAGE_KEY = credentials('jenkins-azure-blob-account-key')
  }
   stages {

      stage('Checkout') {
          steps {
            // Get some code from a GitHub repository
            git 'https://github.com/adaraz-demo/bitbucket-rd.git'
          }
      }

      stage('Clone && Upload to Azure') {
          steps {
            // Run Maven on a Unix agent.
            sh "./clone-all.sh cicd-demo"
          }
      }
   }

   post {
     success {
        ansiColor('xterm') {
            script {
                echo "\u001B[42;1m\u001b[33;1mThe pipeline was successful\u001B[0m"
            }
        }
     }
     failure {
         ansiColor('xterm') {
             script {
                 echo "\u001B[41;1m\u001b[33;1mThe pipeline failed\u001B[0m"
             }
         }
     }
  }
}