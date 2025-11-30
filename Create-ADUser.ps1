param (
    [Parameter(Mandatory=$true)]
    [string]$ExcelFile
)

# Stop on errors
$ErrorActionPreference = "Stop"

# Import modules
Import-Module ActiveDirectory
Import-Module ImportExcel -ErrorAction Stop

# Read users from Excel
$users = Import-Excel -Path $ExcelFile

foreach ($user in $users) {

    Write-Host "-------------------------------"
    
    # Trim spaces and generate username
    $user.FirstName = $user.FirstName.Trim()
    $user.LastName  = $user.LastName.Trim()
    $user.Username  = "$($user.FirstName).$($user.LastName)".ToLower()
    $user.OU       = $user.OU.Trim()
    $user.Password = $user.Password.Trim()

    Write-Host "Processing user: $($user.Username)"
    Write-Host "Full Name: $($user.FirstName) $($user.LastName)"
    Write-Host "OU: $($user.OU)"
    Write-Host "Password: $($user.Password)"

    # Validate mandatory fields
    if (-not $user.FirstName -or -not $user.LastName -or -not $user.OU -or -not $user.Password) {
        Write-Host "❌ Skipping: Missing required field for user $($user.Username)"
        continue
    }

    # Check if user already exists
    $existing = Get-ADUser -Filter { SamAccountName -eq $user.Username } -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "⚠ User already exists: $($user.Username). Skipping creation."
        continue
    }

    # Create the AD user
    try {
        New-ADUser `
            -Name "$($user.FirstName) $($user.LastName)" `
            -SamAccountName $user.Username `
            -UserPrincipalName "$($user.Username)@domain.com" `
            -Path $user.OU `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
            -Enabled $true

        Write-Host "✅ User created successfully: $($user.Username)"
    }
    catch {
        Write-Host "❌ Failed to create user $($user.Username): $($_.Exception.Message)"
    }
}
