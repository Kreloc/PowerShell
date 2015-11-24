###Helper Functions
Function Get-InstalledSoftware
{
	[cmdletbinding()]            
	param
	(            
 		[parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Mandatory=$true)]            
 		[string[]]$ComputerName            
	)                     
	Begin 
	{            
 		$UninstallRegKeys=@("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall",            
     "SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall")
         
	}            
            
	Process 
	{                   
 		Write-Verbose "Starting RemoteRegistry Service on $ComputerName"            
 		#$resSCServiceStart = & C:\Windows\System32\sc.exe \\$ComputerName start "RemoteRegistry"            
		Foreach($UninstallRegKey in $UninstallRegKeys)
		{            
			Try
			{            
    			$HKLM   = [microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$ComputerName)            
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
	#$resSCServiceStop = & C:\Windows\System32\sc.exe \\$ComputerName stop "RemoteRegistry"                       
	}            
            
end {}
}

Function Uninstall-InstalledSoftware
{
	[cmdletbinding()] 
	param
	(            
 		[parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
 		[string]$ComputerName,
 		[parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
 		[string]$AppGUID
	)            
	try 
	{
  		$returnval = ([WMICLASS]"\\$computerName\ROOT\CIMV2:win32_process").Create("msiexec `/x$AppGUID `/norestart `/qn")
 	}
	catch
	{
  		Write-error "Failed to trigger the uninstallation. Review the error message"
 		 $_
 	}
 	switch ($($returnval.returnvalue)){
  0 { "Uninstallation command triggered successfully" }
  2 { "You don't have sufficient permissions to trigger the command on $ComputerName" }
  3 { "You don't have sufficient permissions to trigger the command on $ComputerName" }
  8 { "An unknown error has occurred" }
  9 { "Path Not Found" }
  9 { "Invalid Parameter"}
 }
}
###End Helper Functions
Function Remove-GFI 
{
	<#	
		.SYNOPSIS
			The Remove-GFI function uninstalls GFI Backup from remote machines.
		
		.DESCRIPTION
			The Remove-GFI function uninstalls GFI Backup from remote machines using the Win32_Process class, the msiexec uninstaller and information from the remote computer's registry. Requires the use of two helper functions
			and the sc.exe utility.
		
		.PARAMETER ComputerName
			The name or ip address of the computer that GFI Backup is to be removed from.
		
		.EXAMPLE
			Remove-GFI <ComputerName>
			
			Removes GFI from the one computer specified.
			
		.EXAMPLE
			Import-CSV .\ComputersWithGFIInstalled.csv | Remove-GFI
		
			Removes GFI Backup from each of the computernames listed in the csv file under the header "ComputerName". Each computer is done one by one.
						
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
		Write-Verbose "Connecting to remote computer's registry. This could take a minute or two."
		$AppGUID = ((Get-InstalledSoftware -ComputerName $ComputerName) | Where {$_.AppName -eq "GFI Backup 2010 Agent"}).AppGUID
		try
		{
			$RemoteRegStatus = (Get-Service -Name RemoteRegistry -ComputerName $ComputerName -ErrorAction Stop).Status
		}
		catch
		{
			$ErrorMessage = $_.Exception.Message
		}
		Write-Verbose "Attempting to remove GFI"
		If($AppGUID)
		{
			Uninstall-InstalledSoftware -ComputerName $ComputerName -AppGUID $AppGUID | Out-Null
			Write-Verbose "GFI was removed, creating custom object properties."
			$props = @{ComputerName=$ComputerName
						Online=$True
						GFIRemoved=$True
						ErrorMessage=$ErrorMessage
			}
		}
		else
		{
			Write-Verbose "GFI was not removed, creating custom object properties."				
							$props = @{ComputerName=$ComputerName
						Online=$True
						GFIRemoved=$False
						ErrorMessage=$ErrorMessage
			}
		}
	Write-Verbose "Creating custom object"
	$GFIRemoved = New-Object -TypeName PSObject -Property $props
	$GFIRemoved	
	}
	End{}
}