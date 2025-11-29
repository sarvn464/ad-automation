pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/sarvn464/ad-automation.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                pip3 install --upgrade ldap3 openpyxl
                '''
            }
        }

        stage('Create AD Users') {
            steps {
                sh '''
                python3 create_ad_users.py
                '''
            }
        }
    }

    post {
        success {
            echo 'AD Users created successfully in saravana.com'
        }
        failure {
            echo 'Error creating users'
        }
    }
}
