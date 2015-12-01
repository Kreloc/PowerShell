Function Get-FirstLogEvent($ComputerName)
{
	$logs = Get-Winevent -ListLog * -ComputerName $ComputerName -ErrorAction SilentlyContinue | Where {$_.RecordCount -gt 0} | Select -ExpandProperty LogName
	$results = $null
	[array]$results += ForEach($log in $logs)
	{
		Get-WinEvent -LogName $log -MaxEvents 1 -ComputerName $ComputerName | Select TimeCreated, LogName, ID, Message
	}
	$results | Sort TimeCreated -Descending
}