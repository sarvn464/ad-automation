pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/sarvn464/ad-automation.git', branch: 'main'
            }
        }

        stage('Create AD Users') {
            steps {
                script {
                    powershell """
                    C:\\jenkins\\workspace\\AD-User-Automation\\Create-ADUser.ps1 -ExcelPath C:\\jenkins\\workspace\\AD-User-Automation\\users.xlsx
                    """
                }
            }
        }
    }
}
