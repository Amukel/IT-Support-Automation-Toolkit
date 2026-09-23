# IT Support Automation Toolkit
# Automated System Health Report

$ReportFolder = "$PSScriptRoot\..\reports"

if (-not (Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder | Out-Null
}

$ComputerName = $env:COMPUTERNAME
$OS = Get-CimInstance Win32_OperatingSystem
$Computer = Get-CimInstance Win32_ComputerSystem

$DiskResults = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

$Report = foreach ($disk in $DiskResults) {

    $freePercent = [math]::Round(
        ($disk.FreeSpace / $disk.Size) * 100,
        2
    )

    [PSCustomObject]@{
        ComputerName = $ComputerName
        OperatingSystem = $OS.Caption
        RAM_GB = [math]::Round(
            $Computer.TotalPhysicalMemory / 1GB,
            2
        )
        Drive = $disk.DeviceID
        DiskSize_GB = [math]::Round(
            $disk.Size / 1GB,
            2
        )
        FreeSpace_GB = [math]::Round(
            $disk.FreeSpace / 1GB,
            2
        )
        FreeSpace_Percent = $freePercent
        Status = if ($freePercent -lt 15) {
            "Warning"
        }
        else {
            "OK"
        }
        ReportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
}

$ReportPath = "$ReportFolder\system-health-report.csv"

$Report | Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "System health report generated successfully." -ForegroundColor Green
Write-Host "Report location: $ReportPath"
