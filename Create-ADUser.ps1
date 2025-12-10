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
    $password  = $User.Password
    $action    = $User.Action
    $ou        = $User.OU

    # Make sure Action exists
    if (-not $action) {
        Write-Host "SKIPPED - No Action provided for user: $username"
        continue
    }

    # Check if user exists
    $adUser = Get-ADUser -Filter {SamAccountName -eq $username} -ErrorAction SilentlyContinue


    # ----------------------------------------------------------
    #  ACTION 1: CREATE USER
    # ----------------------------------------------------------
    if ($action -eq "Create") {

        # Validate required fields
        if (-not $firstName -or -not $lastName) {
            Write-Host "SKIPPED - Missing FirstName or LastName for: $username"
            continue
        }

        if (-not $password) {
            Write-Host "SKIPPED - Missing Password for: $username"
            continue
        }

        # Skip if already exists
        if ($adUser) {
            Write-Host "SKIPPED - User already exists: $username"
            continue
        }

        $securePass = ConvertTo-SecureString $password -AsPlainText -Force
        $CN = "$firstName $lastName"

        New-ADUser `
            -GivenName $firstName `
            -Surname $lastName `
            -Name $CN `
            -SamAccountName $username `
            -UserPrincipalName $UPN `
            -AccountPassword $securePass `
            -Enabled $true `
            -Path $ou

        Write-Host "User CREATED: $username"
    }


    # ----------------------------------------------------------
    #  ACTION 2: DISABLE USER
    # ----------------------------------------------------------
    elseif ($action -eq "Disable") {

        if ($adUser) {
            Disable-ADAccount -Identity $username
            Write-Host "User DISABLED: $username"
        }
        else {
            Write-Host "SKIPPED - User not found for disable: $username"
        }
    }


    # ----------------------------------------------------------
    #  UNKNOWN ACTION
    # ----------------------------------------------------------
    else {
        Write-Host "SKIPPED - Unknown Action '$action' for: $username"
    }
}
