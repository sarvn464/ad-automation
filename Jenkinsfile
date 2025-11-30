pipeline {
    agent { label 'AD-Server' }  

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/sarvn464/ad-automation.git', branch: 'main'
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
