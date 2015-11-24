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
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][Alias('Name')] 
        $ComputerName,
		[Parameter(position=1,Mandatory = $false)]
		$Path = "$env:userprofile\Documents",
		[Parameter(Mandatory=$false)]
		[switch]
		$Export
	)
	BEGIN
	{
		Write-Verbose -Message "Retrieving today's date"
		$date = Get-Date -format "MMddhhmmss"
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
		If($Export)
		{
			Write-Verbose "Creating html report file. Outputting html file to $Path"
			$prehtml = '<html><head><title>Computer Report</title><style>body {background-color:WhiteSmoke;}h1, h2 {text-align:center;}.info{font:12px arial,sans-serif;color:DarkGreen;height:83%;width:83%;margin: auto;}.info table {border-collapse: collapse; margin:auto; }td, th {  width: 4rem;  height: 2rem;  border: 1px solid #ccc;  text-align: center;}.info h1 {text-align:center;}.info table th, td {color:ForestGreen;}.flag table td {color:red;}</style><body><div class="info">'
			$endhtml = '</div></body></html>'			
			Do
			{
				$i = 1; $i++
				$allinfo = $fininfo | Select ComputerName, Date, User, SerialNumber, Drive, SizeGB, FreeSpaceGB, PercentFree, IPAddress, DNSDomain, MACAddress, Subnet, Gateway, OperatingSystem, Architecture, Description, LastBootUpTime, Domain, Manufacturer | ConvertTo-HTML -Fragment -PreContent '<div class="sysinfo"><h2>System Information</h2>' -PostContent '</div>'| Out-String
				<#$biosprops = $fininfo | Select ComputerName, Date, User, SerialNumber | ConvertTo-HTML -Fragment -PreContent '<div class="bios"><h2>Bios Information</h2>' -PostContent '</div>'| Out-String
				$driveprops = $fininfo | Select Drive, SizeGB, FreeSpaceGB, PercentFree  | ConvertTo-HTML -Fragment -PreContent '<div class="hdd"><h2>Hard Drive Information</h2>' -PostContent '</div>'| Out-String
				$ipprops = $fininfo | Select IPAddress, DNSDomain, MACAddress, Subnet, Gateway | ConvertTo-HTML -Fragment -PreContent '<div class="ipconfig"><h2>Ipconfig</h2>' -PostContent '</div>'| Out-String
				$osprops = $fininfo | Select OperatingSystem, Architecture, Description, LastBootUpTime | ConvertTo-HTML -Fragment -PreContent '<div class="os"><h2>OS Information</h2>' -PostContent '</div>'| Out-String
				$sysprops = $fininfo | Select Domain, Manufacturer, JavaVerInstalled | ConvertTo-HTML -Fragment -PreContent '<div class="sysinfo"><h2>System Information</h2>' -PostContent '</div>'| Out-String
				$innerHTML += $biosprops + $driveprops + $ipprops + $osprops + $sysprops
			#>
			$innerHTML += $allinfo
			}
			until($i -gt $fininfo.count)				
			$prehtml + $innerHtml + $endhtml | Out-File "$Path\Report$date.htm"
		}			
	}
	END
	{		
	}
}
#Helper functions Get-Info requires
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
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName
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
Function Get-BiosInfo 
{
<#
	.SYNOPSIS
		This function returns the serial number and description of the BIOS on the computer(s) specified.
	.DESCRIPTION
		This function returns the serial number and description of the BIOS on the computer(s) specified. Leverages the Win32_BIOS WMI Class. 
	.EXAMPLE
		Get-BiosInfo -ComputerName "THATPC"
	.EXAMPLE
		Get-Content computers.txt | Get-BiosInfo 
	.PARAMETER ComputerName
		The name of the computer to retrieve serial number and description from.
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName
	)
	PROCESS 
	{
		Get-WmiObject Win32_Bios -ComputerName $ComputerName | Select @{name="PC";expression={$_.__Server}}, SerialNumber, Description
	}
}
Function Get-CPUInfo
{
	<#	
		.SYNOPSIS
			Get-CPUInfo retrieves information about the CPU of the target computer.
		
		.DESCRIPTION
			Get-CPUInfo retrieves information about the CPU of the target computer(s). Leverages the Win32_Processor WMI class.
		
		.PARAMETER ComputerName
			The name of the computer to retrieve information from.
		
		.EXAMPLE
			Get-CPUInfo -ComputerName "THATPC"
			
		.EXAMPLE
			Get-Content computers.txt | Get-CPUInfo
		
		.NOTES
			Helper function for Get-Info.
	#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName	
	)
	PROCESS 
	{
		Get-WmiObject Win32_Processor -ComputerName $ComputerName | Select Name, NumberofCores, Description, Addresswidth, Manufacturer
	}	
}
function Get-DiskSpace 
{
	<#
	.SYNOPSIS
	This function returns capacity and freespace in gigs and percent free on computer specified.
	.DESCRIPTION
	This function returns capacity and freespace in gigs and percent free on computer specified. By default it returns the system drive. Mutliple drive letters can be entered for the drive parameter. Leverages Win32_LogicalDisk. For more information, see
	http://msdn.microsoft.com/en-us/library/aa394173(v=vs.85).aspx
	.EXAMPLE
	Get-DiskDrive -ComputerName "THATPC" -drive "C:"
	.EXAMPLE
	Get-DiskDrive -ComputerName "THATPC" -drive "C:,K:,Z:"
	.PARAMEters -ComputerName -drive
	#>
		[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName,
		$drive = $env:SystemDrive
	)
	PROCESS 
	{
		Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName -Filter "DeviceID = '$drive'" | Select @{name="PC";expression={$_.__Server}}, DeviceID, @{name="SizeGB";expression={([Math]::Round( ($_.Size / 1GB) , 2 ) )}}, @{name="FreeSpaceGB";expression={([Math]::Round( ($_.FreeSpace / 1GB) , 2 ) )}}, @{name="PercentFree";expression={([Math]::Round(($_.FreeSpace / $_.Size)*100))}}
	}
}
Function Get-IPConfig 
{
	<#
	.SYNOPSIS
	Retrieve information on active network connections on computer(s) specified. If only the PCName is returned, it failed to connect to the computer.
	.DESCRIPTION
	Retrieves network adapter information and IP Address settings on computer(s) specified. Leverages Win32_NetworkAdapter and Win32_NetworkAdapterConfiguration. For more info on these two Classes, see
	http://msdn.microsoft.com/en-us/library/aa394216(v=vs.85).aspx
	and
	http://msdn.microsoft.com/en-us/library/aa394217(v=vs.85).aspx
	.EXAMPLE
	Get-IPConfig -ComputerName "THATPC"
	This will retrive the IPAddress, DNSDomain, the hostname, the Default Gateway, the MACAddress, and the IP Subnet set on the active network interface(s) of the computer THATPC.
	.EXAMPLE
	Get-ADComputer * | Select -ExpandProperty Name | Get-IPConfig
	This will retrive the ipconfig information every computer in AD for each active network interface. DO NOT USE THIS EXAMPLE.
	.PARAMETER ComputerName
	The computer name to query
#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName	
	)
	PROCESS
	{
		Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $ComputerName  -Filter "IPEnabled = true" | select DNSHostName, DNSDomain, @{name="IPAddress";expression={$_ | Select -ExpandProperty IPAddress}}, @{name="DefaultIPGateway";expression={$_ | Select -ExpandProperty DefaultIPGateway}},@{name="DNSServerSearchOrder";expression={$_.DNSServerSearchOrder -join " , "}}, MacAddress, IPSubnet
	} 
}
Function Get-OSInfo 
{
<#
.SYNOPSIS
	This function returns the Name of the OS, the OS Version, OS Architechture (32-bit or 64-bit), Last Boot Up Time, and Free RAM of specified computer(s).
.DESCRIPTION
	This function returns the Name of the OS, the OS Version, OS Architechture (32-bit or 64-bit), Last Boot Up Time, and Free RAM of specified computer(s) from Win32_OperatingSystem.
.EXAMPLE
	Get-OSInfo Family
.EXAMPLE
	List of computers | Get-OSInfo
.PARAMETER ComputerName
	The name of the computer the information is to be retrieved from.
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName	
	)
	PROCESS 
	{
			Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName | Select Caption, Version, Description, OSArchitecture, FreePhysicalMemory , @{name="PC";expression={$_.__Server}}, @{name="LastBootUpTime";expression={$_.ConvertToDateTime($_.LastBootUpTime)}}
	}
}
Function Get-SystemInfo 
{
	<#
	.SYNOPSIS
	This function returns the Name, Domain or Workgroup if not joined to a domain, Model and manufacturer of specified computer(s).
	.DESCRIPTION
	This function returns the Name, Domain or Workgroup if not joined to a domain, Model and manufacturer of specified computer(s) from Win32_ComputerSystem.
	.EXAMPLE
	Get-SystemInfo -ComputerName "THATPC"
	.EXAMPLE
	Get-Content computers.txt | Get-SystemInfo
	.PARAMETERS -ComputerName
	The name of the computer to retrieve information from.
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName	
	)
	PROCESS 
	{
		Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName | Select Name, Domain, Model, Manufacturer
	}
}
