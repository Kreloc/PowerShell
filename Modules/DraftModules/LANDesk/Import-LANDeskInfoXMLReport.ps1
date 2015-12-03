Function Import-LANDeskInfoXMLReport 
{
	<#	
		.SYNOPSIS
			The Import-LANDeskInfoXMLReport function creates a PowerShell object from an exported LANDesk XML report.
		
		.DESCRIPTION
			The Import-LANDeskInfoXMLReport function creates a PowerShell object from an exported LANDesk XML report.
		
		.PARAMETER Path
			The file path to the exported LANDesk report.

		.EXAMPLE
			Import-LANDeskInfoXMLReport -Path C:\Scripts\GFIRemaining.xml
			
			Turns the xml report into a custom PowerShell object.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Path	
	)
	Begin
	{
		[xml]$GFIRemaining = Get-Content $Path 
	}
	Process
	{
		ForEach ($Report in $GFIRemaining.Report.TableCustom1.Detail_Collection.Detail)
		{
			$props = @{ComputerName=$Report.textBoxDetail1
						OS=$Report.textBoxDetail2
						GfiInstalled=$Report.textBoxDetail3
						LastLoggedOnUser=$Report.textBoxDetail4
						LastUpdateScanDate=$Report.textBoxDetail5
						SID=$Report.textBoxDetail6
						IPAddress=$Report.textBoxDetail7
						AgentConfigurationDate=$Report.textBoxDetail8
						LastSoftwareScanDate=$Report.textBoxDetail9
						SerialNumber=$Report.textBoxDetail10
						AgentVersion=$Report.textBoxDetail11
						Decsription=$Report.textBoxDetail12
			}
			$LANDeskXMLReport = New-Object –TypeName PSObject –Property $props
			$LANDeskXMLReport
		}		
	}
	End
	{}
}