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
    stage('Create Image Builder') {
      when {
        expression {
          openshift.withCluster() {
              openshift.withProject("development-flr") {
                return !openshift.selector("bc", "gateway").exists()
              }
          }
        }
      }
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject("development-flr") {
              openshift.newBuild("--name=gateway", "--image-stream=openshift/jdk", "--binary")
            }
          }
        }
      }
    }
    stage('build') {
      steps {
        script {
            openshift.withCluster() {
                sh "./gradlew build"
                openshift.withProject("development-flr") {
                  openshift.selector("bc", "gateway").startBuild("--from-file=build/libs/app.jar", "--wait")
                }
            }
        }
      }
    }
    stage('Promote to DEV') {
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject("development-flr") {
              openshift.tag("gateway:latest", "gateway:dev")
            }
          }
        }
      }
    }
    stage('Create DEV') {
      when {
        expression {
          openshift.withCluster() {
            openshift.withProject("development-flr") {
              return !openshift.selector('dc', 'gateway').exists()
            }
          }
        }
      }
      steps {
        script {
          openshift.withCluster() {
            openshift.withProject("development-flr") {
              openshift.newApp("gateway:dev", "--name=gateway").narrow('svc').expose()
            }
          }
        }
      }
    }
  }
}
