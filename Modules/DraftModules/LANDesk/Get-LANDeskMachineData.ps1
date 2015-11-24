Function Get-LANDeskMachineData
{
	<#	
		.SYNOPSIS
			Retrieves more detailed information about the computer specified by the GUID parameter from the LANDeskWebService object.
		
		.DESCRIPTION
			Retrieves more detailed information about the computer specified by the GUID parameter.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.

		.EXAMPLE
			Get-LANDeskMachineData <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-Content computers.txt | Get-LANDeskMachineData
		
			Explanation of this example.
				
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$GUID,
        [Parameter(Mandatory=$False,ValueFromPipelinebyPropertyName=$true)]
		[string]$ColumnSetName = "Mark"
	)
    Begin
    {
		If(!($LANDeskWebService))
		{
			Write-Error "Please run Connect-LANDeskServer. This function cannot be performed without an active connection to the LANDesk Web Service."
			Break
		}	 
    }
    Process
	{
    	$MachineData = $LANDeskWebService.GetMachineDataEX("$Guid","$ColumnSetName")
		$MachineData = $MachineData.Computer
		#Below is unique data for my columnSetName named Mark
		If($ColumnSetName -like "Mark")
		{
			$SID = $MachineData.CustomData.Registry.LANDeskCustomFields.SID
			$SerialNumber = $MachineData.BIOS.SerialNumber
			#$InstalledSoftware = ($MachineData.Software.AddorRemovePrograms.Program | Select -ExpandProperty Name) -join ";"
			$ComputerName = $MachineData.DisplayName
			$MachineData | Select @{name="ComputerName";expression={$ComputerName}}, LastUpdateScanDate, LastSoftwareScanDate, @{name="SID";expression={$SID}}, @{name="SerialNumber";expression={$SerialNumber}},
			Description, PrimaryOwner#, @{name="InstalledSoftware";expression={$InstalledSoftware}} 
		}
		else
		{
			$MachineData | Select DisplayName, Type, OS
		}
	}
}