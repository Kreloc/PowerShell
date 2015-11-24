Function Get-ServiceDetails($ComputerName)
{
Get-WMIObject -Class Win32_Service -ComputerName $ComputerName | Select __Server, Name, Startmode, State, StartName
} 