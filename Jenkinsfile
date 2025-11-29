pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/sarvn464/ad-automation.git',
                        credentialsId: '014df70d-bdce-4946-aded-c05833e1cb8a'
                    ]]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'apt-get update'
                sh 'apt-get install -y python3 python3-pip'
                sh 'pip3 install ldap3 openpyxl pandas'
            }
        }

        stage('Create AD Users') {
            steps {
                sh 'python3 create_users.py'
            }
        }
    }

    post {
        failure {
            echo "Error creating users"
        }
        success {
            echo "AD User creation completed successfully"
        }
    }
}


