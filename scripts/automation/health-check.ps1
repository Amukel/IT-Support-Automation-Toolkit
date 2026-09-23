# IT Support Automation Toolkit
# Automated IT Health Check

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       IT SUPPORT HEALTH CHECK          " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`n[1] SYSTEM INFORMATION" -ForegroundColor Yellow

$OS = Get-CimInstance Win32_OperatingSystem
$Computer = Get-CimInstance Win32_ComputerSystem

Write-Host "Computer Name: $env:COMPUTERNAME"
Write-Host "Operating System: $($OS.Caption)"
Write-Host "RAM: $([math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)) GB"
Write-Host "Last Boot: $($OS.LastBootUpTime)"

Write-Host "`n[2] DISK SPACE" -ForegroundColor Yellow

Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    ForEach-Object {

        $freePercent = [math]::Round(
            ($_.FreeSpace / $_.Size) * 100,
            2
        )

        Write-Host "$($_.DeviceID) - $freePercent% free"

        if ($freePercent -lt 15) {
            Write-Host "WARNING: Low disk space!" -ForegroundColor Red
        }
    }

Write-Host "`n[3] NETWORK CONNECTIVITY" -ForegroundColor Yellow

$internet = Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet

if ($internet) {
    Write-Host "Internet Connectivity: OK" -ForegroundColor Green
}
else {
    Write-Host "Internet Connectivity: FAILED" -ForegroundColor Red
}

Write-Host "`n[4] DNS TEST" -ForegroundColor Yellow

try {
    Resolve-DnsName google.com -ErrorAction Stop | Out-Null
    Write-Host "DNS Resolution: OK" -ForegroundColor Green
}
catch {
    Write-Host "DNS Resolution: FAILED" -ForegroundColor Red
}

Write-Host "`n[5] WINDOWS SERVICES" -ForegroundColor Yellow

$criticalServices = @(
    "Spooler",
    "Winmgmt",
    "BITS"
)

foreach ($serviceName in $criticalServices) {

    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($service -and $service.Status -eq "Running") {
        Write-Host "$serviceName : Running" -ForegroundColor Green
    }
    else {
        Write-Host "$serviceName : WARNING" -ForegroundColor Red
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "        HEALTH CHECK COMPLETE           " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
