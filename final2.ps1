Param (
    [string]$outputDir="D:\temp\", 
    [bool]$applicationLogs=$true,
    [bool]$systemLog=$true,
    [datetime]$fromDate=(Get-Date).AddDays(-30),
    [array]$severity=@('Error','Warning')
      )

$log_type=@('Error', 'Information', 'FailureAudit', 'SuccessAudit', 'Warning')   ####Log type in windows
$dt=Get-Date -Format "yyyyMMddHHmmss"                                            ####date format for output files                                  
####Check path to output dir
if(!(Test-Path $outputDir))
{
    Write-Host "Output path is wrong, please check it."
    exit
}
####check log type
$severity | ForEach-Object {
if($log_type -notcontains $_)
{
    Write-Host "Wrong log type"
    exit
}}
####check log flags
if ((!$systemLog) -and (!$applicationLogs)){
    Write-Host "No Log file selected"
    exit
}
####parse applog
if ($applicationLogs)
{
    Get-EventLog -LogName Application -EntryType $severity -After $fromDate | Select-Object -Property MachineName, TimeGenerated, EntryType, Source, Message | Export-Csv -Path "$outputDir\ApplicationLogs_$dt.csv"
}
####parse systemlog
if ($systemLog)
{
    Get-EventLog -LogName System -EntryType $severity -After $fromDate | Select-Object -Property MachineName, TimeGenerated, EntryType, Source, Message  | Export-Csv -Path "$outputDir\SystemLogs_$dt.csv"
}
return "File are created in $outputDir"