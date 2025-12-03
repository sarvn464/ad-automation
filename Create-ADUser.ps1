param (
    [string]$ExcelPath = "C:\jenkins\workspace\AD-User-Automation\users.xlsx"
)

Import-Module ActiveDirectory
Import-Module ImportExcel

Write-Host "Using Excel path: $ExcelPath"

$Users = Import-Excel $ExcelPath

foreach ($User in $Users) {

    $firstName = $User.FirstName
    $lastName  = $User.LastName
    $username  = $User.Username
    $UPN       = "$username@saravana.com"
    $password  = ConvertTo-SecureString $User.Password -AsPlainText -Force
    $ou        = $User.OU

    # Check if SamAccountName already exists
    $ExistsSam = Get-ADUser -Filter {SamAccountName -eq $username}

    # Check if UPN already exists
    $ExistsUPN = Get-ADUser -Filter {UserPrincipalName -eq $UPN}

    if ($ExistsSam -or $ExistsUPN) {
        Write-Host "SKIPPED - User already exists: $username ($UPN)"
        continue
    }

    # Create new AD user
    New-ADUser `
        -GivenName $firstName `
        -Surname $lastName `
        -Name "$firstName $lastName" `
        -SamAccountName $username `
        -UserPrincipalName $UPN `
        -AccountPassword $password `
        -Enabled $true `
        -Path $ou

    Write-Host "User CREATED: $username"
}
