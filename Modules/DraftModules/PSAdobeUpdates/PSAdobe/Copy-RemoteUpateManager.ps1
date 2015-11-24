Function Copy-RemoteUpateManager 
{
	<#	
		.SYNOPSIS
			A brief description of the Copy-RemoteUpateManager function.
		
		.DESCRIPTION
			A detailed description of the Copy-RemoteUpateManager function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Copy-RemoteUpateManager <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Copy-RemoteUpateManager
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName")]
		[string]$ComputerName	
	)
	Begin{}
	Process 
	{
		If(Test-Path "\\$($ComputerName)\c$\Program Files (x86)\Adobe\")
		{
		    Copy-Item "\\fsjnu\PCSoft\UserApps\Adobe\App Manager - Creative Cloud\RemoteUpdateManager.exe" -Destination "\\$($ComputerName)\c$\Program Files (x86)\Adobe\"
		    $props = @{
		            ComputerName=$_.ComputerName
		            FileCopied=$True
		    }
		}
		else
		{
		    $props = @{
		            ComputerName=$_.ComputerName
		            FileCopied=$False
		            }
		}
		New-Object -TypeName PSObject -Property $props		
	}
	End{}
}