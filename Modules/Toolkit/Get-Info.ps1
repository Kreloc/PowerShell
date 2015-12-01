Function Get-Info
{
	<#	
		.SYNOPSIS
			Get-Info requires the other functions in the Toolkit module to work. Pulls information from specified computer(s).
		
		.DESCRIPTION
			A detailed description of the Get-Blank function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
			
		.PARAMETER Path
			The destination folder for the text file of computers that were offline and for the html report if the Export switch was used.
			
		.PARAMETER Export		
			A switch parameter that outputs the results of the function into an HTML report.
		
		.EXAMPLE
			Get-Info -ComputerName "THATPC" -Path "C:\Logs" -Export
			
		.EXAMPLE
			Get-Content computers.txt | Get-Info
			
		.EXAMPLE
			Import-Module ActiveDirectory
			Get-ADComputer -SearchBase "OU" | Select Name | Get-Info -Path "C:\Logs" -Export
		
		.NOTES
			Get-Info requires the other functions in the Toolkit module to work. Works on PowerShell Version 2.
	#>	
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $False,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][Alias('Name')] 
        $ComputerName = $env:computername,
		[Parameter(position=1,Mandatory = $false)]
		$Path = "$env:userprofile\Documents",
		[Parameter(Mandatory=$false)]
		[switch]
		$Email
	)
	BEGIN
	{
		Write-Verbose -Message "Retrieving today's date"
		$date = Get-Date -format "yyyy-MM-ddThh_mm_ss"
	}	
	PROCESS
	{
		Write-Verbose "Pinging target computer."
		$ping = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet
		If($ping)
		{
		Write-Verbose "Retrieving the active user from target computer using the Get-ActiveUsers function." 
		$users = Get-ActiveUsers $ComputerName
		Write-Verbose "Retrieving information about the target computer's bios."
		$bios = Get-BiosInfo $ComputerName
		Write-Verbose "Retrieving infromation about the target computer's disk space."
		$disk = Get-DiskSpace $ComputerName
		Write-Verbose "Retrieving infromation about the target computer's IP Configuration."
		$ipconf = Get-IPConfig $ComputerName
		Write-Verbose "Retrieving infromation about the target computer's Operating System."
		$os = Get-OSInfo $ComputerName
		#$sid = Get-SID $ComputerName Get-SID is currently broken.
		$sys = Get-SystemInfo $ComputerName
		$props = <#[ordered]#>@{}
			$props["ComputerName"]=$ComputerName
			$props["Date"]=$Date
			$props["User"]=$users
			$props["SerialNumber"]=$bios.SerialNumber
			$props["Drive"]=$disk.DeviceID
			$props["SizeGB"]=$disk.SizeGB
			$props["FreeSpaceGB"]=$disk.FreeSpaceGB
			$props["PercentFree"]=$disk.PercentFree
			$props["IPAddress"]=$ipconf.IPAddress
			$props["DNSDomain"]=$ipconf.DNSDomain
			$props["MACAddress"]=$ipconf.MACAddress					
			$props["Subnet"]=$ipconf.IPSubnet[0]
			$props["Gateway"]=$ipconf.DefaultIPGateway
			$props["OperatingSystem"]=$os.Caption
			$props["Architecture"]=$os.OSArchitecture
			$props["Description"]=$os.Description
			$props["LastBootUpTime"]=$os.LastBootUpTime
			$props["Domain"]=$sys.Domain
			$props["ComputerModel"]=$sys.Model
			$props["Manufacturer"]=$sys.Manufacturer
		$fininfo = New-Object –TypeName PSObject –Property $props
		$fininfo
		}
		If($ping -eq $false)
		{
			Write-Verbose "Target computer is offline. Outputting computername to text file in $Path."
			$ComputerName >> "$Path\FailedToReach$date.txt"
		}
		If($Email)
		{
			#Email server values. Edit once.
			$SMTPServer = "Your.smpt.server"
			$SMTPPort = 25
			$From = "Your.Email@Address.com"
			$To = "Your.Email@Address.com"
			Write-Verbose "Creating html report file. Sending email to $To"
			$prehtml = '<html><head><title>Computer Report</title><style>body {background-color:WhiteSmoke;}h1, h2 {text-align:center;}.info{font:12px arial,sans-serif;color:DarkGreen;height:83%;width:83%;margin: auto;}.info table {border-collapse: collapse; margin:auto; }td, th {  width: 4rem;  height: 2rem;  border: 1px solid #ccc;  text-align: center;}.info h1 {text-align:center;}.info table th, td {color:ForestGreen;}.flag table td {color:red;}</style><body><div class="info">'
			$endhtml = '</div></body></html>'			
			Do
			{
				$i = 1; $i++
				$biosprops = $fininfo | Select ComputerName, Date, User, SerialNumber | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Bios Information</h2>' -PostContent '</div>'| Out-String
				$driveprops = $fininfo | Select Drive, SizeGB, FreeSpaceGB, PercentFree  | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Hard Drive Information</h2>' -PostContent '</div>'| Out-String
				$ipprops = $fininfo | Select IPAddress, DNSDomain, MACAddress, Subnet, Gateway | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Ipconfig</h2>' -PostContent '</div>'| Out-String
				$osprops = $fininfo | Select OperatingSystem, Architecture, Description, LastBootUpTime | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>OS Information</h2>' -PostContent '</div>'| Out-String
				$sysprops = $fininfo | Select Domain, Manufacturer, JavaVerInstalled | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>System Information</h2>' -PostContent '</div>'| Out-String
				$innerHTML += $biosprops + $driveprops + $ipprops + $osprops + $sysprops
			}
			until($i -gt $fininfo.count)				
			$EmailBody = $prehtml + $innerHtml + $endhtml
			$Subject = "Computer(s) Information Report"
			Send-MailMessage -BodyAsHtml $EmailBody -From $From -Subject $Subject -SmtpServer $SMTPServer -Port $SMTPPort -To $To
		}			
	}
	END
	{		
	}
}