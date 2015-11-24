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
			#Below is a work in progress to get any columnset to properly expand out.
			#Can't get the dot notation expansion to work when the value is passed in this manner.
			#Have hit a wall, this will expand only the elements that are right off of the Computer property of the XML object returned by the GetMachineData method of the LANDesk Web Service
			$Columns = Get-LANDeskColumnSetColumns -Name $ColumnSetName
			$finprops = @{}
			$count = $Columns.count
			$i = 0
			Do
			{
				$name = (((($columns[$i] -replace '"',"") -replace " ","") -replace "^Computer.",'') -replace '\.',"")
				$value =  ((($columns[$i] -replace '"',"") -replace " ","") -replace "^Computer","") -replace '^\.',''
				If(($value -split "\.").count -gt 0)
				{
					$finvalue = $($MachineData.$value)
				}
				else
				{
					$finvalue = $MachineData.$value	
				}
				
				$finprops[$name] = $finvalue
				$i++				
			}
			until($i -eq $count)
			#$finprops
			New-Object -TypeName PSObject -Property $finprops
			#$PropertyValues = (($columns.Columns -replace '"',"") -replace " ","") -replace "^Computer",'$MachineData'
			#$PropertyNames = ((($columns.Columns -replace '"',"") -replace " ","") -replace "^Computer.",'') -replace '\.',""
			
		}
	}
}

####Scratch Area of attempts to expand out every column
<#
$splitvalues = $value -split "\."
$SplitCount = $splitvalues.count
$n=0
Do
{
	New-Variable "LDMachineDatavalue$n" $splitvalues[$n]
	$n++
}
Until($n -eq $splitcount)
$CreatedVariables = Get-Variable -Name "LDMachineDataValue*" | Select -ExpandProperty Value
Do
{
	If I can add each of the variables onto $MachineData, it expands out correctly.
	$MachineData.$LDMachineDatavalue1.$LDMachineDataValue2.$LD
}
Until($n -eq $splitcount)

#TO DO: Add $value$n onto $MachineData until $n = $splitcount
#$MachineData.$value$n
#>


