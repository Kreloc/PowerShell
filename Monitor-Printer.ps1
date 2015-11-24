<#Refer to request link here
http://gallery.technet.microsoft.com/scriptcenter/site/requests/monitor-and-notify-of-print-queue-changes-caae7afc
#>
function Monitor-Printer
{
	[CmdletBinding()]
	param
	(	
		[Parameter(Mandatory=$False,
		Position=0)]
		[string[]]$PC=$ENV:ComputerName			
	)
	BEGIN
	{
		$global:printers = Get-Wmibject Win32_Printer -ComputerName $PC 
	}
	PROCESS
	{
		If ($printers)
	}
}