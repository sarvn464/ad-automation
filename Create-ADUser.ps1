# Create-ADUser.ps1
# Requires: ActiveDirectory module, Excel file path

# Path to your Excel file
$ExcelPath = "C:\jenkins\workspace\AD-User-Automation\users.xlsx"

# Import Excel module (if using ImportExcel module)
Import-Module ImportExcel

# Read all rows from Excel
$Users = Import-Excel -Path $ExcelPath

foreach ($User in $Users) {

    # Check required fields
    if (-not $User.FirstName -or -not $User.LastName -or -not $User.Username -or -not $User.OU -or -not $User.Password) {
        Write-Host "❌ ERROR: Missing required values for row. Skipping..."
        continue
    }

    # Check if user already exists in AD
    $userExists = Get-ADUser -Filter { SamAccountName -eq $User.Username } -ErrorAction SilentlyContinue
    if ($userExists) {
        Write-Host "⚠ User '$($User.Username)' already exists. Skipping..."
        continue
    }

    # Create new AD user
    try {
        New-ADUser `
            -Name "$($User.FirstName) $($User.LastName)" `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -SamAccountName $User.Username `
            -UserPrincipalName "$($User.Username)@saravana.com" `
            -AccountPassword (ConvertTo-SecureString $User.Password -AsPlainText -Force) `
            -Path $User.OU `
            -Enabled $true

        Write-Host "✅ User '$($User.Username)' created successfully."
    } catch {
        Write-Host "❌ Failed to create user '$($User.Username)': $_"
    }
}
