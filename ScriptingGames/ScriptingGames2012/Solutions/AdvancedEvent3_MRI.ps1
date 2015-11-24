Function Get-LogInfo($ComputerName)
{
	$pc = gwmi win32_ComputerSystem -ComputerName $ComputerName | Select DNSHostName, Domain, BootupState, UserName
	$os = gwmi win32_OperatingSystem -ComputerName $ComputerName | Select ServicePackMajorVersion, Version, @{name="LastBootUpTime";expression={$_.ConvertToDateTime($_.LastBootUpTime)}}
	$path = Get-WmiObject Win32_LogicalDisk -Filter "DriveType = 4" -ComputerName $ComputerName | select Name, ProviderName
	$printer = Get-WmiObject Win32_printer -Filter "Default = True" -ComputerName $ComputerName | Select Name
	$result = New-Object –TypeName PSObject
	$result | Add-Member -MemberType NoteProperty -Name UserName -Value $($pc.UserName)
	$result | Add-Member -MemberType NoteProperty -Name HostName -Value "$($pc.DNSHostName).$($pc.Domain)"
	$result | Add-Member -MemberType NoteProperty -Name OperatingSystemVersion -Value $($os.Version)
	$result | Add-Member -MemberType NoteProperty -Name OperatingSystemServicePack -Value $($os.ServicePackMajorVersion)
	$result | Add-Member -MemberType NoteProperty -Name Drive -Value $($path)
	$result | Add-Member -MemberType NoteProperty -Name DefaultPrinter -Value $($printer.Name)
	$result | Add-Member -MemberType NoteProperty -Name TypeOfBoot -Value $($pc.BootUpState)
	$result | Add-Member -MemberType NoteProperty -Name LastReboot -Value $($os.LastBootUpTime)
	$result
	If(!(Test-Path "C:\Scripts\logonlog\"))
	{
		New-Item -Path "C:\Scripts\logonlog\" -ItemType Directory | Out-Null
	} 
	$result | Out-File "C:\Scripts\logonlog\logonstatus.txt" -Append -NoClobber
}