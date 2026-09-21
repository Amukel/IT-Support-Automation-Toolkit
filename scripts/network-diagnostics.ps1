# IT Support Automation Toolkit
# Network Diagnostics Script

Write-Host "===== NETWORK DIAGNOSTICS =====" -ForegroundColor Cyan

Write-Host "`nComputer Name:" -ForegroundColor Yellow
$env:COMPUTERNAME

Write-Host "`nIP Configuration:" -ForegroundColor Yellow
Get-NetIPConfiguration

Write-Host "`nNetwork Adapters:" -ForegroundColor Yellow
Get-NetAdapter |
    Select-Object Name, InterfaceDescription, Status, LinkSpeed

Write-Host "`nTesting Internet Connectivity:" -ForegroundColor Yellow
Test-Connection -ComputerName 8.8.8.8 -Count 4

Write-Host "`nTesting DNS Resolution:" -ForegroundColor Yellow
Resolve-DnsName google.com

Write-Host "`nTesting HTTPS Connectivity:" -ForegroundColor Yellow
Test-NetConnection google.com -Port 443

Write-Host "`n===== NETWORK DIAGNOSTICS COMPLETE =====" -ForegroundColor Green
