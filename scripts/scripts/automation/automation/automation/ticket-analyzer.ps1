# IT Support Automation Toolkit
# Service Desk Ticket Analyzer

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "       SERVICE DESK TICKET ANALYZER" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$tickets = @(
    [PSCustomObject]@{
        TicketID = "INC001"
        Issue = "User cannot access email"
        Priority = "High"
        Status = "Open"
    },
    [PSCustomObject]@{
        TicketID = "INC002"
        Issue = "Printer not responding"
        Priority = "Medium"
        Status = "In Progress"
    },
    [PSCustomObject]@{
        TicketID = "INC003"
        Issue = "Password reset request"
        Priority = "Low"
        Status = "Resolved"
    },
    [PSCustomObject]@{
        TicketID = "INC004"
        Issue = "Network connectivity failure"
        Priority = "Critical"
        Status = "Open"
    }
)

Write-Host "Ticket Overview:" -ForegroundColor Yellow
$tickets | Format-Table -AutoSize

Write-Host ""

# Count tickets by status
Write-Host "Tickets by Status:" -ForegroundColor Yellow

$tickets |
    Group-Object Status |
    Select-Object Name, Count |
    Format-Table -AutoSize

# Count tickets by priority
Write-Host "Tickets by Priority:" -ForegroundColor Yellow

$tickets |
    Group-Object Priority |
    Select-Object Name, Count |
    Format-Table -AutoSize

# Identify high priority open tickets
Write-Host "High Priority Open Tickets:" -ForegroundColor Yellow

$urgentTickets = $tickets | Where-Object {
    ($_.Priority -eq "Critical" -or $_.Priority -eq "High") -and
    $_.Status -eq "Open"
}

if ($urgentTickets) {
    $urgentTickets | Format-Table -AutoSize
} else {
    Write-Host "No urgent open tickets found." -ForegroundColor Green
}

Write-Host ""
Write-Host "Ticket analysis completed." -ForegroundColor Green
