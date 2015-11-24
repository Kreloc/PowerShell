###Begin with helper functions
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
					Copy-Item -Path ".\AdobeUpdater.Overrides" -Destination "\\$ComputerName\c$\ProgramData\Adobe\AAMUpdater\1.0"
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
			$CopyResults = New-Object -TypeName PSObject -Property $props
			$CopyResults
	}
	End{}
}
##End of Set-AdobeOverRide Function
Function Set-ScheduledTask 
{
	<#	
		.SYNOPSIS
			The Set-ScheduledTask function sets all of the scheduled tasks found in the path parameter in xml format to
			the specified computer.
		
		.DESCRIPTION
			The Set-ScheduledTask function sets all of the scheduled tasks found in the path parameter in xml format to
			the specified computer. 
		
		.PARAMETER ComputerName
			The name of the computer to set the scheduled task onto.

		.EXAMPLE
			Set-ScheduledTask "THATPC"
			
			Sets the tasks found in the default location for the Path parameter onto THATPC
			with the user account for the task set to the default of SYSTEM.
			
		.EXAMPLE
			Import-CSV .\computers.csv | Set-ScheduledTask
		
			Sets the tasks found in the default location for the Path parameter onto each computer listed under a 
			ComputerName header in computers.csv with the user account for the task set to the default of SYSTEM.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName = "localhost",
		[Parameter(ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Path = "\\fsjnu\PCSoft\UserApps\Adobe\App Manager - Creative Cloud\Tasks",
		[Parameter(ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$TaskUser = "SYSTEM"
	)
	Begin
	{
		$sch = New-Object -ComObject("Schedule.Service")
	}
	Process 
	{
		$sch.connect("$ComputerName")
		$folder = $sch.GetFolder("\")
		Get-ChildItem -Path $Path -Filter "*.xml" |
		ForEach-Object {
			$TaskName = $_.Name.Replace('.xml','')
			$TaskXML = Get-Content $_.FullName
			$Task = $sch.NewTask($null)
			$Task.XmlText = $TaskXML
			$folder.RegisterTaskDefinition($TaskName, $Task, 6, $TaskUser, $null, 1, $null)
		}
	}
	End{}
}
###End of Set-ScheduledTask function
Set-AdobeUpdateOverride -Verbose
Set-ScheduledTask -Verbose
#End of script