<#
.SYNOPSIS
This function sets a folder icon on specified folder.
.DESCRIPTION
This function sets a folder icon on specified folder. Needs the path to the icon file to be used and the path to the folder the icon is to be applied to. This function will create two files in the destination path, both set as Hidden files. DESKTOP.INI and FOLDER.ICO
.EXAMPLE
Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Users\Mark"
Changes the default folder icon to the custom one I donwloaded from Google Images.
.EXAMPLE
Set-FolderIcon -Icon "C:\Users\Mark\Downloads\wii_folder.ico" -Path "\\FAMILY\Media\Wii"
Changes the default folder icon to custom one for a UNC Path.
.EXAMPLE
Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Test" -Recurse
Changes the default folder icon to custom one for all folders in specified folder and that folder itself.
.NOTES 
Created by Mark Ince on May 4th, 2014. Contact me at mrince@outlook.com if you have any questions.
#>
function Set-FolderIcon
{
	[CmdletBinding()]
	param
	(	
		[Parameter(Mandatory=$True,
		Position=0)]
		[string[]]$Icon,
		[Parameter(Mandatory=$True,
		Position=1)]
		[string]$Path,
		[Parameter(Mandatory=$False)]
		[switch]
		$Recurse	
	)
	BEGIN
	{
		$originallocale = $PWD
		#Creating content of the DESKTOP.INI file.
		$ini = '[.ShellClassInfo]
				IconFile=folder.ico
				IconIndex=0
				ConfirmFileOp=0'
		Set-Location $Path
		Set-Location ..	
		Get-ChildItem | Where-Object {$_.FullName -eq "$Path"} | ForEach {$_.Attributes = 'Directory, System'}
	}	
	PROCESS
	{
		$ini | Out-File $Path\DESKTOP.INI
		If ($Recurse -eq $True)
		{
			Copy-Item -Path $Icon -Destination $Path\FOLDER.ICO	
			$recursepath = Get-ChildItem $Path -r | Where-Object {$_.Attributes -match "Directory"}
			ForEach ($folder in $recursepath)
			{
				Set-FolderIcon -Icon $Icon -Path $folder.FullName
			}
		
		}
		else
		{
			Copy-Item -Path $Icon -Destination $Path\FOLDER.ICO
		}	
	}	
	END
	{
		$inifile = Get-Item $Path\DESKTOP.INI
		$inifile.Attributes = 'Hidden'
		$icofile = Get-Item $Path\FOLDER.ICO
		$icofile.Attributes = 'Hidden'
		Set-Location $originallocale		
	}
}
<#

#>
function Remove-SetIcon
{
	[CmdletBinding()]
	param
	(	
		[Parameter(Mandatory=$True,
		Position=0)]
		[string]$Path
	)
	BEGIN
	{
		$originallocale = $PWD
		$iconfiles = Get-ChildItem $Path -Recurse -Force | Where-Object {$_.Name -like "FOLDER.ICO"}
		$iconfiles = $iconfiles.FullName
		$inifiles = Get-ChildItem $Path -Recurse -Force | where-Object {$_.Name -like "DESKTOP.INI"}
		$inifiles = $inifiles.FullName
	}
	PROCESS
	{
		Remove-Item $iconfiles -Force
		Remove-Item $inifiles -Force
		Set-Location $Path
		Set-Location ..
		Get-ChildItem | Where-Object {$_.FullName -eq "$Path"} | ForEach {$_.Attributes = 'Directory'}	
	}
	END
	{
		Set-Location $originallocale
	}
}