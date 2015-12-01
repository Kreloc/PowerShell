###Set-ADCompDescription Local Login Script####
#Getting information about localhost.
<#
$SerialNum = (gwmi win32_bios).SerialNumber
$user = $Env:Username
$Model = (gwmi win32_ComputerSystem).Model
$descr = $User + " - " + $Model + " - " + $SerialNum
$strName = $env:computername
###Below searches AD for computer's Distinguished Name.
$strFilter = "(&(objectCategory=Computer)(Name=$strName))"

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.Filter = $strFilter

$objPath = $objSearcher.FindOne()
$objComputer = $objPath.GetDirectoryEntry()
$DN = $objComputer | Select -ExpandProperty distinguishedName
$ComputerDN = "LDAP://$DN"
$computer = [adsi]("$ComputerDN")
$computer.put("Description","$descr")
$computer.SetInfo()
#>
#If accounts on computers won't have access, you can use your credentials for the below object. Add ,$username, $password after $ComputerDN where those variables are your credentials.
Function Set-ADCompDescription
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
		$Descrpt = (Get-OSinfo $ComputerName).Description
		$SerialNum = (Get-BiosInfo $ComputerName).SerialNumber
		$user = Get-ActiveUsers $ComputerName
		$comp = Get-ADComputer $ComputerName -Properties Description
		$comp.Description = "$Descrpt, $SerialNum, $user"
		Set-ADComputer -Instance $comp
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
		[string]$ComputerName	 # It takes an array of strings as input
	)
	PROCESS 
	{
		Get-WmiObject Win32_Bios -ComputerName $ComputerName | Select @{name="PC";expression={$_.__Server}}, SerialNumber, Description
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
			$failhash["Test"] = $false
			$failhash
		}
		else
		{
			$props = @{ComputerName=$ComputerName
						Test=$True
						}
			$Computers = New-Object –TypeName PSObject –Property $props
			$Computers
		}			
	}
}
