##Below function requires Admin shares to be available.
function Get-JavaVer
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)] 
        $ComputerName
	)	
	PROCESS
	{
		try
		{
			$ErrorActionPreference = "Stop"
			$java = gci "\\$ComputerName\c$\Program Files (x86)\Java\jre7\bin\java.exe"
			$java.VersionInfo			
		}
		catch
		{
			$Error[0].Exception >> errors.txt
		}
		finally
		{
			$ErrorActionPreference = "Continue"
		}

	}
}
Function Get-ActiveUsers
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName
	)
	PROCESS
	{
		($uid = @(Get-WmiObject -class win32_process -ComputerName $ComputerName -filter "ExecutablePath like '%explorer.exe'" -EA "continue" | Foreach-Object {$_.GetOwner().User}  | Where-Object {$_ -ne "NETWORK SERVICE" -and $_ -ne "LOCAL SERVICE" -and $_ -ne "SYSTEM"} | Sort-Object -Unique))
		If($uid -like "")
		{
			Write-Output "No user"
		}
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
.PARAMETERS -ComputerName
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName	
	)
	PROCESS 
	{
			Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName | Select Caption, Version, Description, OSArchitecture, FreePhysicalMemory , @{name="PC";expression={$_.__Server}}, @{name="LastBootUpTime";expression={$_.ConvertToDateTime($_.LastBootUpTime)}}
	}
}
function Get-Updates
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)] 
        $ComputerName
	)
	PROCESS
	{
	[System.Reflection.Assembly]::LoadWithPartialName(‘Microsoft.Update.Session‘) | Out-Null
    $Session = [activator]::CreateInstance([type]::GetTypeFromProgID(“Microsoft.Update.Session“,$ComputerName))
    $Searcher = $Session.CreateUpdateSearcher()
    $historyCount = $Searcher.GetTotalHistoryCount()
    $Searcher.QueryHistory(0, $historyCount) | Select-Object Date,
    @{name="Operation"; expression={switch($_.operation){
    1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}},
    @{name="Status"; expression={switch($_.resultcode){
	1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};
	4 {"Failed"}; 5 {"Aborted"}
	}}}, Title,@{name="KB"; expression={($_.title -split "(KB*.*)")[1]}},@{name="PC";expression={$ComputerName}}
	}
}
Function Set-Description
{
	[CmdletBinding()]
	Param
	(
	[Parameter(Mandatory=$True,Position=0)]
	[string]$ComputerName,	
	[Parameter(Mandatory=$True, Position=1)]
	[string]$Description
	)
	PROCESS
	{
			$OSValues = Get-WmiObject -class Win32_OperatingSystem -computerName $ComputerName
			[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
			$Description = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Desired Computer Description ")			
			$OSValues.Description = "$Description"
	}
}
function Get-IPConfig 
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
	Get-IPConfig FAMILY
	This will retrive the IPAddress, DNSDomain, the hostname, the Default Gateway, the MACAddress, and the IP Subnet set on the active network interface(s) of the computer FAMILY.
	.EXAMPLE
	Get-ADComputer * | Select -ExpandProperty Name | Get-IPConfig
	This will retrive the ipconfig information every computer in AD for each active network interface.
	The computer name to query
	.PARAMETER ComputerName
#>
	[CmdletBinding()] #states that this function should act just like a cmdlet
	param(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName	
	)
	PROCESS #Any lines coming down the pipeline, I process here, and here is the code we’re going to run against those.
	{
		Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $ComputerName  -Filter "IPEnabled = true" | select DNSHostName, DNSDomain, @{name="IPAddress";expression={$_ | Select -ExpandProperty IPAddress}}, @{name="DefaultIPGateway";expression={$_ | Select -ExpandProperty DefaultIPGateway}},@{name="DNSServerSearchOrder";expression={$_.DNSServerSearchOrder -join " , "}}, MacAddress, IPSubnet
	} #End of PROCESS
} #End of function
function Get-DiskDrive 
{
	<#
	.SYNOPSIS
	This function returns capacity and freespace in gigs and percent free on computer specified.
	.DESCRIPTION
	This function returns capacity and freespace in gigs and percent free on computer specified. By default it returns the system drive. Mutliple drive letters can be entered for the drive parameter. Leverages Win32_LogicalDisk. For more information, see
	http://msdn.microsoft.com/en-us/library/aa394173(v=vs.85).aspx
	.EXAMPLE
	Get-DiskDrive Family C:
	.EXAMPLE
	Get-DiskDrive Family C:,K:,Z:
	.PARAMEters -ComputerName -drive
	#>
		[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName,
		[string]$drive = $env:SystemDrive #Defaults this variable to the system drive.
	)
	PROCESS 
	{
		Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName -Filter "DeviceID = '$drive'" | Select @{name="PC";expression={$_.__Server}}, DeviceID, @{name="SizeGB";expression={([Math]::Round( ($_.Size / 1GB) , 2 ) )}}, @{name="FreeSpaceGB";expression={([Math]::Round( ($_.FreeSpace / 1GB) , 2 ) )}}, @{name="PercentFree";expression={([Math]::Round(($_.FreeSpace / $_.Size)*100))}}
	} #End of PROCESS
} #End of function
Function Get-BiosInfo 
{
<#
.SYNOPSIS
	This function returns the serial number and description of the BIOS on the computer(s) specified.
.DESCRIPTION
	This function returns the serial number and description of the BIOS on the computer(s) specified. Leverages Win32_BIOS. 
.EXAMPLE
	Get-BiosInfo Family
.EXAMPLE
	Get-Content computers.txt | Get-BiosInfo 
.PARAMETERS -ComputerName
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True, # It is mandatory (required).
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)] # It takes input from the pipeline.
		$ComputerName	 # It takes an array of strings as input
	)
	PROCESS 
	{
		Get-WmiObject Win32_Bios -ComputerName $ComputerName | Select @{name="PC";expression={$_.__Server}}, SerialNumber, Description
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
	Get-SystemInfo Family
	.EXAMPLE
	Get-SystemInfo Family
	.PARAMETERS -ComputerName
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		$ComputerName	
	)
	PROCESS 
	{
		Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName | Select Name, Domain, Model, Manufacturer
	}
}
Function Find-JavaVer
{
	((Invoke-WebRequest -Uri "http://java.com/en/download/index.jsp").RawContent -match "Version.*") | Out-Null
	$matches.Values
}
Function Get-Info
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)] 
        $ComputerName,
		[Parameter(position=1,Mandatory = $false)]
		$Path = "$env:userprofile\Documents",
		[Parameter(Mandatory=$false)]
		[switch]
		$Export
	)
	BEGIN
	{
		$date = Get-Date
	}	
	PROCESS
	{
		$ping = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet
		If($ping)
		{ 
		$users = Get-ActiveUsers $ComputerName
		$bios = Get-BiosInfo $ComputerName
		$disk = Get-DiskDrive $ComputerName
		$ipconf = Get-IPConfig $ComputerName
		$java = Get-JavaVer $ComputerName
		$os = Get-OSInfo $ComputerName
		$sid = Get-SID $ComputerName
		$sys = Get-SystemInfo $ComputerName
		#$updt = Get-Updates $ComputerName
		$props = [ordered]@{}
			$props["ComputerName"]=$ComputerName
			$props["Date"]=$Date
			$props["User"]=$users
			$props["SerialNumber"]=$bios.SerialNumber
			$props["SID"]=$sid.SID
			$props["Drive"]=$disk.DeviceID
			$props["SizeGB"]=$disk.SizeGB
			$props["FreeSpaceGB"]=$disk.FreeSpaceGB
			$props["PercentFree"]=$disk.PercentFree
			$props["IPAddress"]=$ipconf.IPAddress
			$props["DNSDomain"]=$ipconf.DNSDomain
			$props["MACAddress"]=$ipconf.MACAddress					
			$props["Subnet"]=$ipconf.IPSubnet[0]
			$props["Gateway"]=$ipconf.DefaultIPGateway
			$props["JavaVerInstalled"]=$java.ProductVersion
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
			$ComputerName | Out-File "C:\test\FailedToReach.txt"
		}
		If ($Export)
		{
			Do
			{
			$i = 1; $i++
			$date = Get-Date -format "MMddhhmmss"
			$prehtml = '<html><head><title>Computer Report</title><style>body {background-color:WhiteSmoke;}h1, h2 {text-align:center;}.info{font:12px arial,sans-serif;color:DarkGreen;height:83%;width:83%;margin: auto;}.info table {border-collapse: collapse; margin:auto; }td, th {  width: 4rem;  height: 2rem;  border: 1px solid #ccc;  text-align: center;}.info h1 {text-align:center;}.info table th, td {color:ForestGreen;}.flag table td {color:red;}</style><body><div class="info">'
			$endhtml = '</div></body></html>'
			$biosprops = $fininfo | Select ComputerName, Date, User, SerialNumber, SID | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Bios Information</h2>' -PostContent '</div>'| Out-String
			$driveprops = $fininfo | Select Drive, SizeGB, FreeSpaceGB, PercentFree  | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Hard Drive Information</h2>' -PostContent '</div>'| Out-String
			$ipprops = $fininfo | Select IPAddress, DNSDomain, MACAddress, Subnet, Gateway | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Ipconfig</h2>' -PostContent '</div>'| Out-String
			$osprops = $fininfo | Select OperatingSystem, Architecture, Description, LastBootUpTime | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>OS Information</h2>' -PostContent '</div>'| Out-String
			$sysprops = $fininfo | Select Domain, Manufacturer, JavaVerInstalled | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>System Information</h2>' -PostContent '</div>'| Out-String
			$innerHTML += $biosprops + $driveprops + $ipprops + $osprops + $sysprops
			}
			until($i -gt $fininfo.count)				
			$prehtml + $innerHtml + $endhtml | Out-File "$Path\Report$date.htm"
		}			
	}
	END
	{		
	}
}

Function Export-HTML
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)] 
        $Object,
		[Parameter(position=1,Mandatory = $false)]
		$Path = "$env:userprofile\Documents"
	)
	BEGIN
	{
		$date = Get-Date -format "MMddhhmmss"
	}
	PROCESS
	{
		$fragment = $Object | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Computer Information</h2>' -PostContent '</div>'| Out-String
		$innerHtml += $fragment
	}	
	END
	{
		$prehtml = '<html><head><title>Computer Report</title><style>body {background-color:WhiteSmoke;}h1, h2 {text-align:center;}.info{font:12px arial,sans-serif;color:DarkGreen;height:83%;width:83%;margin: auto;}.info table {border-collapse: collapse; margin:auto; }td, th {  width: 4rem;  height: 2rem;  border: 1px solid #ccc;  text-align: center;}.info h1 {text-align:center;}.info table th, td {color:ForestGreen;}.flag table td {color:red;}</style><body><div class="info">'
		$endhtml = '</div></body></html>'
		$prehtml + $innerHtml + $endhtml | Out-File "$Path\Report$date.htm"		
	}
}
<#
$box = get-mailbox
$props = $box | Get-Member | where {$_.MemberType -eq 'Property'} | select -ExpandProperty Name

foreach($prop in $props) {
    $value = $box.$prop
    if($value -ne $null -and $value -ne "") {
    Write-Host $prop
}
#>
Function Get-Serials
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName	
	)
	PROCESS
	{
		$bios = Get-WmiObject Win32_Bios -ComputerName $ComputerName | Select @{name="PC";expression={$_.__Server}}, SerialNumber, Description
		[array]$monitor = Get-WMIObject WmiMonitorID -Namespace root\wmi -ComputerName $ComputerName
		$numberofmonitors = ($monitor.active.count) -1
		$i = 0
		Do
		{
			[array]$names += ($monitor[$i].UserFriendlyName -NotMatch 0 | ForEach {[char]$_}) -join ""
			$i++
		}
		until($i -gt $numberofmonitors)
		$x = 0
		Do
		{
			[array]$serials += ($monitor[$x].SerialNumberID -NotMatch 0 | ForEach {[char]$_}) -join ""
			$x++
		}
		until($x -gt $numberofmonitors)
	    $props = [ordered]@{ComputerName=$bios.PC
							SerialNumber=$bios.SerialNumber
							MonitorNames=$names
							MonitorSerials=$serials							
		}
		$serials = $null
		$names = $null
		$fininfo = New-Object –TypeName PSObject –Property $props
		$fininfo
	}	
}
