# IT Support Automation Toolkit
# Network Diagnostics Script

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "      NETWORK DIAGNOSTICS TOOL" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Computer name
Write-Host "Computer Name:" -ForegroundColor Yellow
$env:COMPUTERNAME
Write-Host ""

# IP Configuration
Write-Host "IP Configuration:" -ForegroundColor Yellow
Get-NetIPConfiguration |
    Select-Object InterfaceAlias, IPv4Address, IPv6Address, DNSServer |
    Format-List

# Test Internet Connectivity
Write-Host "Internet Connectivity Test:" -ForegroundColor Yellow

$internetTest = Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet

if ($internetTest) {
    Write-Host "Internet connection: OK" -ForegroundColor Green
} else {
    Write-Host "Internet connection: FAILED" -ForegroundColor Red
}

Write-Host ""

# DNS Test
Write-Host "DNS Resolution Test:" -ForegroundColor Yellow

try {
    $dnsTest = Resolve-DnsName google.com -ErrorAction Stop
    Write-Host "DNS resolution: OK" -ForegroundColor Green
} catch {
    Write-Host "DNS resolution: FAILED" -ForegroundColor Red
}

Write-Host ""

# Gateway Test
Write-Host "Default Gateway Test:" -ForegroundColor Yellow

$gateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" |
    Select-Object -First 1 -ExpandProperty NextHop

if ($gateway) {
    $gatewayTest = Test-Connection -ComputerName $gateway -Count 2 -Quiet

    if ($gatewayTest) {
        Write-Host "Gateway ($gateway): OK" -ForegroundColor Green
    } else {
        Write-Host "Gateway ($gateway): FAILED" -ForegroundColor Red
    }
} else {
    Write-Host "Default gateway not found." -ForegroundColor Red
}

Write-Host ""
Write-Host "Network diagnostics completed." -ForegroundColor Cyan
