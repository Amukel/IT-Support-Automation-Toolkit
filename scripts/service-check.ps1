# IT Support Automation Toolkit
# Windows Service Health Check

Write-Host "===== WINDOWS SERVICE HEALTH CHECK =====" -ForegroundColor Cyan

$services = @(
    "Spooler",
    "Winmgmt",
    "wuauserv",
    "BITS"
)

foreach ($serviceName in $services) {

    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

    if ($service) {

        Write-Host "`nService: $($service.DisplayName)"
        Write-Host "Status: $($service.Status)"

        if ($service.Status -eq "Running") {
            Write-Host "Health: OK" -ForegroundColor Green
        }
        else {
            Write-Host "WARNING: Service is not running!" -ForegroundColor Red
        }

    }
    else {
        Write-Host "`nService $serviceName was not found." -ForegroundColor Yellow
    }
}

Write-Host "`n===== SERVICE CHECK COMPLETE =====" -ForegroundColor Cyan
