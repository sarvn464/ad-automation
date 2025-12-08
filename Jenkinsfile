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

stage('Create AD Users') {
    steps {
        script {
            // Debug: Check workspace contents first
            bat 'dir /b'
            bat 'if exist users.xlsx (echo "Excel exists" & dir users.xlsx) else echo "Excel missing"'
            
            powershell """
                \$excelPath = Join-Path "${WORKSPACE}" "users.xlsx"
                Write-Host "Excel path: \$excelPath"
                
                if (Test-Path \$excelPath) {
                    Write-Host "Excel file exists"
                    \$xl = Import-Excel -Path \$excelPath
                    Write-Host "Worksheets loaded: \$(\$xl.Count) rows"
                    \$xl | Format-Table -AutoSize
                } else {
                    Write-Error "Excel file not found at \$excelPath"
                    exit 1
                }
            """
        }
    }
}