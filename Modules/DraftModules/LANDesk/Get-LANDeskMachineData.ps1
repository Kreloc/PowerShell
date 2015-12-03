Function Get-LANDeskMachineData
{
	<#	
		.SYNOPSIS
			Retrieves more detailed information about the computer specified by the GUID parameter from the LANDeskWebService object.
		
		.DESCRIPTION
			Retrieves more detailed information about the computer specified by the GUID parameter.
		
		.PARAMETER GUID
			The GUID of the LANDeskComputer to obtain Machine Data for from the LANDesk WebService.

		.EXAMPLE
			$LANDeskComputers | Where {$_.ComputerName -eq "THATPC"} | Get-LANDeskMachineData -ColumnSetName "Mark"
			
			Returns machine information on the the computer named THATPC. Will return all of the information viewable from the Columns set
			Mark.
			
		.EXAMPLE
			$results = Get-LANDeskComputer -Filter {$_.ComputerName -like "la-ldp*"} | Get-LANDeskMachineData -ColumnSetName "Other"
		
			Pipes the GUIDs of all the computers with a name beginning with la-ldp into the function and
			Stores the results of the GetMachineDataEX method call using the column setnamed Other into the variable named $results.
				
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
			$MachineData
		}
	}
}