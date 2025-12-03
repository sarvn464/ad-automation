$Users = Import-Excel "C:\jenkins\excel\users.xlsx"

foreach ($User in $Users) {

    $firstName = $User.'First Name'
    $lastName = $User.'Last Name'
    $username = $User.Username
    $password = $User.Password
    $ou        = $User.OU

    if (-not $firstName -or -not $lastName -or -not $username) {
        Write-Host "❌ ERROR: Missing required values for row. Skipping..."
        continue
    }

    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    New-ADUser `
        -GivenName $firstName `
        -Surname $lastName `
        -SamAccountName $username `
        -UserPrincipalName "$username@saravana.com" `
        -Name "$firstName $lastName" `
        -EmailAddress $User.Email `
        -Department $User.Department `
        -AccountPassword $securePassword `
        -Path $ou `
        -Enabled $true
}
