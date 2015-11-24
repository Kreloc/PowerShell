Function Get-LocalSoftware
{
$RegUninstallPaths = @( 
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall', 
    'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall') 

    foreach ($Path in $RegUninstallPaths) { 
    if (Test-Path $Path) { 
        $SoftwareInstalled = Get-ChildItem $Path | Where {($_.GetValueNames()).count -ne 0}
        ForEach($SoftwareInstall in $SoftwareInstalled)
        {
            $AppGuid = $SoftwareInstall.Name
            $AppDisplayName = $SoftwareInstall.GetValue('DisplayName')
            $AppVersion = $SoftwareInstall.GetValue('DisplayVersion')
            $AppUninstall = $SoftwareInstall.GetValue('UninstallString')
            $AppInstallDate = $SoftwareInstall.GetValue('InstallDate')
            $AppPublisher = $SoftwareInstall.GetValue('Publisher')
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
}