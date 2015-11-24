Function Get-ActiveUsers
{
	<#	
		.SYNOPSIS
			This function gets the activer user on specified computer.
		
		.DESCRIPTION
			This function gets the activer user on specified computer as defined by the running explorer process on their system.
		
		.PARAMETER ComputerName
			The name of the computer to be used to determine the active user.
		
		.EXAMPLE
			Get-ActiveUsers -ComputerName "THATPC"
			
		.EXAMPLE
			Get-Content computers.txt | Get-ActiverUsers
		
		.NOTES
			Even though this function accepts computernames from the pipeline, it is best used to only determine one computer at a time, since there is no computername output at this time.
	#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName = $env:computername
	)
	PROCESS
	{
		($uid = @(Get-WmiObject -class win32_process -ComputerName $ComputerName -filter "ExecutablePath like '%explorer.exe'" -EA "continue" | Foreach-Object {$_.GetOwner().User}  | Where-Object {$_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM"} | Sort-Object -Unique))
		If($uid -like "")
		{
			Write-Output "No user found logged onto $ComputerName"
		}
	}
}