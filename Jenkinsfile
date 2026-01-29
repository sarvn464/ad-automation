pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/sarvn464/ad-automation.git', branch: 'main'
            }
        }

        stage('Notify Manager') {
            steps {
                mail to: 'saravanasunrises@gmail.com',
                     subject: 'Approval Required: AD User Creation',
                     body: """Hello Manager,

Changes have been pushed to the MAIN branch.
Approval is required to create Active Directory users.

Job: ${env.JOB_NAME}
Build: ${env.BUILD_NUMBER}

Please login to Jenkins and approve the job.

Regards,
Jenkins
"""
            }
        }

        stage('Manager Approval') {
            steps {
                input message: 'Manager approval required to create AD users',
                      ok: 'Approve',
                      submitter: 'Jenkins-Admins'
            }
        }

        stage('Create AD Users') {
            steps {
                script {
                    powershell """
                    C:\\jenkins\\workspace\\AD-User-Automation\\Create-ADUser.ps1 `
                    -ExcelPath C:\\jenkins\\workspace\\AD-User-Automation\\users.xlsx
                    """
                }
            }
        }
    }
}
