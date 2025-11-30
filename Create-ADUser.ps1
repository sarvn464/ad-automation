Import-Module ActiveDirectory

$excelPath = "C:\jenkins\excel\users.xlsx"
$Users = Import-Excel -Path $excelPath

foreach ($u in $Users) {
    $Sam = $u.SamAccountName
    $Given = $u.FirstName
    $Surname = $u.LastName
    $OU = $u.OU
    $Pass = (ConvertTo-SecureString $u.Password -AsPlainText -Force)

    New-ADUser `
        -Name "$Given $Surname" `
        -SamAccountName $Sam `
        -GivenName $Given `
        -Surname $Surname `
        -Path $OU `
        -AccountPassword $Pass `
        -Enabled $true
}
