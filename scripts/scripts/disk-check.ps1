# IT Support Automation Toolkit
# Disk Space Monitoring Script

Write-Host "===== DISK SPACE CHECK =====" -ForegroundColor Cyan

$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

foreach ($disk in $disks) {

    $sizeGB = [math]::Round($disk.Size / 1GB, 2)
    $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $freePercent = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)

    Write-Host "`nDrive: $($disk.DeviceID)"
    Write-Host "Total Size: $sizeGB GB"
    Write-Host "Free Space: $freeGB GB"
    Write-Host "Free Space Percentage: $freePercent%"

    if ($freePercent -lt 15) {
        Write-Host "WARNING: Low disk space!" -ForegroundColor Red
    }
    else {
        Write-Host "Disk space status: OK" -ForegroundColor Green
    }
}

Write-Host "`n===== DISK CHECK COMPLETE =====" -ForegroundColor Cyan
