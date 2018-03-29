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
    stage('build') {
      steps {
        script {
            openshift.withCluster() {
                openshift.withProject() {
                        echo "build project: ${openshift.project()}"
                }
            }
        }
      }
    }
  }
}

