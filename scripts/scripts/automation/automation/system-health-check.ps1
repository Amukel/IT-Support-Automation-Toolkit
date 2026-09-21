# IT Support Automation Toolkit
# System Health Check

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "        SYSTEM HEALTH CHECK" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Computer Information
Write-Host "Computer:" -ForegroundColor Yellow
$env:COMPUTERNAME
Write-Host ""

# Operating System
Write-Host "Operating System:" -ForegroundColor Yellow
Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption, Version, OSArchitecture |
    Format-List

# CPU Usage
Write-Host "CPU Usage:" -ForegroundColor Yellow
$cpu = Get-CimInstance Win32_Processor |
    Measure-Object -Property LoadPercentage -Average

Write-Host ("Average CPU Usage: {0:N1}%" -f $cpu.Average)
Write-Host ""

# Memory Usage
Write-Host "Memory Usage:" -ForegroundColor Yellow

$memory = Get-CimInstance Win32_OperatingSystem

$totalMemory = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
$freeMemory = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
$usedMemory = [math]::Round($totalMemory - $freeMemory, 2)
$memoryPercentage = [math]::Round(($usedMemory / $totalMemory) * 100, 1)

Write-Host "Total Memory: $totalMemory GB"
Write-Host "Used Memory: $usedMemory GB"
Write-Host "Memory Usage: $memoryPercentage%"
Write-Host ""

# Disk Space
Write-Host "Disk Space:" -ForegroundColor Yellow

Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object DeviceID,
        @{Name="TotalGB";Expression={[math]::Round($_.Size / 1GB, 2)}},
        @{Name="FreeGB";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}} |
    Format-Table -AutoSize

# Uptime
Write-Host "System Uptime:" -ForegroundColor Yellow

$bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$uptime = (Get-Date) - $bootTime

Write-Host ("Uptime: {0} days, {1} hours" -f $uptime.Days, $uptime.Hours)
Write-Host ""

Write-Host "System health check completed." -ForegroundColor Green
