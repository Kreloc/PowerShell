##Below function requires Admin shares to be available.
function Get-JavaVer
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][String] 
        $ComputerName
	)	
	PROCESS
	{
		$java = gci "\\$ComputerName\c$\Program Files (x86)\Java\jre7\bin\java.exe"
		$java.VersionInfo
	}
}
Function Get-ActiveUsers
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName
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
Function Get-SID
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName	
	)
	PROCESS
	{
		Get-Service RemoteRegistry -ComputerName $ComputerName | Start-Service
		###This function is for my work environment.
		##Get SID Number from Registry
		$ServerReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey("LocalMachine",$ComputerName)
		$sid = ($ServerReg.OpenSubKey("SOFTWARE\Wow6432Node\Intel\LANDesk\Inventory\Custom Fields\")).GetValue("SID")
		$props = @{ComputerName=$ComputerName
					SID=$sid}
		$CompSID = New-Object –TypeName PSObject –Property $props
		$CompSID
		Get-Service RemoteRegistry -ComputerName $ComputerName | Stop-Service	
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
		[string]$ComputerName	
	)
	PROCESS 
	{
			Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName | Select Caption, Version, Description, OSArchitecture, FreePhysicalMemory , @{name="PC";expression={$_.__Server}}
	}
}
function Get-Updates
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][String] 
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
	.EXAMPLE
	Get-IPConfig FAMILY, ARMRI
	.PARAMETER ComputerName
	The computer name to query
#>
	[CmdletBinding()] #states that this function should act just like a cmdlet
	param(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName	
	)
	PROCESS #Any lines coming down the pipeline, I process here, and here is the code we’re going to run against those.
	{
		Get-WmiObject Win32_NetworkAdapterConfiguration | Where {$_.IPEnabled -eq $True} | select DNSDomain, MACAddress, IPAddress, IPSubnet, DefaultIPGateway
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
		[string]$ComputerName,
		[string]$drive = $env:SystemDrive #Defaults this variable to the system drive.
	)
	PROCESS 
	{
		Get-WmiObject Win32_LogicalDisk -computer $ComputerName -Filter "DeviceID = '$drive'" | Select @{name="PC";expression={$_.__Server}}, DeviceID, @{name="SizeGB";expression={([Math]::Round( ($_.Size / 1GB) , 2 ) )}}, @{name="FreeSpaceGB";expression={([Math]::Round( ($_.FreeSpace / 1GB) , 2 ) )}}, @{name="PercentFree";expression={([Math]::Round(($_.FreeSpace / $_.Size)*100))}}
	} #End of PROCESS
} #End of function
Function Get-BiosInfo 
{
<#
.SYNOPSIS
	This function returns the serial number and description of the BIOS on the computer(s) specified.
.DESCRIPTION
	This function returns the serial number and description of the BIOS on the computer(s) specified. Leverages Win32_BIOS. This function is used for error checking when Get-ComputerInfo is run. For more information see here,
	http://msdn.microsoft.com/en-us/library/aa394077(v=vs.85).aspx
.EXAMPLE
	Get-BiosInfo Family
.EXAMPLE
	Get-BiosInfo Family, 
.PARAMETERS -ComputerName
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True, # It is mandatory (required).
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)] # It takes input from the pipeline.
		[string]$ComputerName	 # It takes an array of strings as input
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
		[string]$ComputerName	
	)
	PROCESS 
	{
		Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName | Select Name, Domain, Model, Manufacturer
	}
}
Function Test-Computer
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][String] 
        $ComputerName
	)
	BEGIN
	{
		$Date = Get-Date
	}
	PROCESS
	{
		$test = test-connection -ComputerName $ComputerName -Count 1 -Quiet
		If ($test -eq $false)
		{
			$failhash = @{}
			$failhash["PC"] = $ComputerName
			$failhash["Date"] = $Date
			$failhash
		}
		else
		{
			$props = @{ComputerName=$ComputerName}
			$Computers = New-Object –TypeName PSObject –Property $props
			$Computers
		}			
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
        $true,ValueFromPipelinebyPropertyName=$true)][String] 
        $ComputerName
	)
	BEGIN
	{
		$date = Get-Date
	}	
	PROCESS
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
		$props = [ordered]@{ComputerName=$ComputerName
					Date=$Date
					User=$users
					SerialNumber=$bios.SerialNumber
					SID=$sid.SID
					Drive=$disk.DeviceID
					SizeGB=$disk.SizeGB
					FreeSpaceGB=$disk.FreeSpaceGB
					PercentFree=$disk.PercentFree
					IPAddress=$ipconf.IPAddress[0]
					DNSDomain=$ipconf.DNSDomain
					MACAddress=$ipconf.MACAddress					
					Subnet=$ipconf.IPSubnet[0]
					Gateway=$ipconf.DefaultIPGateway[0]
					JavaVerInstalled=$java.ProductVersion
					OperatingSystem=$os.Caption
					Architecture=$os.OSArchitecture
					Description=$os.Description
					Domain=$sys.Domain
					ComputerModel=$sys.Model
					Manufacturer=$sys.Manufacturer
					}
		$fininfo = New-Object –TypeName PSObject –Property $props
		$fininfo	
	}
}
