pipeline {
  agent {
    node {
      label 'maven'
    }
  }
  options {
    timeout(time: 20, unit: 'MINUTES')
  }
  stages {
    stage('preamble') {
        steps {
            script {
                openshift.withCluster() {
                    openshift.withProject() {
                        echo "Using project: ${openshift.project()}"
                    }
                }
            }
        }
    }
    stage('Create Image Builder') {
      when {
        expression {
          openshift.withCluster() {
            return !openshift.selector("bc", "flr-gateway-image").exists()
          }
        }
      }
      steps {
        script {
          openshift.withCluster() {
            openshift.newBuild("--name=flr-gateway-image", "--image-stream=openjdk18-openshift", "--binary")
          }
        }
      }
    }
    stage('build') {
      steps {
        script {
            openshift.withCluster() {
                openshift.withProject() {
                  sh "./gradlew build"
                  openshift.selector("bc", "flr-gateway-image").startBuild("--from-file=build/libs/app.jar", "--wait")
                }
            }
        }
      }
    }
  }
}

