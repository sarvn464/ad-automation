# Path to your Excel file
$excelPath = "C:\jenkins\workspace\AD-User-Automation\Users.xlsx"

# Import the ImportExcel module
Import-Module ImportExcel

# Get all sheet names from the Excel file
$sheetNames = (Get-ExcelSheetInfo -Path $excelPath).Name

# Select the first sheet
$sheetName = $sheetNames[0]

# Import the data from the first sheet
$users = Import-Excel -Path $excelPath -WorksheetName $sheetName

# Loop through each user and create in AD
foreach ($user in $users) {
    try {
        $upn = "$($user.SamAccountName)@saravana.com"

        # Check if user exists
        if (-not (Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -ErrorAction SilentlyContinue)) {
            # Create new AD user
            New-ADUser `
                -Name $user.Name `
                -GivenName $user.GivenName `
                -Surname $user.Surname `
                -SamAccountName $user.SamAccountName `
                -UserPrincipalName $upn `
                -Path $user.OU `
                -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
                -Enabled $true
            Write-Host "✅ Created user: $($user.SamAccountName)"
        } else {
            Write-Host "⚠ User already exists: $($user.SamAccountName)"
        }
    } catch {
        Write-Host "❌ Failed to create user $($user.SamAccountName): $_"
    }
}
