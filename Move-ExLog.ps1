<#
.SYNOPSIS
This script moves Exchange 2013 log files to new path.

.DESCRIPTION
Edit $Path variable with destination for log files
Commands to delete source files are commented out at end of script

.NOTES
1.0 - 

Move-ExLog.ps1
v1.0
04/23/2018
By Nathan O'Bryan, MVP|MCSM
nathan@mcsmlab.com

.LINK
https://www.mcsmlab.com/about
https://github.com/MCSMLab/Move-ExLog/blob/master/Move-ExLog.ps1

#>

$Path = "E:\Program Files\Microsoft\Exchange Server\V15"
$ExSrv = $env:computername
$Edge = Get-EdgeSyncServiceConfig

Clear-Host

# Move MailBoxServer logs
Write-Host "Move MailBoxServer logs"
Set-MailboxServer -Identity $ExSrv -CalendarRepairLogPath "$Path\Logging\Calendar Repair Assistant"
Set-MailboxServer -Identity $ExSrv -MigrationLogFilePath  "$Path\Logging\Managed Folder Assistant"

# Move MailboxTransportService logs
Write-host "Move MailboxTransportService logs"
Set-MailboxTransportService -Identity $ExSrv -ConnectivityLogPath "$Path\TransportRoles\Logs\Mailbox\Connectivity"
Set-MailboxTransportService -Identity $ExSrv -MailboxDeliveryAgentLogPath "$Path\TransportRoles\Logs\Mailbox\AgentLog\Delivery"
Set-MailboxTransportService -Identity $ExSrv -MailboxSubmissionAgentLogPath "$Path\TransportRoles\Logs\Mailbox\AgentLog\Submission"
Set-MailboxTransportService -Identity $ExSrv -ReceiveProtocolLogPath "$Path\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpReceive"
Set-MailboxTransportService -Identity $ExSrv -SendProtocolLogPath "$Path\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpSend"
Set-MailboxTransportService -Identity $ExSrv -PipelineTracingPath "$Path\TransportRoles\Logs\Mailbox\PipelineTracing"

# Move TransportService logs
Write-host "Move TransportService logs"
Set-TransportService -Identity $ExSrv -ConnectivityLogPath "$Path\V15\TransportRoles\Logs\Hub\Connectivity"
Set-TransportService -Identity $ExSrv -MessageTrackingLogPath "$Path\TransportRoles\Logs\MessageTracking" 
Set-TransportService -Identity $ExSrv -IrmLogPath "$Path\Microsoft\Exchange Server\V15\Logging\IRMLogs"
Set-TransportService -Identity $ExSrv -ActiveUserStatisticsLogPath "$Path\TransportRoles\Logs\Hub\ActiveUsersStats"
Set-TransportService -Identity $ExSrv -ServerStatisticsLogPath "$Path\TransportRoles\Logs\Hub\ServerStats"
Set-TransportService -Identity $ExSrv -ReceiveProtocolLogPath "$Path\TransportRoles\Logs\Hub\ProtocolLog\SmtpReceive"
Set-TransportService -Identity $ExSrv -RoutingTableLogPath "$Path\TransportRoles\Logs\Hub\Routing"
Set-TransportService -Identity $ExSrv -SendProtocolLogPath "$Path\TransportRoles\Logs\Hub\ProtocolLog\SmtpSend"
Set-TransportService -Identity $ExSrv -QueueLogPath "$Path\TransportRoles\Logs\Hub\QueueViewer"
Set-TransportService -Identity $ExSrv -WlmLogPath "$Path\TransportRoles\Logs\Hub\WLM"
Set-TransportService -Identity $ExSrv -PipelineTracingPath "$Path\TransportRoles\Logs\Hub\PipelineTracing"
Set-TransportService -Identity $ExSrv -AgentLogPath "$Path\TransportRoles\Logs\Hub\AgentLog"

# Move FrontEndTransportService logs
Write-Host "Move FrontEndTransportService logs"
Set-FrontendTransportService  -Identity $ExSrv -AgentLogPath "$Path\TransportRoles\Logs\FrontEnd\AgentLog"
Set-FrontendTransportService  -Identity $ExSrv -ConnectivityLogPath "$Path\TransportRoles\Logs\FrontEnd\Connectivity"
Set-FrontendTransportService  -Identity $ExSrv -ReceiveProtocolLogPath "$Path\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive"
Set-FrontendTransportService  -Identity $ExSrv -SendProtocolLogPath "$Path\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpSend"

# Move PERFMON logs
Write-Host "Move PERFMON logs"
logman -stop ExchangeDiagnosticsDailyPerformanceLog 
logman -update ExchangeDiagnosticsDailyPerformanceLog -o "$Path\Logging\Diagnostics\DailyPerformanceLogs\ExchangeDiagnosticsDailyPerformanceLog"
logman -start ExchangeDiagnosticsDailyPerformanceLog 
logman -stop ExchangeDiagnosticsPerformanceLog 
logman -update ExchangeDiagnosticsPerformanceLog -o "$Path\Logging\Diagnostics\PerformanceLogsToBeProcessed\ExchangeDiagnosticsPerformanceLog"
logman -start ExchangeDiagnosticsPerformanceLog 

# Move EdgeSync logs
Write-Host "Move EdgeSync logs"
Set-EdgeSyncServiceConfig -Identity $Edge.Identity -LogPath "$Path\TransportRoles\Logs\EdgeSync"

# Move IMAP logs
Write-Host "Move IMAP logs"
Set-ImapSettings -LogFileLocation "$Path\Logging\Imap4"

# Move POP3 logs
Write-host "Move POP3 logs"
Set-PopSettings -LogFileLocation "$Path\Logging\Pop3"

<#
# Delete the old log files that we just moved
Write-Host "Delete the old log files that we just moved"
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\Connectivity" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\MessageTracking" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\IRMLogs" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ActiveUsersStats" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ServerStats" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ProtocolLog\SmtpReceive" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\Routing" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\ProtocolLog\SmtpSend" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\QueueViewer" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\WLM" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\PipelineTracing" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Hub\AgentLog" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\EdgeSync" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\AgentLog" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\Connectivity" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpReceive" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\FrontEnd\ProtocolLog\SmtpSend" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Imap4" -force -rec
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Calendar Repair Assistant" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Managed Folder Assistant" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\Connectivity" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\AgentLog\Delivery" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\AgentLog\Submission" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpReceive" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\ProtocolLog\SmtpSend" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\Mailbox\PipelineTracing" -force -rec 
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Pop3" -force -rec
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Diagnostics\DailyPerformanceLogs\" -force -rec
rmdir -path "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Diagnostics\PerformanceLogsToBeProcessed\" -force -rec
#>
