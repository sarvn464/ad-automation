$excelPath = "$env:WORKSPACE\users.xlsx"

# Auto-detect first sheet
$sheet = (Import-Excel -Path $excelPath -ShowSheet)[0]
$Users = Import-Excel -Path $excelPath -WorksheetName $sheet

foreach ($User in $Users) {

    $username = $User.Username.Trim()
    $firstName = $User.'First Name'.Trim()
    $lastName = $User.'Last Name'.Trim()
    $password  = $User.Password
    $ou        = $User.OU
    $upn       = "$username@saravana.com"

    if (-not $username) {
        Write-Host "⚠️ Username missing — skipping row."
        continue
    }

    # Pre-check both SamAccountName and UPN
    $existingUser = Get-ADUser -Filter { SamAccountName -eq $username -or UserPrincipalName -eq $upn } -ErrorAction SilentlyContinue
    if ($existingUser) {
        Write-Host "⚠️ User '$username' already exists — skipping."
        continue
    }

    # Convert password to secure string
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    # Create AD user
    Write-Host "➡️ Creating new AD user: $username"
    New-ADUser `
        -GivenName $firstName `
        -Surname $lastName `
        -SamAccountName $username `
        -UserPrincipalName $upn `
        -Name "$firstName $lastName" `
        -EmailAddress $upn `
        -Department $User.Department `
        -AccountPassword $securePassword `
        -Path $ou `
        -Enabled $true

    Write-Host "✅ Created AD user: $username"
}
