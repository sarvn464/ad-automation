pipeline {
    agent any

    stages {

        stage('Checkout Repository') {
            steps {
                // Checkout your Git repo
                checkout([$class: 'GitSCM',
                          branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: 'https://github.com/sarvn464/ad-automation.git', credentialsId: '014df70d-bdce-4946-aded-c05833e1cb8a']]
                ])
            }
        }

        stage('Run AD User Script') {
            steps {
                // Run PowerShell script with Excel file parameter
                powershell """
                    powershell -ExecutionPolicy Bypass -File "C:\\scripts\\Create-ADUser.ps1" `
                    -ExcelFile "C:\\jenkins\\workspace\\AD-User-Automation\\users.xlsx"
                """
            }
        }
    }

    post {
        success {
            echo "✅ AD User creation completed successfully."
        }
        failure {
            echo "❌ AD User creation failed. Check logs for errors."
        }
    }
}
