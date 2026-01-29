pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/sarvn464/ad-automation.git'
            }
        }

        stage('Notify Manager') {
            steps {
                mail to: 'manager@company.com',
                     subject: 'AD User Creation Approval',
                     body: 'Please approve the request'
            }
        }

        stage('Manager Approval') {
            steps {
                input message: 'Manager approval required to create AD users'
            }
        }

        stage('Create AD Users') {
            agent { label 'windows-ad' }   // 🔥 THIS IS THE FIX
            steps {
                powershell '''
                    Import-Module ActiveDirectory
                    .\\create-ad-users.ps1
                '''
            }
        }
    }
}
