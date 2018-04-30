pipeline {
  agent none

  stages {
    stage("Run tests") {
      parallel {
        stage("Ruby 1.9.3") {
          agent {
            docker {
              image 'ruby:1.9.3'
            }
          }
          steps {
            sh 'BUNDLE_APP_CONFIG=/tmp/bundle.config BUNDLE_DISABLE_SHARED_GEMS=true bundle install --deployment'
            sh 'BUNDLE_APP_CONFIG=/tmp/bundle.config bundle exec rake spec'
            sh 'BUNDLE_APP_CONFIG=/tmp/bundle.config bundle exec rake doc'
          }
        }
        stage("Ruby 2.0") {
          agent {
            docker {
              image 'ruby:2.0'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
            sh 'bundle exec rake doc'
          }
        }
        stage("Ruby 2.1") {
          agent {
            docker {
              image 'ruby:2.1'
            }
          }
          steps {
            sh 'bundle install --deployment'
            sh 'bundle exec rake spec'
            sh 'bundle exec rake doc'
          }
        }
      }
    }
  }
}
