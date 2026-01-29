pipeline {
    agent any // change to windows-ad if PowerShell must run on Windows
    // agent { label 'windows-ad' }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/sarvn464/ad-automation.git', branch: 'main'
            }
        }

        stage('Notify Manager') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    mail(
                        to: 'saravanasunrises@gmail.com',
                        subject: 'Approval Required: AD User Creation',
                        body: """Hello Manager,

Changes have been pushed to the MAIN branch.
Your approval is required to create Active Directory users.

👉 Click the link below to review and approve:
${env.BUILD_URL}

Job Name : ${env.JOB_NAME}
Build No : ${env.BUILD_NUMBER}

Regards,
Jenkins
"""
                    )
                }
            }
        }

        stage('Manager Approval') {
            steps {
                input(
                    message: 'Manager approval required to create AD users',
                    ok: 'Approve',
                    submitter: 'Jenkins-Admins'
                )
            }
        }

        stage('Create AD Users') {
            steps {
                powershell """
                C:\\jenkins\\workspace\\AD-User-Automation\\Create-ADUser.ps1 `
                -ExcelPath C:\\jenkins\\workspace\\AD-User-Automation\\users.xlsx
                """
            }
        }
    }
}
