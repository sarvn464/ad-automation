# Path from Jenkins workspace
$excelPath = "C:\jenkins\workspace\AD-User-Automation\Users.xlsx"

# Check Excel exists
if (-not (Test-Path $excelPath)) {
    Write-Host "❌ ERROR: Excel file NOT found at: $excelPath"
    exit 1
}

# Import module
try {
    Import-Module ImportExcel -ErrorAction Stop
} catch {
    Write-Host "❌ ImportExcel module missing. Install using:"
    Write-Host "Install-Module ImportExcel"
    exit 1
}

# Get sheet info
$sheetInfo = Get-ExcelSheetInfo -Path $excelPath

if (-not $sheetInfo) {
    Write-Host "❌ ERROR: No sheets found in Excel. File may be empty."
    exit 1
}

# Always take the first sheet
$sheetName = $sheetInfo[0].Name
Write-Host "📄 Using sheet: $sheetName"

# Import rows
$users = Import-Excel -Path $excelPath -WorksheetName $sheetName

if (-not $users) {
    Write-Host "❌ ERROR: No rows found in Excel."
    exit 1
}

# Loop and create users
foreach ($user in $users) {

    if (-not $user.SamAccountName) {
        Write-Host "⚠ Skipping empty row..."
        continue
    }

    try {
        $upn = "$($user.SamAccountName)@saravana.com"

        # Check if exists
        $exists = Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -ErrorAction SilentlyContinue

        if (-not $exists) {

            New-ADUser `
                -Name $user.Name `
                -GivenName $user.GivenName `
                -Surname $user.Surname `
                -SamAccountName $user.SamAccountName `
                -UserPrincipalName $upn `
                -Path $user.OU `
                -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
                -Enabled $true

            Write-Host "✅ Created: $($user.SamAccountName)"

        } else {
            Write-Host "⚠ Already exists: $($user.SamAccountName)"
        }

    } catch {
        Write-Host "❌ ERROR for user $($user.SamAccountName): $_"
    }
}
