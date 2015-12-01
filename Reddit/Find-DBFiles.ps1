<# Keepign below for posterity. Look at end of file for actual function. Written for reddit request https://www.reddit.com/r/usefulscripts/comments/3jhyzn/requestpowershell_script_to_search_c_drive_of/
Function Get-DBFiles
{
	<#	
		.SYNOPSIS
			A brief description of the Get-DBFiles function.
		
		.DESCRIPTION
			A detailed description of the Get-DBFiles function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			PS C:\> Get-DBFiles <ComputerName>
			
		.EXAMPLE
			Get-Content computers.txt | Get-DBFiles
		
		.NOTES
			Additional information about the function.
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName,
		[Parameter(Mandatory=$True)]
		[string]$Extension	
	)
	BEGIN
	{
	
	}
	PROCESS 
	{
		$pcpath = "\\$ComputerName\c$"
		$results = Get-ChildItem $pcpath -Recurse | Where {$_.Extension -eq ".$Extension"}
	}
}
Function Get-Shortcuts
{
	<#	
		.SYNOPSIS
			A brief description of the Get-Shortcuts function.
		
		.DESCRIPTION
			A detailed description of the Get-Shortcuts function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			PS C:\> Get-Shortctus <ComputerName>
			
		.EXAMPLE
			Get-Content computers.txt | Get-DBFiles
		
		.NOTES
			Additional information about the function.
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName
	)
		Begin{}
		Process
		{
			$Path = "\\$ComputerName\c$"			
	$Items = Get-ChildItem $Path -Recurse -Include *.lnk -ErrorAction SilentlyContinue
#Above error supression is due to some folders not being accessible. May not be needed if run as Administrator.
ForEach ($Item in $Items) {
   $Shell = New-Object -ComObject WScript.Shell 
   $Properties = @{
        ShortcutName = $Item.Name
		ShortcutPath = $Item.FullName 
        Target = $Shell.CreateShortcut($Item).targetpath 
            }
New-Object PSObject -Property $Properties 
} 
[Runtime.InteropServices.Marshal]::ReleaseComObject($Shell) | Out-Null
		}

}
#Script tying the two together.
Function Get-DBFilesandShortcuts
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName,
		[Parameter(Mandatory=$True)]
		[string]$SavePath
	)
	Process
	{
		$shortcuts = Get-Shortcuts -ComputerName $ComputerName | Where {$_.Target -like "*.mdb" -or $_.Target -like "*.accdb"} | Select @{name="ComputerName";expression={$ComputerName}}, ShortcutPath, ShortcutName, Target
		$dbfiles = Get-DBFiles -ComputerName $ComputerName | Select @{name="ComputerName";expression={$ComputerName}}, Filename,FullName
		$Shortcuts | Export-CSV -Path "$SavePath\shortcuts.csv" -Append -NoTypeInformation
		$dbfiles | Export-CSV -Path "$SavePath\databasefiles.csv" -Append -NoTypeInformation
	}
}
#>
##Scrath Area below...Here lies dragons
Function Get-DBAndShortcuts
{
		[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$ComputerName,
		[Parameter(Mandatory=$True)]
		[string]$SavePath
	)
	Process
	{
		$Propholder = "NA"
		$Path = "\\$ComputerName\c$"
		$FilesToSearch = Get-ChildItem $Path -Recurse -ErrorAction SilentlyContinue
		#Above will take a while to run, as it is creating a directory listing for the target computer.
		Function Get-Shortcuts
	{
		$ShortcutItems = $FilesToSearch | Where {$_.Extension -like "*.lnk"}
	ForEach ($Item in $ShortcutItems) {
  		$Shell = New-Object -ComObject WScript.Shell 
   		$Properties = @{
	   				ComputerName = $ComputerName
        			ShortcutName = $Item.Name
					ShortcutPath = $Item.FullName 
        			Target = $Shell.CreateShortcut($Item.FullName).targetpath 
            		}
		New-Object PSObject -Property $Properties 
		} 
		[Runtime.InteropServices.Marshal]::ReleaseComObject($Shell) | Out-Null
	}
	$DatabaseItems = $FilesToSearch | Where {$_.Extension -like "*.mdb" -or $_.Extension -like "*.accdb"} | Select @{name="ComputerName";expression={$ComputerName}}, Name, Extension, FullName, @{name="Target";expression={"NA"}},  @{name="ShortcutName";expression={"NA"}},  @{name="ShortcutPath";expression={"NA"}}
	$ShortcutItems = Get-Shortcuts -ComputerName $ComputerName | Where {$_.Target -like "*.mdb" -or $_.Target -like "*.accdb"} | Select @{name="ComputerName";expression={$ComputerName}}, @{name="Name";expression={"NA"}}, @{name="FullName";expression={"NA"}}, @{name="Extension";expression={"NA"}}, ShortcutName, ShortcutPath, Target 
	$DatabaseItems | Export-CSV -Path "$SavePath\DatabaseFiles.csv" -Append -NoTypeInformation
	$ShortcutItems | Export-CSV -Path "$SavePath\DatabaseFiles.csv" -Append -NoTypeInformation
	$DatabaseItems
	$ShortcutItems
	}
}