# IT Support Automation Toolkit
# Active Directory User Report

Import-Module ActiveDirectory

Write-Host "===== ACTIVE DIRECTORY USER REPORT =====" -ForegroundColor Cyan

$ReportFolder = "$PSScriptRoot\..\reports"

if (-not (Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder | Out-Null
}

$Users = Get-ADUser -Filter * -Properties `
    DisplayName,
    Department,
    Title,
    Enabled,
    LastLogonDate,
    PasswordLastSet

$Report = $Users | Select-Object `
    SamAccountName,
    DisplayName,
    Department,
    Title,
    Enabled,
    LastLogonDate,
    PasswordLastSet

$ReportPath = "$ReportFolder\active-directory-users.csv"

$Report | Export-Csv `
    -Path $ReportPath `
    -NoTypeInformation

Write-Host "`nActive Directory user report generated successfully." -ForegroundColor Green
Write-Host "Report location: $ReportPath"
Write-Host "Total users: $($Users.Count)"
