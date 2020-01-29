pipeline {
   agent any

   stages {

      stage('Checkout') {
          steps {
            // Get some code from a GitHub repository
            git 'https://github.com/adaraz-demo/cicd-demo.git'
          }
      }

      stage('Build') {
          steps {
            // Run Maven on a Unix agent.
            sh "mvn clean compile"
          }
      }

      stage('Sonar Qube') {
         steps {
          script {
            ansiColor('xterm') {
                println "<<< Run Sonar qube analysis task"
                // withSonarQubeEnv() {
                  // Will pick the global server connection you have configured
                //  sh 'mvn sonar:sonar -Dsonar.projectKey=CI -Dsonar.host.url=http://5819053a.ngrok.io -Dsonar.login=7d0a24d88a73577d16d138cc00668e2fb83137ea'
                //}
                // sh 'mvn sonar:sonar -Dsonar.projectKey=CI -Dsonar.host.url=http://5819053a.ngrok.io -Dsonar.login=7d0a24d88a73577d16d138cc00668e2fb83137ea'
            }
          }
         }
      }

      stage('Test') {
         steps {
          script {
            ansiColor('xterm') {

                println "<<< Running server unit tests complete"
                try {
                    sh 'mvn test'
                } catch(e) {
                    println "Cancelling build because something failed while running server unit tests " + e
                    throw e;
                    //cancelCurrentBuild(e, 'server:test')
                } finally {
                    // sh "cd target && mv reports/tests/test reports/tests/unit-tests"
                    junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts allowEmptyArchive: true, artifacts: "**/jacoco/**", caseSensitive: false, defaultExcludes: false
                    stash allowEmpty: true, includes: "**/jacoco/**", name: 'unit-test-reports'
                }
                println "<<< Running server unit tests complete"
            }
          }
         }
      }

      stage('Build Docker Image') {
          steps {
            script {
                  ansiColor('xterm') {
                      sh """
                        docker -H tcp://192.168.99.101:2376 build \
                                -t cicd-demo:1.0 .
                      """
                  }
             }
          }
      }

      //stage('Deploy To K8s') {
      //    steps {
      //      script {
      //            ansiColor('xterm') {
      //                sh """
      //                  kubectl
      //                """
      //            }
      //       }
      //    }
      //}

   }

   post {

     always {
        ansiColor('xterm') {
           script {
               echo 'Code Coverage'
               jacoco()
           }
        }
     }
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