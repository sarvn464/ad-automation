Import-Module ActiveDirectory
Import-Module ImportExcel

$excelPath = "C:\scripts\Users.xlsx"
$users = Import-Excel -Path $excelPath

foreach ($user in $users) {
    $First = $user.FirstName
    $Last = $user.LastName
    $Sam = $user.Username
    $OU = $user.OU
    $Password = $user.Password

    New-ADUser `
        -Name "$First $Last" `
        -SamAccountName $Sam `
        -UserPrincipalName "$Sam@saravana.com" `
        -GivenName $First `
        -Surname $Last `
        -Path $OU `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -Enabled $true

    Write-Host "User Created: $Sam"
}
