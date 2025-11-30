param (
    [Parameter(Mandatory=$true)]
    [string]$ExcelFile
)

$ErrorActionPreference = "Stop"

# Import modules
Import-Module ActiveDirectory
Import-Module ImportExcel -ErrorAction Stop

# Read users from Excel
$users = Import-Excel -Path $ExcelFile

foreach ($user in $users) {

    # Trim & format
    $user.FirstName = $user.FirstName.Trim()
    $user.LastName  = $user.LastName.Trim()
    $user.Username  = "$($user.FirstName).$($user.LastName)".ToLower()
    $user.OU       = $user.OU.Trim()
    $user.Password = $user.Password.Trim()

    Write-Host "-------------------------------"
    Write-Host "Processing user: $($user.Username)"
    Write-Host "Full Name: $($user.FirstName) $($user.LastName)"
    Write-Host "OU: $($user.OU)"
    Write-Host "Password: $($user.Password)"

    # Check if user exists
    $existing = Get-ADUser -Filter { SamAccountName -eq $user.Username } -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "⚠ User already exists: $($user.Username). Skipping creation."
        continue
    }

    # Create AD user
    try {
        New-ADUser `
            -Name "$($user.FirstName) $($user.LastName)" `
            -SamAccountName $user.Username `
            -UserPrincipalName "$($user.Username)@saravana.com" `
            -Path $user.OU `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
            -Enabled $true

        Write-Host "✅ User created successfully: $($user.Username)"
    }
    catch {
        Write-Host "❌ Failed to create user $($user.Username): $($_.Exception.Message)"
    }
}
