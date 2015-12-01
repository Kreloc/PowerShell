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
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)][Alias('Name')]
		$ComputerName = $env:computername,
		$drive = $env:SystemDrive
	)
	PROCESS 
	{
		Get-WmiObject Win32_LogicalDisk -ComputerName $ComputerName -Filter "DeviceID = '$drive'" | Select @{name="PC";expression={$_.__Server}}, DeviceID, @{name="SizeGB";expression={([Math]::Round( ($_.Size / 1GB) , 2 ) )}}, @{name="FreeSpaceGB";expression={([Math]::Round( ($_.FreeSpace / 1GB) , 2 ) )}}, @{name="PercentFree";expression={([Math]::Round(($_.FreeSpace / $_.Size)*100))}}
	}
}