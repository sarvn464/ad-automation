pipeline {
    agent none

    stages {

        stage('Checkout') {
            agent any
            steps {
                git url: 'https://github.com/sarvn464/ad-automation.git', branch: 'main'
            }
        }

        stage('Notify Manager') {
            agent any
            steps {
                mail(
                    to: 'saravanasunrises@gmail.com',
                    subject: 'Approval Required: AD User Creation',
                    body: 'Please approve in Jenkins'
                )
            }
        }

        stage('Manager Approval') {
            agent none   // 🚀 DOES NOT CONSUME EXECUTOR
            steps {
                input message: 'Approve AD user creation'
            }
        }

        stage('Create AD Users') {
            agent { label 'AD-Server' }
            steps {
                powershell 'Write-Host "Creating AD users..."'
            }
        }
    }
}
