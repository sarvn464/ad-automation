pipeline {
    agent { label 'AD-Server' }

    tools {
        git 'Git-Windows'   // 🔥 THIS LINE IS MANDATORY
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/sarvn464/ad-automation.git']]
                ])
            }
        }

        stage('Copy Excel to Script Path') {
            steps {
                powershell '''
                    Copy-Item "$env:WORKSPACE\\Users.xlsx" "C:\\scripts\\Users.xlsx" -Force
                '''
            }
        }

        stage('Run AD User Script') {
            steps {
                powershell '''
                    C:\\scripts\\Create-ADUser.ps1
                '''
            }
        }
    }
}
