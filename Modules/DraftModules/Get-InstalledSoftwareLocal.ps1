Function Get-LocalInstalledSoftware
{
$HKLM   = [microsoft.win32.registrykey]::OpenBaseKey('LocalMachine',"Default")
		$UninstallRegKeys=@("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall",            
     "SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall")
	 Foreach($UninstallRegKey in $UninstallRegKeys)
		{            
			Try
			{                        
    			$UninstallRef  = $HKLM.OpenSubKey($UninstallRegKey)            
    			$Applications = $UninstallRef.GetSubKeyNames()            
   			} 
			Catch
			{            
    			Write-Verbose "Failed to read $UninstallRegKey"         
    		Continue            
   			}            
			Write-Verbose "Creating custom output object"         
			Foreach ($App in $Applications) 
			{            
				$AppRegistryKey = $UninstallRegKey + "\\" + $App            
				$AppDetails = $HKLM.OpenSubKey($AppRegistryKey)            
				$AppGUID = $App            
   				$AppDisplayName = $($AppDetails.GetValue("DisplayName"))            
   				$AppVersion = $($AppDetails.GetValue("DisplayVersion"))            
   				$AppPublisher = $($AppDetails.GetValue("Publisher"))            
   				$AppInstalledDate = $($AppDetails.GetValue("InstallDate"))            
   				$AppUninstall = $($AppDetails.GetValue("UninstallString"))            
				If($UninstallRegKey -match "Wow6432Node") 
				{            
    				$Softwarearchitecture = "x86"            
				}
				Else
				{            
					$Softwarearchitecture = "x64"            
   				}            
				If(!$AppDisplayName) { Continue }            
   			$OutputObj = New-Object -TypeName PSobject             
   			$OutputObj | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerName.ToUpper()            
   			$OutputObj | Add-Member -MemberType NoteProperty -Name AppName -Value $AppDisplayName            
   			$OutputObj | Add-Member -MemberType NoteProperty -Name AppVersion -Value $AppVersion            
   			$OutputObj | Add-Member -MemberType NoteProperty -Name AppVendor -Value $AppPublisher            
   			$OutputObj | Add-Member -MemberType NoteProperty -Name InstalledDate -Value $AppInstalledDate            
   			$OutputObj | Add-Member -MemberType NoteProperty -Name UninstallKey -Value $AppUninstall            
   			$OutputObj | Add-Member -MemberType NoteProperty -Name AppGUID -Value $AppGUID            
   			$OutputObj | Add-Member -MemberType NoteProperty -Name SoftwareArchitecture -Value $Softwarearchitecture            
   			$OutputObj            
			}
		}
}