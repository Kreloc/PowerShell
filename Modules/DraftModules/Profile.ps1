Function Start-Profile
{
	$env:PSModulePath = $env:PSModulePath + ";C:\Modules"
	Import-Module Toolkit
	Set-Location C:\Scripts\
	$date = Get-Date -format "MMddhhmmss"
	Start-Transcript C:\Scripts\PSLogs\pslog$date.txt
	Write-Output "Today is $(Get-Date)"
	$eod = Get-Excuse
	Write-Output "Excuse of the day is $($eod)"
}

