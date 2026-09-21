# IT Support Automation Toolkit
# Automated Support Report Generator

$reportFolder = "$PSScriptRoot\..\reports"

if (-not (Test-Path $reportFolder)) {
    New-Item -ItemType Directory -Path $reportFolder | Out-Null
}

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportFile = "$reportFolder\IT-Support-Report-$timestamp.txt"

$computerName = $env:COMPUTERNAME
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor |
    Measure-Object -Property LoadPercentage -Average

$memory = Get-CimInstance Win32_OperatingSystem

$totalMemory = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
$freeMemory = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
$usedMemory = [math]::Round($totalMemory - $freeMemory, 2)

$memoryPercentage = [math]::Round(
    ($usedMemory / $totalMemory) * 100,
    1
)

$uptime = (Get-Date) - $os.LastBootUpTime

$internet = Test-Connection `
    -ComputerName 8.8.8.8 `
    -Count 2 `
    -Quiet

$report = @"

=========================================
        IT SUPPORT HEALTH REPORT
=========================================

Generated: $(Get-Date)

COMPUTER INFORMATION
--------------------
Computer Name : $computerName
Operating System : $($os.Caption)
OS Version : $($os.Version)

SYSTEM HEALTH
-------------
CPU Usage : $([math]::Round($cpu.Average, 1))%
Memory Usage : $memoryPercentage%
Total Memory : $totalMemory GB
Used Memory : $usedMemory GB
System Uptime : $($uptime.Days) days, $($uptime.Hours) hours

NETWORK
-------
Internet Connectivity : $(if ($internet) {"OK"} else {"FAILED"})

STATUS
------
Report generated successfully.

=========================================
"@

$report | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host ""
Write-Host "IT Support Report Generated" -ForegroundColor Green
Write-Host ""
Write-Host "Report location:"
Write-Host $reportFile
