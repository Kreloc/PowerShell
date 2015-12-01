Function Get-RunningServices($PC)
{
	Get-Service -ComputerName $PC | Where {$_.Status -eq "Running" -and $_.CanStop}
}