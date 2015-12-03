Function ConvertFrom-LANDeskTaskXML 
{
	<#	
		.SYNOPSIS
			The ConvertFrom-LANDeskTaskXML function creates a PowerShell object from an exported LANDesk XML report.
		
		.DESCRIPTION
			The ConvertFrom-LANDeskTaskXML function creates a PowerShell object from an exported LANDesk XML report.
		
		.PARAMETER Path
			The path to the xml file exported from LANDesk. This file must be created from a report generated in the GUI of
			LANDesk Management Console and exported to xml.

		.EXAMPLE
			ConvertFrom-LANDeskTaskXML -Path C:\Scripts\GFIRemaining.xml
			
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
						User=$Report.textBoxDetail2
						IPAddress=$Report.textBoxDetail3
						LastUpdate=$Report.textBoxDetail4
						Stage=$Report.textBoxDetail5
						Status=$Report.textBoxDetail6
						Results=$Report.textBoxDetail7
						ReturnCode=$Report.textBoxDetail8
						Package=$Report.textBoxDetail9
						HostName=$Report.textBoxDetail10
						LDAPObjectName=$Report.textBoxDetail11
						QueryName=$Report.textBoxDetail12
						Message=$Report.textBoxDetail13
						LogFile=$Report.textBoxDetails14
			}
			$LANDeskXMLReport = New-Object -TypeName PSObject -Property $props
			$LANDeskXMLReport
		}		
	}
	End
	{}
}