Function Get-RemoteUpdaterLogs 
{
	<#	
		.SYNOPSIS
			Get-RemoteUpdaterLog retrieves the logs for Adobe's Remote Update Manager (RUM) that downloads
			and install updates for Adobe Creative Cloud packages.
		
		.DESCRIPTION
			Get-RemoteUpdaterLog retrieves the logs for Adobe's Remote Update Manager (RUM) that downloads
			and install updates for Adobe Creative Cloud packages. It emails me the results and attaches a csv
			of all did not run sucessfully.
		
		.PARAMETER ComputerName
			The name of the computer to retrieve the log file from.

		.EXAMPLE
			Get-RemoteUpdaterLogs <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Get-RemoteUpdaterLogs
		
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
	Begin
	{
		#Email values for Send-MailMessage
		#Edit these values once
		$SMTPServer = "smpt.your.local"
		$SMTPPort = 25		
		#$Body = "Body of email"
		$From = "Your.Address@email.com"
		$To = "Recipient.Adress@email.com"
		$Subject = "Computer(s) status for running Adobe RUM"
		$DateGathered = Get-Date -Format "yyyyMMdd"
	}
	Process 
	{
		If(Test-Path "\\$($ComputerName)\c$\Windows\Temp\RemoteUpdateManager.log")
		{
			$LogText = (Get-Content "\\$($ComputerName)\c$\Windows\Temp\RemoteUpdateManager.log" -Tail 25)
			$ReturnCode = (($LogText | Where {$_ -like "*Return code*"}) -replace ".*Return Code \(","") -replace "\)",""
			$props = @{
			ComputerName=$ComputerName
			LogText = $LogText -join ";"
			ReturnCode = $ReturnCode
			}
		}
		else
		{
			$props= @{
			ComputerName=$ComputerName
			LogText = "Log file not found."
			ReturnCode = 8
			}
		}
		$Logs = New-Object -TypeName PSObject -Property $props
		$Logs
		$Logs | Export-CSV "C:\Scripts\AUSClientMonitoring\LogsFor$($DateGathered).csv" -NoTypeInformation -Append -NoClobber
	}
	End
	{
		$AllCSV = Import-CSV "C:\Scripts\AUSClientMonitoring\LogsFor$($DateGathered).csv"
		$AttachedCSV = $AllCSV | Where {$_.ReturnCode -ne 0}
		$AttachedCSV | Export-CSV "C:\Scripts\AUSClientMonitoring\LogsIssuesWithRUMFor$($DateGathered).csv" -NoTypeInformation -Append -NoClobber
		$BeginEmail = "Below are computers log files were retreived from. If they returned a value other than 0, refer to attached CSV file for log snippet."
		$BodyEmail = $AllCSV | Select ComputerName, ReturnCode | Sort ReturnCode | ConvertTo-HTML -Fragment
		$AttachMent = "C:\Scripts\AUSClientMonitoring\LogsIssuesWithRUMFor$($DateGathered).csv"
		$Body = $BeginEmail + $BodyEmail
		Send-MailMessage -Subject $Subject -To $To -From $From -BodyAsHtml $Body -SmtpServer $SMTPServer -Port $SMTPPort -AttachMent $AttachMent
	}
}