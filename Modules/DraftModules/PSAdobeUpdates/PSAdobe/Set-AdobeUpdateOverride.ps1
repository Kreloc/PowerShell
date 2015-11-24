Function Set-AdobeUpdateOverride 
{
	<#	
		.SYNOPSIS
			The Set-AdobeUpdateOverride function places the override file on the specified computer.
		
		.DESCRIPTION
			The Set-AdobeUpdateOverride function places the override file on the specified computer using admin shares.
		
		.PARAMETER ComputerName
			The name of the target computer.

		.EXAMPLE
			Set-AdobeUpdateOverride <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Set-AdobeUpdateOverride
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName = $env:computername
	)
	Begin
	{}
	Process 
	{
		Write-Verbose "Pinging $ComputerName"
		If(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet)
		{
			Write-Verbose "Testing destination location on $ComputerName"
			If(Test-Path "\\$ComputerName\c$\ProgramData\Adobe\AAMUpdater\")
			{
				Write-Verbose "Testing for existence of overrides file"
				If(Test-Path "\\$ComputerName\c$\ProgramData\Adobe\AAMUpdater\1.0\AdobeUpdater.Overrides")
				{
					Write-Verbose "Override file exists already"
					$OverRideExists = "True"
				}
				else
				{
					Write-Verbose "Copying overrides file to target computer"
					Copy-Item -Path "C:\Scripts\AdobeUpdater.Overrides" -Destination "\\$ComputerName\c$\ProgramData\Adobe\AAMUpdater\1.0"
					$AAMUpdaterExists = "True"
					Write-Verbose "Verifying file was copied to target computer"
					If(Test-Path "\\$ComputerName\c$\ProgramData\Adobe\AAMUpdater\1.0\AdobeUpdater.Overrides")
					{
						$OverRideCopied = "True"
						$OverRideExists = "True"
					}
					else
					{
						$OverRideCopied = "False"
						$OverRideExists = "False"
					}
				}
			}
			else
			{
				$AAMUpdaterExists = "False"
				$OverRideCopied = "False"
			}
			$Online = "True"
		}
		else
		{
			$AAMUpdaterExists = "Unknown"
			$OverRideCopied = "False"
			$Online = "False"
			$OverRideExists = "False"
		}
		Write-Verbose "Creating custom output object of results"
			$props = @{ComputerName=$ComputerName
						AAMUpdaterExists=$AAMUpdaterExists
						OverRideCopied=$OverRideCopied
						Online=$Online
			}
			$CopyResults = New-Object –TypeName PSObject –Property $props
			$CopyResults
	}
	End{}
}