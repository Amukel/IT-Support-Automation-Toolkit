# IT Support Automation Toolkit
# System Information Collection Script

Write-Host "===== SYSTEM INFORMATION =====" -ForegroundColor Cyan

$ComputerName = $env:COMPUTERNAME
$OS = Get-CimInstance Win32_OperatingSystem
$CPU = Get-CimInstance Win32_Processor
$Memory = Get-CimInstance Win32_ComputerSystem

Write-Host "Computer Name : $ComputerName"
Write-Host "Operating System : $($OS.Caption)"
Write-Host "OS Version : $($OS.Version)"
Write-Host "CPU : $($CPU.Name)"
Write-Host "RAM : $([math]::Round($Memory.TotalPhysicalMemory / 1GB, 2)) GB"
Write-Host "Last Boot : $($OS.LastBootUpTime)"

Write-Host "`n===== DISK INFORMATION =====" -ForegroundColor Cyan

Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object DeviceID,
        @{Name="Size(GB)";Expression={[math]::Round($_.Size / 1GB, 2)}},
        @{Name="Free(GB)";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}

Write-Host "`nSystem information collection complete." -ForegroundColor Green
