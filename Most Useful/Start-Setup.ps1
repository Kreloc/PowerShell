$count = [int](Get-Content C:\SystemTools\count.txt)
$log = "C:\SystemTools\setuplog.txt"
###Set up script for LAA computer installs.
##http://www.codeproject.com/Articles/223002/Reboot-and-Resume-PowerShell-Script
##http://en.community.dell.com/techcenter/powergui/f/4833/t/19572143
##Steps on automating restart process.
If($count -eq '-1')
{
Function Start-Stage1
{
	[CmdletBinding()]
	param 
	(
 		[parameter(ValueFromPipeline=$true,
    	ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
 		[string]$SID,
		[parameter(ValueFromPipeline=$true,
    	ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
 		[string]$ComputerName,
 		[parameter(ValueFromPipeline=$true,
    	ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
 		[string]$Description		 
	)
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "StartupScript" -Value "C:\SystemTools\Start-Setupscript.bat"
	Function Set-SecureAutoLogon
{
[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [string]
    $Username,
 
    [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [System.Security.SecureString]
    $Password,
     
    [string]
    $Domain,
     
    [Int]
    $AutoLogonCount,
     
    [switch]
    $RemoveLegalPrompt,
     
    [System.IO.FileInfo]
    $BackupFile
)
 
begin {
     
    [string] $WinlogonPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
    [string] $WinlogonBannerPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
 
    [string] $Enable = 1
    [string] $Disable = 0
     
    #region C# Code to P-invoke LSA LsaStorePrivateData function.
    Add-Type @"
        using System;
        using System.Collections.Generic;
        using System.Text;
        using System.Runtime.InteropServices;
 
        namespace ComputerSystem
        {
            public class LSAutil
            {
                [StructLayout(LayoutKind.Sequential)]
                private struct LSA_UNICODE_STRING
                {
                    public UInt16 Length;
                    public UInt16 MaximumLength;
                    public IntPtr Buffer;
                }
 
                [StructLayout(LayoutKind.Sequential)]
                private struct LSA_OBJECT_ATTRIBUTES
                {
                    public int Length;
                    public IntPtr RootDirectory;
                    public LSA_UNICODE_STRING ObjectName;
                    public uint Attributes;
                    public IntPtr SecurityDescriptor;
                    public IntPtr SecurityQualityOfService;
                }
 
                private enum LSA_AccessPolicy : long
                {
                    POLICY_VIEW_LOCAL_INFORMATION = 0x00000001L,
                    POLICY_VIEW_AUDIT_INFORMATION = 0x00000002L,
                    POLICY_GET_PRIVATE_INFORMATION = 0x00000004L,
                    POLICY_TRUST_ADMIN = 0x00000008L,
                    POLICY_CREATE_ACCOUNT = 0x00000010L,
                    POLICY_CREATE_SECRET = 0x00000020L,
                    POLICY_CREATE_PRIVILEGE = 0x00000040L,
                    POLICY_SET_DEFAULT_QUOTA_LIMITS = 0x00000080L,
                    POLICY_SET_AUDIT_REQUIREMENTS = 0x00000100L,
                    POLICY_AUDIT_LOG_ADMIN = 0x00000200L,
                    POLICY_SERVER_ADMIN = 0x00000400L,
                    POLICY_LOOKUP_NAMES = 0x00000800L,
                    POLICY_NOTIFICATION = 0x00001000L
                }
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaRetrievePrivateData(
                            IntPtr PolicyHandle,
                            ref LSA_UNICODE_STRING KeyName,
                            out IntPtr PrivateData
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaStorePrivateData(
                        IntPtr policyHandle,
                        ref LSA_UNICODE_STRING KeyName,
                        ref LSA_UNICODE_STRING PrivateData
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaOpenPolicy(
                    ref LSA_UNICODE_STRING SystemName,
                    ref LSA_OBJECT_ATTRIBUTES ObjectAttributes,
                    uint DesiredAccess,
                    out IntPtr PolicyHandle
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaNtStatusToWinError(
                    uint status
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaClose(
                    IntPtr policyHandle
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaFreeMemory(
                    IntPtr buffer
                );
 
                private LSA_OBJECT_ATTRIBUTES objectAttributes;
                private LSA_UNICODE_STRING localsystem;
                private LSA_UNICODE_STRING secretName;
 
                public LSAutil(string key)
                {
                    if (key.Length == 0)
                    {
                        throw new Exception("Key lenght zero");
                    }
 
                    objectAttributes = new LSA_OBJECT_ATTRIBUTES();
                    objectAttributes.Length = 0;
                    objectAttributes.RootDirectory = IntPtr.Zero;
                    objectAttributes.Attributes = 0;
                    objectAttributes.SecurityDescriptor = IntPtr.Zero;
                    objectAttributes.SecurityQualityOfService = IntPtr.Zero;
 
                    localsystem = new LSA_UNICODE_STRING();
                    localsystem.Buffer = IntPtr.Zero;
                    localsystem.Length = 0;
                    localsystem.MaximumLength = 0;
 
                    secretName = new LSA_UNICODE_STRING();
                    secretName.Buffer = Marshal.StringToHGlobalUni(key);
                    secretName.Length = (UInt16)(key.Length * UnicodeEncoding.CharSize);
                    secretName.MaximumLength = (UInt16)((key.Length + 1) * UnicodeEncoding.CharSize);
                }
 
                private IntPtr GetLsaPolicy(LSA_AccessPolicy access)
                {
                    IntPtr LsaPolicyHandle;
 
                    uint ntsResult = LsaOpenPolicy(ref this.localsystem, ref this.objectAttributes, (uint)access, out LsaPolicyHandle);
 
                    uint winErrorCode = LsaNtStatusToWinError(ntsResult);
                    if (winErrorCode != 0)
                    {
                        throw new Exception("LsaOpenPolicy failed: " + winErrorCode);
                    }
 
                    return LsaPolicyHandle;
                }
 
                private static void ReleaseLsaPolicy(IntPtr LsaPolicyHandle)
                {
                    uint ntsResult = LsaClose(LsaPolicyHandle);
                    uint winErrorCode = LsaNtStatusToWinError(ntsResult);
                    if (winErrorCode != 0)
                    {
                        throw new Exception("LsaClose failed: " + winErrorCode);
                    }
                }
 
                public void SetSecret(string value)
                {
                    LSA_UNICODE_STRING lusSecretData = new LSA_UNICODE_STRING();
 
                    if (value.Length > 0)
                    {
                        //Create data and key
                        lusSecretData.Buffer = Marshal.StringToHGlobalUni(value);
                        lusSecretData.Length = (UInt16)(value.Length * UnicodeEncoding.CharSize);
                        lusSecretData.MaximumLength = (UInt16)((value.Length + 1) * UnicodeEncoding.CharSize);
                    }
                    else
                    {
                        //Delete data and key
                        lusSecretData.Buffer = IntPtr.Zero;
                        lusSecretData.Length = 0;
                        lusSecretData.MaximumLength = 0;
                    }
 
                    IntPtr LsaPolicyHandle = GetLsaPolicy(LSA_AccessPolicy.POLICY_CREATE_SECRET);
                    uint result = LsaStorePrivateData(LsaPolicyHandle, ref secretName, ref lusSecretData);
                    ReleaseLsaPolicy(LsaPolicyHandle);
 
                    uint winErrorCode = LsaNtStatusToWinError(result);
                    if (winErrorCode != 0)
                    {
                        throw new Exception("StorePrivateData failed: " + winErrorCode);
                    }
                }
            }
        }
"@
    #endregion
}
 
process {
 
    try {
        $ErrorActionPreference = "Stop"
         
        $decryptedPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        )
 
        if ($BackupFile) {
                # Initialize the hash table with a string comparer to allow case sensitive keys.
                # This allows differentiation between the winlogon and system policy logon banner strings.
            $OrigionalSettings = New-Object System.Collections.Hashtable ([system.stringcomparer]::CurrentCulture)
             
            $OrigionalSettings.AutoAdminLogon = (Get-ItemProperty $WinlogonPath ).AutoAdminLogon
            $OrigionalSettings.ForceAutoLogon = (Get-ItemProperty $WinlogonPath).ForceAutoLogon
            $OrigionalSettings.DefaultUserName = (Get-ItemProperty $WinlogonPath).DefaultUserName
            $OrigionalSettings.DefaultDomainName = (Get-ItemProperty $WinlogonPath).DefaultDomainName
            $OrigionalSettings.DefaultPassword = (Get-ItemProperty $WinlogonPath).DefaultPassword
            $OrigionalSettings.AutoLogonCount = (Get-ItemProperty $WinlogonPath).AutoLogonCount
             
                # The winlogon logon banner settings.
            $OrigionalSettings.LegalNoticeCaption = (Get-ItemProperty $WinlogonPath).LegalNoticeCaption
            $OrigionalSettings.LegalNoticeText = (Get-ItemProperty $WinlogonPath).LegalNoticeText
             
                # The system policy logon banner settings.
            $OrigionalSettings.legalnoticecaption = (Get-ItemProperty $WinlogonBannerPolicyPath).legalnoticecaption
            $OrigionalSettings.legalnoticetext = (Get-ItemProperty $WinlogonBannerPolicyPath).legalnoticetext
             
            $OrigionalSettings | Export-Clixml -Depth 10 -Path $BackupFile
        }
         
            # Store the password securely.
        $lsaUtil = New-Object ComputerSystem.LSAutil -ArgumentList "DefaultPassword"
        $lsaUtil.SetSecret($decryptedPass)
 
            # Store the autologon registry settings.
        Set-ItemProperty -Path $WinlogonPath -Name AutoAdminLogon -Value $Enable -Force
 
        Set-ItemProperty -Path $WinlogonPath -Name DefaultUserName -Value $Username -Force
        Set-ItemProperty -Path $WinlogonPath -Name DefaultDomainName -Value $Domain -Force
 
        if ($AutoLogonCount) {
            Set-ItemProperty -Path $WinlogonPath -Name AutoLogonCount -Value $AutoLogonCount -Force
        } else {
            Remove-ItemProperty -Path $WinlogonPath -Name AutoLogonCount -ErrorAction SilentlyContinue
        }
 
        if ($RemoveLegalPrompt) {
            Set-ItemProperty -Path $WinlogonPath -Name LegalNoticeCaption -Value $null -Force
            Set-ItemProperty -Path $WinlogonPath -Name LegalNoticeText -Value $null -Force
             
            Set-ItemProperty -Path $WinlogonBannerPolicyPath -Name legalnoticecaption -Value $null -Force
            Set-ItemProperty -Path $WinlogonBannerPolicyPath -Name legalnoticetext -Value $null -Force
        }
    } catch {
        throw 'Failed to set auto logon. The error was: "{0}".' -f $_
    }
 
}
 
<#
    .SYNOPSIS
        Enables auto logon using the specified username and password.
 
    .PARAMETER  Username
        The username of the user to automatically logon as.
 
    .PARAMETER  Password
        The password for the user to automatically logon as.
         
    .PARAMETER  Domain
        The domain of the user to automatically logon as.
         
    .PARAMETER  AutoLogonCount
        The number of logons that auto logon will be enabled.
         
    .PARAMETER  RemoveLegalPrompt
        Removes the system banner to ensure interventionless logon.
         
    .PARAMETER  BackupFile
        If specified the existing settings such as the system banner text will be backed up to the specified file.
 
    .EXAMPLE
        PS C:\> Set-SecureAutoLogon `
                -Username $env:USERNAME `
                -Password (Read-Host -AsSecureString) `
                -AutoLogonCount 2 `
                -RemoveLegalPrompt `
                -BackupFile "C:\WinlogonBackup.xml"
 
    .INPUTS
        None.
 
    .OUTPUTS
        None.
 
    .NOTES
        Revision History:
            2011-04-19 : Andy Arismendi - Created.
            2011-09-29 : Andy Arismendi - Changed to use LSA secrets to store password securely.
 
    .LINK
        http://support.microsoft.com/kb/324737
         
    .LINK
        http://msdn.microsoft.com/en-us/library/aa378750
	#>
	}
	Set-SecureAutoLogon -Username "Administrator"
	###Name the PC using proper convention. Populate description field.
	###Stage I###
	###Remove TCP/IPv6.
	# Disable IPv6
	$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"
	New-ItemProperty -Path $regPath -Name "DisabledComponents" -Value "0xFFFFFFFF" -PropertyType "DWORD" | Out-Null
	###DNS suffix applied.
	$nic = gwmi win32_networkadapterconfiguration -Filter "IPEnabled = True"
	$nic.SetDynamicDNSRegistration($True,$True)
	###Verify McAfee is installed.
	If(Test-Path "C:\Program Files (x86)\McAfee"){"McAfee is installed." >> $log}
	else{"McAfee is not installed. Please fix!" >> $log}
	###Have not come across a system without this installed. Is this necessary?
	###Delete the ISUser account.
	Function Remove-LocalUserAccount 
	{
		[CmdletBinding()]
		param 
		(
 			[parameter(ValueFromPipeline=$true,
    		ValueFromPipelineByPropertyName=$true)]
 			[string[]]$ComputerName=$env:computername,
 			[parameter(Mandatory=$true)]
 			[string[]]$UserName
		)
		foreach ($comp in $ComputerName)
		{
    		[ADSI]$server="WinNT://$comp"
    		foreach ($User in $UserName)
			{
    			$server.delete("user",$user)
	   		}
		}
	}
	Remove-LocalUserAccount -UserName "isuser"
	###Update Flash
	Function Download-File
{
<# 
.SYNOPSIS
    Downloads a file showing the progress of the download
.DESCRIPTION
    This Script will download a file locally while showing the progress of the download 
.EXAMPLE
    .\Download-File.ps1 'http:\\someurl.com\somefile.zip'
.EXAMPLE
    .\Download-File.ps1 'http:\\someurl.com\somefile.zip' 'C:\Temp\somefile.zip'
.PARAMETER url
    url to be downloaded
.PARAMETER localFile
    the local filename where the download should be placed
.NOTES
    FileName     : Download-File.ps1
    Author       : CrazyDave
    LastModified : 24 Mar 2015 4:59 PM
#Requires -Version 2.0 
#>
param(
    [Parameter(Mandatory=$true)]
    [String] $url,
    [Parameter(Mandatory=$false)]
    [String] $localFile = (Join-Path $pwd.Path $url.SubString($url.LastIndexOf('/'))) 
)
    begin 
    {
	    $client = New-Object System.Net.WebClient
        $Global:downloadComplete = $false
        $eventDataComplete = Register-ObjectEvent $client DownloadFileCompleted -SourceIdentifier WebClient.DownloadFileComplete -Action {$Global:downloadComplete = $true}
        $eventDataProgress = Register-ObjectEvent $client DownloadProgressChanged -SourceIdentifier WebClient.DownloadProgressChanged -Action {$Global:DPCEventArgs = $EventArgs} 
    }
    process 
    {
        Write-Progress -Activity 'Downloading file' -Status $url
        $client.DownloadFileAsync($url, $localFile) 
        while (!($Global:downloadComplete)) 
        {                
            $pc = $Global:DPCEventArgs.ProgressPercentage
            if ($pc -ne $null) 
            {
                Write-Progress -Activity 'Downloading file' -Status $url -PercentComplete $pc
            }
        }
            Write-Progress -Activity 'Downloading file' -Status $url -Complete
        }
        end
        {
            Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
            Unregister-Event -SourceIdentifier WebClient.DownloadFileComplete
            $client.Dispose()
            $Global:downloadComplete = $null
            $Global:DPCEventArgs = $null
            Remove-Variable client
            Remove-Variable eventDataComplete
            Remove-Variable eventDataProgress
        }
    }
	New-Item -ItemType Directory -Path C:\SystemTools\Installers\
	Download-File -url "http://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player_ax.exe" -path "C:\SystemTools\Installers\full_flash.exe"
	Download-File -url "ftp://ftp.adobe.com/pub/adobe/reader/win/11.x/11.0.10/en_US/AdbeRdr11010_en_US.exe" -path "C:\SystemTools\Installers\full_reader.exe"
	$total = Get-ChildItem "C:\SystemTools\Installers\" *.exe | measure | Select-Object -expand Count
	$i = 0
	gci $folder *.exe | foreach {
	$i++
	write-progress -activity "Installing Software" -CurrentOperation "Installing $_ .. $i of $total" -Status "Please be patient may take some time..." -PercentComplete (($i / $total) * 100)
    	Start-Process $_.FullName -ArgumentList "/msi EULA_ACCEPT=YES /qn" -wait -passthru 
        }
	<#
	Old way.
	$downloadPlugin = New-Object System.Net.WebClient
	$fromUrl = 'http://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player_ax.exe'
	$saveTo = "C:\systemtools\full_flash.exe"
	$downloadPlugin.DownloadFile($fromUrl, $saveTo)
	& C:\SystemTools\full_flash.exe /msi EULA_ACCEPT=YES /qn
	###Update Reader
	$downloadReader = New-Object System.Net.WebClient
	$fromUrl = 'ftp://ftp.adobe.com/pub/adobe/reader/win/11.x/11.0.10/en_US/AdbeRdr11010_en_US.exe'
	$saveTo = "C:\systemtools\full_reader.exe"
	$downloadReader.DownloadFile($fromUrl, $saveTo)
	&"C:\systemtools\full_reader.exe" /msi EULA_ACCEPT=YES /qn
	#>
	###Add SID registry key.
	New-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Intel\LANDesk\Inventory\Custom Fields" -Name "SID" -Value "$SID"
	Function Rename-Computer
	{
		[CmdletBinding()]
		param
		(
			[Parameter(Mandatory=$True,
			ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
			[string]$ComputerName,
			[Parameter(Mandatory=$True,
			ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
			[string]$Description	
		)
		PROCESS 
		{	
			$os = Get-WMIObject -Class Win32_OperatingSystem
			$os.Description = "$Description"
			$os.put() | Out-Null
			$computer = Get-WmiObject Win32_ComputerSystem
			$computer.rename("$ComputerName") | Out-Null
		}
		END
		{
			$count + 1 > C:\SystemTools\count.txt
			Restart-Computer
		}	
	}
	Rename-Computer -ComputerName $ComputerName -Description $Description
} #End of Stage1 Function
Import-CSV config.csv | Start-Stage1
}#End of If Count -1
##
###Run Windows Updates.
##DO NOT EDIT
Function Get-WUInstall
{
	<#
	.SYNOPSIS
		Download and install updates.

	.DESCRIPTION
		Use Get-WUInstall to get list of available updates, next download and install it. 
		There are two types of filtering update: Pre search criteria, Post search criteria.
		- Pre search works on server side, like example: ( IsInstalled = 0 and IsHidden = 0 and CategoryIds contains '0fa1201d-4330-4fa8-8ae9-b877473b6441' )
		- Post search work on client side after downloading the pre-filtered list of updates, like example $KBArticleID -match $Update.KBArticleIDs
		
		Update occurs in four stages: 1. Search for updates, 2. Choose updates, 3. Download updates, 4. Install updates.
		
	.PARAMETER UpdateType
		Pre search criteria. Finds updates of a specific type, such as 'Driver' and 'Software'. Default value contains all updates.

	.PARAMETER UpdateID
		Pre search criteria. Finds updates of a specific UUID (or sets of UUIDs), such as '12345678-9abc-def0-1234-56789abcdef0'.

	.PARAMETER RevisionNumber
		Pre search criteria. Finds updates of a specific RevisionNumber, such as '100'. This criterion must be combined with the UpdateID param.

	.PARAMETER CategoryIDs
		Pre search criteria. Finds updates that belong to a specified category (or sets of UUIDs), such as '0fa1201d-4330-4fa8-8ae9-b877473b6441'.

	.PARAMETER IsInstalled
		Pre search criteria. Finds updates that are installed on the destination computer.

	.PARAMETER IsHidden
		Pre search criteria. Finds updates that are marked as hidden on the destination computer. Default search criteria is only not hidden upadates.
	
	.PARAMETER WithHidden
		Pre search criteria. Finds updates that are both hidden and not on the destination computer. Overwrite IsHidden param. Default search criteria is only not hidden upadates.
		
	.PARAMETER Criteria
		Pre search criteria. Set own string that specifies the search criteria.

	.PARAMETER ShowSearchCriteria
		Show choosen search criteria. Only works for pre search criteria.
		
	.PARAMETER Category
		Post search criteria. Finds updates that contain a specified category name (or sets of categories name), such as 'Updates', 'Security Updates', 'Critical Updates', etc...
		
	.PARAMETER KBArticleID
		Post search criteria. Finds updates that contain a KBArticleID (or sets of KBArticleIDs), such as 'KB982861'.
	
	.PARAMETER Title
		Post search criteria. Finds updates that match part of title, such as ''

	.PARAMETER NotCategory
		Post search criteria. Finds updates that not contain a specified category name (or sets of categories name), such as 'Updates', 'Security Updates', 'Critical Updates', etc...
		
	.PARAMETER NotKBArticleID
		Post search criteria. Finds updates that not contain a KBArticleID (or sets of KBArticleIDs), such as 'KB982861'.
	
	.PARAMETER NotTitle
		Post search criteria. Finds updates that not match part of title.
		
	.PARAMETER IgnoreUserInput
		Post search criteria. Finds updates that the installation or uninstallation of an update can't prompt for user input.
	
	.PARAMETER IgnoreRebootRequired
		Post search criteria. Finds updates that specifies the restart behavior that not occurs when you install or uninstall the update.
	
	.PARAMETER ServiceID
		Set ServiceIS to change the default source of Windows Updates. It overwrite ServerSelection parameter value.

	.PARAMETER WindowsUpdate
		Set Windows Update Server as source. Default update config are taken from computer policy.
		
	.PARAMETER MicrosoftUpdate
		Set Microsoft Update Server as source. Default update config are taken from computer policy.
		
	.PARAMETER ListOnly
		Show list of updates only without downloading and installing. Works similar like Get-WUList.
	
	.PARAMETER DownloadOnly
		Show list and download approved updates but do not install it. 
	
	.PARAMETER AcceptAll
		Do not ask for confirmation updates. Install all available updates.
	
	.PARAMETER AutoReboot
		Do not ask for rebbot if it needed.
	
	.PARAMETER IgnoreReboot
		Do not ask for reboot if it needed, but do not reboot automaticaly. 
	
	.PARAMETER AutoSelectOnly  
		Install only the updates that have status AutoSelectOnWebsites on true.

	.PARAMETER Debuger	
	    Debug mode.

	.EXAMPLE
		Get info about updates that are not require user interaction to install.
	
		PS C:\> Get-WUInstall -MicrosoftUpdate -IgnoreUserInput -WhatIf -Verbose
		VERBOSE: Connecting to Microsoft Update server. Please wait...
		VERBOSE: Found [39] Updates in pre search criteria
		VERBOSE: Found [5] Updates in post search criteria to Download
		What if: Performing operation "Aktualizacja firmy Microsoft z ekranem wybierania przeglądarki dla użytkowników systemu W
		indows 7 dla systemów opartych na procesorach x64 w Europejskim Obszarze Gospodarczym (KB976002)[1 MB]?" on Target "KOMP
		UTER".
		What if: Performing operation "Aktualizacja dla systemu Windows 7 dla systemów opartych na procesorach x64 (KB971033)[1
		MB]?" on Target "KOMPUTER".
		What if: Performing operation "Aktualizacja systemu Windows 7 dla komputerów z procesorami x64 (KB2533552)[1 MB]?" on Ta
		rget "KOMPUTER".
		What if: Performing operation "Program Microsoft .NET Framework 4 Client Profile w systemie Windows 7 dla systemów opart
		ych na procesorach x64 (KB982670)[1 MB]?" on Target "KOMPUTER".
		What if: Performing operation "Narzędzie Windows do usuwania złośliwego oprogramowania dla komputerów z procesorem x64 -
		 grudzień 2011 (KB890830)[1 MB]?" on Target "KOMPUTER".

		X Status     KB          Size Title
		- ------     --          ---- -----
		2 Rejected   KB890830    1 MB Aktualizacja firmy Microsoft z ekranem wybierania przeglądarki dla użytkowników system...
		2 Rejected   KB890830    1 MB Aktualizacja dla systemu Windows 7 dla systemów opartych na procesorach x64 (KB971033)
		2 Rejected   KB890830    1 MB Aktualizacja systemu Windows 7 dla komputerów z procesorami x64 (KB2533552)
		2 Rejected   KB890830    1 MB Program Microsoft .NET Framework 4 Client Profile w systemie Windows 7 dla systemów op...
		2 Rejected   KB890830    1 MB Narzędzie Windows do usuwania złośliwego oprogramowania dla komputerów z procesorem x6...
		VERBOSE: Accept [0] Updates to Download
	
	.EXAMPLE
		Get updates from specific source with title contains ".NET Framework 4". Everything automatic accept and install.
	
		PS C:\> Get-WUInstall -ServiceID 9482f4b4-e343-43b6-b170-9a65bc822c77 -Title ".NET Framework 4" -AcceptAll

		X Status     KB          Size Title
		- ------     --          ---- -----
		2 Accepted   KB982670   48 MB Program Microsoft .NET Framework 4 Client Profile w systemie Windows 7 dla systemów op...
		3 Downloaded KB982670   48 MB Program Microsoft .NET Framework 4 Client Profile w systemie Windows 7 dla systemów op...
		4 Installed  KB982670   48 MB Program Microsoft .NET Framework 4 Client Profile w systemie Windows 7 dla systemów op...

	.EXAMPLE
		Get updates with specyfic KBArticleID. Check if type are "Software" and automatic install all.
		
		PS C:\> $KBList = "KB890830","KB2533552","KB2539636"
		PS C:\> Get-WUInstall -Type "Software" -KBArticleID $KBList -AcceptAll

		X Status     KB          Size Title
		- ------     --          ---- -----
		2 Accepted   KB2533552   9 MB Aktualizacja systemu Windows 7 dla komputerów z procesorami x64 (KB2533552)
		2 Accepted   KB2539636   4 MB Aktualizacja zabezpieczeń dla programu Microsoft .NET Framework 4 w systemach Windows ...
		2 Accepted   KB890830    1 MB Narzędzie Windows do usuwania złośliwego oprogramowania dla komputerów z procesorem x6...
		3 Downloaded KB2533552   9 MB Aktualizacja systemu Windows 7 dla komputerów z procesorami x64 (KB2533552)
		3 Downloaded KB2539636   4 MB Aktualizacja zabezpieczeń dla programu Microsoft .NET Framework 4 w systemach Windows ...
		3 Downloaded KB890830    1 MB Narzędzie Windows do usuwania złośliwego oprogramowania dla komputerów z procesorem x6...	
		4 Installed  KB2533552   9 MB Aktualizacja systemu Windows 7 dla komputerów z procesorami x64 (KB2533552)
		4 Installed  KB2539636   4 MB Aktualizacja zabezpieczeń dla programu Microsoft .NET Framework 4 w systemach Windows ...
		4 Installed  KB890830    1 MB Narzędzie Windows do usuwania złośliwego oprogramowania dla komputerów z procesorem x6...
	
	.EXAMPLE
		Get list of updates without language packs and updatets that's not hidden.

		PS C:\> Get-WUInstall -NotCategory "Language packs" -ListOnly

		X Status KB          Size Title
		- ------ --          ---- -----
		1 ------ KB2640148   8 MB Aktualizacja systemu Windows 7 dla komputerów z procesorami x64 (KB2640148)
		1 ------ KB2600217  32 MB Aktualizacja dla programu Microsoft .NET Framework 4 w systemach Windows XP, Se...
		1 ------ KB2679255   6 MB Aktualizacja systemu Windows 7 dla komputerów z procesorami x64 (KB2679255)
		1 ------ KB915597    3 MB Definition Update for Windows Defender - KB915597 (Definition 1.125.146.0)
		
	.NOTES
		Author: Michal Gajda
		Blog  : http://commandlinegeeks.com/
		
	.LINK
		http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
		http://msdn.microsoft.com/en-us/library/windows/desktop/aa386526(v=vs.85).aspx
		http://msdn.microsoft.com/en-us/library/windows/desktop/aa386099(v=vs.85).aspx
		http://msdn.microsoft.com/en-us/library/ff357803(VS.85).aspx

	.LINK
		Get-WUServiceManager
		Get-WUList
	#>
	[OutputType('PSWindowsUpdate.WUInstall')]
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="High"
	)]	
	Param
	(
		#Pre search criteria
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[ValidateSet("Driver", "Software")]
		[String]$UpdateType="",
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String[]]$UpdateID,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[Int]$RevisionNumber,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String[]]$CategoryIDs,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[Switch]$IsInstalled,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[Switch]$IsHidden,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[Switch]$WithHidden,
		[String]$Criteria,
		[Switch]$ShowSearchCriteria,
		
		#Post search criteria
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String[]]$Category="",
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String[]]$KBArticleID,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$Title,
		
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String[]]$NotCategory="",
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String[]]$NotKBArticleID,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[String]$NotTitle,
		
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[Alias("Silent")]
		[Switch]$IgnoreUserInput,
		[parameter(ValueFromPipelineByPropertyName=$true)]
		[Switch]$IgnoreRebootRequired,
		
		#Connection options
		[String]$ServiceID,
		[Switch]$WindowsUpdate,
		[Switch]$MicrosoftUpdate,
		
		#Mode options
		[Switch]$ListOnly,
		[Switch]$DownloadOnly,
		[Alias("All")]
		[Switch]$AcceptAll,
		[Switch]$AutoReboot,
		[Switch]$IgnoreReboot,
		[Switch]$AutoSelectOnly,
		[Switch]$Debuger
	)

	Begin
	{
		If($PSBoundParameters['Debuger'])
		{
			$DebugPreference = "Continue"
		} #End If $PSBoundParameters['Debuger']
		
		$User = [Security.Principal.WindowsIdentity]::GetCurrent()
		$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

		if(!$Role)
		{
			Write-Warning "To perform some operations you must run an elevated Windows PowerShell console."	
		} #End If !$Role
	}

	Process
	{
		#region	STAGE 0	
		######################################
		# Start STAGE 0: Prepare environment #
		######################################
		
		Write-Debug "STAGE 0: Prepare environment"
		If($IsInstalled)
		{
			$ListOnly = $true
			Write-Debug "Change to ListOnly mode"
		} #End If $IsInstalled

		Write-Debug "Check reboot status only for local instance"
		Try
		{
			$objSystemInfo = New-Object -ComObject "Microsoft.Update.SystemInfo"	
			If($objSystemInfo.RebootRequired)
			{
				Write-Warning "Reboot is required to continue"
				If($AutoReboot)
				{
					Restart-Computer -Force
				} #End If $AutoReboot

				If(!$ListOnly)
				{
					Return
				} #End If !$ListOnly	
				
			} #End If $objSystemInfo.RebootRequired
		} #End Try
		Catch
		{
			Write-Warning "Support local instance only, Continue..."
		} #End Catch
		
		Write-Debug "Set number of stage"
		If($ListOnly)
		{
			$NumberOfStage = 2
		} #End $ListOnly
		ElseIf($DownloadOnly)
		{
			$NumberOfStage = 3
		} #End Else $ListOnly If $DownloadOnly
		Else
		{
			$NumberOfStage = 4
		} #End Else $DownloadOnly
		
		####################################			
		# End STAGE 0: Prepare environment #
		####################################
		#endregion
		
		#region	STAGE 1
		###################################
		# Start STAGE 1: Get updates list #
		###################################			
		
		Write-Debug "STAGE 1: Get updates list"
		Write-Debug "Create Microsoft.Update.ServiceManager object"
		$objServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager" 
		
		Write-Debug "Create Microsoft.Update.Session object"
		$objSession = New-Object -ComObject "Microsoft.Update.Session" 
		
		Write-Debug "Create Microsoft.Update.Session.Searcher object"
		$objSearcher = $objSession.CreateUpdateSearcher()

		If($WindowsUpdate)
		{
			Write-Debug "Set source of updates to Windows Update"
			$objSearcher.ServerSelection = 2
			$serviceName = "Windows Update"
		} #End If $WindowsUpdate
		ElseIf($MicrosoftUpdate)
		{
			Write-Debug "Set source of updates to Microsoft Update"
			$serviceName = $null
			Foreach ($objService in $objServiceManager.Services) 
			{
				If($objService.Name -eq "Microsoft Update")
				{
					$objSearcher.ServerSelection = 3
					$objSearcher.ServiceID = $objService.ServiceID
					$serviceName = $objService.Name
					Break
				}#End If $objService.Name -eq "Microsoft Update"
			}#End ForEach $objService in $objServiceManager.Services
			
			If(-not $serviceName)
			{
				Write-Warning "Can't find registered service Microsoft Update. Use Get-WUServiceManager to get registered service."
				Return
			}#Enf If -not $serviceName
		} #End Else $WindowsUpdate If $MicrosoftUpdate
		Else
		{
			Foreach ($objService in $objServiceManager.Services) 
			{
				If($ServiceID)
				{
					If($objService.ServiceID -eq $ServiceID)
					{
						$objSearcher.ServiceID = $ServiceID
						$objSearcher.ServerSelection = 3
						$serviceName = $objService.Name
						Break
					} #End If $objService.ServiceID -eq $ServiceID
				} #End If $ServiceID
				Else
				{
					If($objService.IsDefaultAUService -eq $True)
					{
						$serviceName = $objService.Name
						Break
					} #End If $objService.IsDefaultAUService -eq $True
				} #End Else $ServiceID
			} #End Foreach $objService in $objServiceManager.Services
		} #End Else $MicrosoftUpdate
		Write-Debug "Set source of updates to $serviceName"
		
		Write-Verbose "Connecting to $serviceName server. Please wait..."
		Try
		{
			$search = ""
			
			If($Criteria)
			{
				$search = $Criteria
			} #End If $Criteria
			Else
			{
				If($IsInstalled) 
				{
					$search = "IsInstalled = 1"
					Write-Debug "Set pre search criteria: IsInstalled = 1"
				} #End If $IsInstalled
				Else
				{
					$search = "IsInstalled = 0"	
					Write-Debug "Set pre search criteria: IsInstalled = 0"
				} #End Else $IsInstalled
				
				If($UpdateType -ne "")
				{
					Write-Debug "Set pre search criteria: Type = $UpdateType"
					$search += " and Type = '$UpdateType'"
				} #End If $UpdateType -ne ""					
				
				If($UpdateID)
				{
					Write-Debug "Set pre search criteria: UpdateID = '$([string]::join(", ", $UpdateID))'"
					$tmp = $search
					$search = ""
					$LoopCount = 0
					Foreach($ID in $UpdateID)
					{
						If($LoopCount -gt 0)
						{
							$search += " or "
						} #End If $LoopCount -gt 0
						If($RevisionNumber)
						{
							Write-Debug "Set pre search criteria: RevisionNumber = '$RevisionNumber'"	
							$search += "($tmp and UpdateID = '$ID' and RevisionNumber = $RevisionNumber)"
						} #End If $RevisionNumber
						Else
						{
							$search += "($tmp and UpdateID = '$ID')"
						} #End Else $RevisionNumber
						$LoopCount++
					} #End Foreach $ID in $UpdateID
				} #End If $UpdateID

				If($CategoryIDs)
				{
					Write-Debug "Set pre search criteria: CategoryIDs = '$([string]::join(", ", $CategoryIDs))'"
					$tmp = $search
					$search = ""
					$LoopCount =0
					Foreach($ID in $CategoryIDs)
					{
						If($LoopCount -gt 0)
						{
							$search += " or "
						} #End If $LoopCount -gt 0
						$search += "($tmp and CategoryIDs contains '$ID')"
						$LoopCount++
					} #End Foreach $ID in $CategoryIDs
				} #End If $CategoryIDs
				
				If($IsHidden) 
				{
					Write-Debug "Set pre search criteria: IsHidden = 1"
					$search += " and IsHidden = 1"	
				} #End If $IsNotHidden
				ElseIf($WithHidden) 
				{
					Write-Debug "Set pre search criteria: IsHidden = 1 and IsHidden = 0"
				} #End ElseIf $WithHidden
				Else
				{
					Write-Debug "Set pre search criteria: IsHidden = 0"
					$search += " and IsHidden = 0"	
				} #End Else $WithHidden
				
				#Don't know why every update have RebootRequired=false which is not always true
				If($IgnoreRebootRequired) 
				{
					Write-Debug "Set pre search criteria: RebootRequired = 0"
					$search += " and RebootRequired = 0"	
				} #End If $IgnoreRebootRequired
			} #End Else $Criteria
			
			Write-Debug "Search criteria is: $search"
			
			If($ShowSearchCriteria)
			{
				Write-Output $search
			} #End If $ShowSearchCriteria
			
			$objResults = $objSearcher.Search($search)
		} #End Try
		Catch
		{
			If($_ -match "HRESULT: 0x80072EE2")
			{
				Write-Warning "Probably you don't have connection to Windows Update server"
			} #End If $_ -match "HRESULT: 0x80072EE2"
			Return
		} #End Catch

		$objCollectionUpdate = New-Object -ComObject "Microsoft.Update.UpdateColl" 
		
		$NumberOfUpdate = 1
		$UpdateCollection = @()
		$UpdatesExtraDataCollection = @{}
		$PreFoundUpdatesToDownload = $objResults.Updates.count
		Write-Verbose "Found [$PreFoundUpdatesToDownload] Updates in pre search criteria"				

		Foreach($Update in $objResults.Updates)
		{	
			$UpdateAccess = $true
			Write-Progress -Activity "Post search updates for $Computer" -Status "[$NumberOfUpdate/$PreFoundUpdatesToDownload] $($Update.Title) $size" -PercentComplete ([int]($NumberOfUpdate/$PreFoundUpdatesToDownload * 100))
			Write-Debug "Set post search criteria: $($Update.Title)"
			
			If($Category -ne "")
			{
				$UpdateCategories = $Update.Categories | Select-Object Name
				Write-Debug "Set post search criteria: Categories = '$([string]::join(", ", $Category))'"	
				Foreach($Cat in $Category)
				{
					If(!($UpdateCategories -match $Cat))
					{
						Write-Debug "UpdateAccess: false"
						$UpdateAccess = $false
					} #End If !($UpdateCategories -match $Cat)
					Else
					{
						$UpdateAccess = $true
						Break
					} #End Else !($UpdateCategories -match $Cat)
				} #End Foreach $Cat in $Category	
			} #End If $Category -ne ""

			If($NotCategory -ne "" -and $UpdateAccess -eq $true)
			{
				$UpdateCategories = $Update.Categories | Select-Object Name
				Write-Debug "Set post search criteria: NotCategories = '$([string]::join(", ", $NotCategory))'"	
				Foreach($Cat in $NotCategory)
				{
					If($UpdateCategories -match $Cat)
					{
						Write-Debug "UpdateAccess: false"
						$UpdateAccess = $false
						Break
					} #End If $UpdateCategories -match $Cat
				} #End Foreach $Cat in $NotCategory	
			} #End If $NotCategory -ne "" -and $UpdateAccess -eq $true					
			
			If($KBArticleID -ne $null -and $UpdateAccess -eq $true)
			{
				Write-Debug "Set post search criteria: KBArticleIDs = '$([string]::join(", ", $KBArticleID))'"
				If(!($KBArticleID -match $Update.KBArticleIDs -and "" -ne $Update.KBArticleIDs))
				{
					Write-Debug "UpdateAccess: false"
					$UpdateAccess = $false
				} #End If !($KBArticleID -match $Update.KBArticleIDs)								
			} #End If $KBArticleID -ne $null -and $UpdateAccess -eq $true

			If($NotKBArticleID -ne $null -and $UpdateAccess -eq $true)
			{
				Write-Debug "Set post search criteria: NotKBArticleIDs = '$([string]::join(", ", $NotKBArticleID))'"
				If($NotKBArticleID -match $Update.KBArticleIDs -and "" -ne $Update.KBArticleIDs)
				{
					Write-Debug "UpdateAccess: false"
					$UpdateAccess = $false
				} #End If$NotKBArticleID -match $Update.KBArticleIDs -and "" -ne $Update.KBArticleIDs					
			} #End If $NotKBArticleID -ne $null -and $UpdateAccess -eq $true
			
			If($Title -and $UpdateAccess -eq $true)
			{
				Write-Debug "Set post search criteria: Title = '$Title'"
				If($Update.Title -notmatch $Title)
				{
					Write-Debug "UpdateAccess: false"
					$UpdateAccess = $false
				} #End If $Update.Title -notmatch $Title
			} #End If $Title -and $UpdateAccess -eq $true

			If($NotTitle -and $UpdateAccess -eq $true)
			{
				Write-Debug "Set post search criteria: NotTitle = '$NotTitle'"
				If($Update.Title -match $NotTitle)
				{
					Write-Debug "UpdateAccess: false"
					$UpdateAccess = $false
				} #End If $Update.Title -notmatch $NotTitle
			} #End If $NotTitle -and $UpdateAccess -eq $true
			
			If($IgnoreUserInput -and $UpdateAccess -eq $true)
			{
				Write-Debug "Set post search criteria: CanRequestUserInput"
				If($Update.InstallationBehavior.CanRequestUserInput -eq $true)
				{
					Write-Debug "UpdateAccess: false"
					$UpdateAccess = $false
				} #End If $Update.InstallationBehavior.CanRequestUserInput -eq $true
			} #End If $IgnoreUserInput -and $UpdateAccess -eq $true

			If($IgnoreRebootRequired -and $UpdateAccess -eq $true) 
			{
				Write-Debug "Set post search criteria: RebootBehavior"
				If($Update.InstallationBehavior.RebootBehavior -ne 0)
				{
					Write-Debug "UpdateAccess: false"
					$UpdateAccess = $false
				} #End If $Update.InstallationBehavior.RebootBehavior -ne 0	
			} #End If $IgnoreRebootRequired -and $UpdateAccess -eq $true

			If($UpdateAccess -eq $true)
			{
				Write-Debug "Convert size"
				Switch($Update.MaxDownloadSize)
				{
					{[System.Math]::Round($_/1KB,0) -lt 1024} { $size = [String]([System.Math]::Round($_/1KB,0))+" KB"; break }
					{[System.Math]::Round($_/1MB,0) -lt 1024} { $size = [String]([System.Math]::Round($_/1MB,0))+" MB"; break }  
					{[System.Math]::Round($_/1GB,0) -lt 1024} { $size = [String]([System.Math]::Round($_/1GB,0))+" GB"; break }    
					{[System.Math]::Round($_/1TB,0) -lt 1024} { $size = [String]([System.Math]::Round($_/1TB,0))+" TB"; break }
					default { $size = $_+"B" }
				} #End Switch
			
				Write-Debug "Convert KBArticleIDs"
				If($Update.KBArticleIDs -ne "")    
				{
					$KB = "KB"+$Update.KBArticleIDs
				} #End If $Update.KBArticleIDs -ne ""
				Else 
				{
					$KB = ""
				} #End Else $Update.KBArticleIDs -ne ""
				
				If($ListOnly)
				{
					$Status = ""
					If($Update.IsDownloaded)    {$Status += "D"} else {$status += "-"}
					If($Update.IsInstalled)     {$Status += "I"} else {$status += "-"}
					If($Update.IsMandatory)     {$Status += "M"} else {$status += "-"}
					If($Update.IsHidden)        {$Status += "H"} else {$status += "-"}
					If($Update.IsUninstallable) {$Status += "U"} else {$status += "-"}
					If($Update.IsBeta)          {$Status += "B"} else {$status += "-"} 
	
					Add-Member -InputObject $Update -MemberType NoteProperty -Name ComputerName -Value $env:COMPUTERNAME
					Add-Member -InputObject $Update -MemberType NoteProperty -Name KB -Value $KB
					Add-Member -InputObject $Update -MemberType NoteProperty -Name Size -Value $size
					Add-Member -InputObject $Update -MemberType NoteProperty -Name Status -Value $Status
					Add-Member -InputObject $Update -MemberType NoteProperty -Name X -Value 1
					
					$Update.PSTypeNames.Clear()
					$Update.PSTypeNames.Add('PSWindowsUpdate.WUInstall')
					$UpdateCollection += $Update
				} #End If $ListOnly
				Else
				{
					$objCollectionUpdate.Add($Update) | Out-Null
					$UpdatesExtraDataCollection.Add($Update.Identity.UpdateID,@{KB = $KB; Size = $size})
				} #End Else $ListOnly
			} #End If $UpdateAccess -eq $true
			
			$NumberOfUpdate++
		} #End Foreach $Update in $objResults.Updates				
		Write-Progress -Activity "[1/$NumberOfStage] Post search updates" -Status "Completed" -Completed
		
		If($ListOnly)
		{
			$FoundUpdatesToDownload = $UpdateCollection.count
		} #End If $ListOnly
		Else
		{
			$FoundUpdatesToDownload = $objCollectionUpdate.count				
		} #End Else $ListOnly
		Write-Verbose "Found [$FoundUpdatesToDownload] Updates in post search criteria"
		
		If($FoundUpdatesToDownload -eq 0)
		{
			Return
		} #End If $FoundUpdatesToDownload -eq 0
		
		If($ListOnly)
		{
			Write-Debug "Return only list of updates"
			Return $UpdateCollection				
		} #End If $ListOnly

		#################################
		# End STAGE 1: Get updates list #
		#################################
		#endregion
		

		If(!$ListOnly) 
		{
			#region	STAGE 2
			#################################
			# Start STAGE 2: Choose updates #
			#################################
			
			Write-Debug "STAGE 2: Choose updates"			
			$NumberOfUpdate = 1
			$logCollection = @()
			
			$objCollectionChoose = New-Object -ComObject "Microsoft.Update.UpdateColl"

			Foreach($Update in $objCollectionUpdate)
			{	
				$size = $UpdatesExtraDataCollection[$Update.Identity.UpdateID].Size
				Write-Progress -Activity "[2/$NumberOfStage] Choose updates" -Status "[$NumberOfUpdate/$FoundUpdatesToDownload] $($Update.Title) $size" -PercentComplete ([int]($NumberOfUpdate/$FoundUpdatesToDownload * 100))
				Write-Debug "Show update to accept: $($Update.Title)"
				
				If($AcceptAll)
				{
					$Status = "Accepted"

					If($Update.EulaAccepted -eq 0)
					{ 
						Write-Debug "Accept Eula"
						$Update.AcceptEula() 
					} #End If $Update.EulaAccepted -eq 0
			
					Write-Debug "Add update to collection"
					$objCollectionChoose.Add($Update) | Out-Null
				} #End If $AcceptAll
				ElseIf($AutoSelectOnly)  
				{  
					If($Update.AutoSelectOnWebsites)  
					{  
						$Status = "Accepted"  
						If($Update.EulaAccepted -eq 0)  
						{  
							Write-Debug "Accept Eula"  
							$Update.AcceptEula()  
						} #End If $Update.EulaAccepted -eq 0  
  
						Write-Debug "Add update to collection"  
						$objCollectionChoose.Add($Update) | Out-Null  
					} #End If $Update.AutoSelectOnWebsites 
					Else  
					{  
						$Status = "Rejected"  
					} #End Else $Update.AutoSelectOnWebsites
				} #End ElseIf $AutoSelectOnly
				Else
				{
					If($pscmdlet.ShouldProcess($Env:COMPUTERNAME,"$($Update.Title)[$size]?")) 
					{
						$Status = "Accepted"
						
						If($Update.EulaAccepted -eq 0)
						{ 
							Write-Debug "Accept Eula"
							$Update.AcceptEula() 
						} #End If $Update.EulaAccepted -eq 0
				
						Write-Debug "Add update to collection"
						$objCollectionChoose.Add($Update) | Out-Null 
					} #End If $pscmdlet.ShouldProcess($Env:COMPUTERNAME,"$($Update.Title)[$size]?")
					Else
					{
						$Status = "Rejected"
					} #End Else $pscmdlet.ShouldProcess($Env:COMPUTERNAME,"$($Update.Title)[$size]?")
				} #End Else $AutoSelectOnly
				
				Write-Debug "Add to log collection"
				$log = New-Object PSObject -Property @{
					Title = $Update.Title
					KB = $UpdatesExtraDataCollection[$Update.Identity.UpdateID].KB
					Size = $UpdatesExtraDataCollection[$Update.Identity.UpdateID].Size
					Status = $Status
					X = 2
				} #End PSObject Property
				
				$log.PSTypeNames.Clear()
				$log.PSTypeNames.Add('PSWindowsUpdate.WUInstall')
				
				$logCollection += $log
				
				$NumberOfUpdate++
			} #End Foreach $Update in $objCollectionUpdate
			Write-Progress -Activity "[2/$NumberOfStage] Choose updates" -Status "Completed" -Completed
			
			Write-Debug "Show log collection"
			$logCollection
			
			
			$AcceptUpdatesToDownload = $objCollectionChoose.count
			Write-Verbose "Accept [$AcceptUpdatesToDownload] Updates to Download"
			
			If($AcceptUpdatesToDownload -eq 0)
			{
				Return
			} #End If $AcceptUpdatesToDownload -eq 0	
				
			###############################
			# End STAGE 2: Choose updates #
			###############################
			#endregion
			
			#region STAGE 3
			###################################
			# Start STAGE 3: Download updates #
			###################################
			
			Write-Debug "STAGE 3: Download updates"
			$NumberOfUpdate = 1
			$objCollectionDownload = New-Object -ComObject "Microsoft.Update.UpdateColl" 

			Foreach($Update in $objCollectionChoose)
			{
				Write-Progress -Activity "[3/$NumberOfStage] Downloading updates" -Status "[$NumberOfUpdate/$AcceptUpdatesToDownload] $($Update.Title) $size" -PercentComplete ([int]($NumberOfUpdate/$AcceptUpdatesToDownload * 100))
				Write-Debug "Show update to download: $($Update.Title)"
				
				Write-Debug "Send update to download collection"
				$objCollectionTmp = New-Object -ComObject "Microsoft.Update.UpdateColl"
				$objCollectionTmp.Add($Update) | Out-Null
					
				$Downloader = $objSession.CreateUpdateDownloader() 
				$Downloader.Updates = $objCollectionTmp
				Try
				{
					Write-Debug "Try download update"
					$DownloadResult = $Downloader.Download()
				} #End Try
				Catch
				{
					If($_ -match "HRESULT: 0x80240044")
					{
						Write-Warning "Your security policy don't allow a non-administator identity to perform this task"
					} #End If $_ -match "HRESULT: 0x80240044"
					
					Return
				} #End Catch 
				
				Write-Debug "Check ResultCode"
				Switch -exact ($DownloadResult.ResultCode)
				{
					0   { $Status = "NotStarted" }
					1   { $Status = "InProgress" }
					2   { $Status = "Downloaded" }
					3   { $Status = "DownloadedWithErrors" }
					4   { $Status = "Failed" }
					5   { $Status = "Aborted" }
				} #End Switch
				
				Write-Debug "Add to log collection"
				$log = New-Object PSObject -Property @{
					Title = $Update.Title
					KB = $UpdatesExtraDataCollection[$Update.Identity.UpdateID].KB
					Size = $UpdatesExtraDataCollection[$Update.Identity.UpdateID].Size
					Status = $Status
					X = 3
				} #End PSObject Property
				
				$log.PSTypeNames.Clear()
				$log.PSTypeNames.Add('PSWindowsUpdate.WUInstall')
				
				$log
				
				If($DownloadResult.ResultCode -eq 2)
				{
					Write-Debug "Downloaded then send update to next stage"
					$objCollectionDownload.Add($Update) | Out-Null
				} #End If $DownloadResult.ResultCode -eq 2
				
				$NumberOfUpdate++
				
			} #End Foreach $Update in $objCollectionChoose
			Write-Progress -Activity "[3/$NumberOfStage] Downloading updates" -Status "Completed" -Completed

			$ReadyUpdatesToInstall = $objCollectionDownload.count
			Write-Verbose "Downloaded [$ReadyUpdatesToInstall] Updates to Install"
		
			If($ReadyUpdatesToInstall -eq 0)
			{
				Return
			} #End If $ReadyUpdatesToInstall -eq 0
		

			#################################
			# End STAGE 3: Download updates #
			#################################
			#endregion
			
			If(!$DownloadOnly)
			{
				#region	STAGE 4
				##################################
				# Start STAGE 4: Install updates #
				##################################
				
				Write-Debug "STAGE 4: Install updates"
				$NeedsReboot = $false
				$NumberOfUpdate = 1
				
				#install updates	
				Foreach($Update in $objCollectionDownload)
				{   
					Write-Progress -Activity "[4/$NumberOfStage] Installing updates" -Status "[$NumberOfUpdate/$ReadyUpdatesToInstall] $($Update.Title)" -PercentComplete ([int]($NumberOfUpdate/$ReadyUpdatesToInstall * 100))
					Write-Debug "Show update to install: $($Update.Title)"
					
					Write-Debug "Send update to install collection"
					$objCollectionTmp = New-Object -ComObject "Microsoft.Update.UpdateColl"
					$objCollectionTmp.Add($Update) | Out-Null
					
					$objInstaller = $objSession.CreateUpdateInstaller()
					$objInstaller.Updates = $objCollectionTmp
						
					Try
					{
						Write-Debug "Try install update"
						$InstallResult = $objInstaller.Install()
					} #End Try
					Catch
					{
						If($_ -match "HRESULT: 0x80240044")
						{
							Write-Warning "Your security policy don't allow a non-administator identity to perform this task"
						} #End If $_ -match "HRESULT: 0x80240044"
						
						Return
					} #End Catch
					
					If(!$NeedsReboot) 
					{ 
						Write-Debug "Set instalation status RebootRequired"
						$NeedsReboot = $installResult.RebootRequired 
					} #End If !$NeedsReboot
					
					Switch -exact ($InstallResult.ResultCode)
					{
						0   { $Status = "NotStarted"}
						1   { $Status = "InProgress"}
						2   { $Status = "Installed"}
						3   { $Status = "InstalledWithErrors"}
						4   { $Status = "Failed"}
						5   { $Status = "Aborted"}
					} #End Switch
				   
					Write-Debug "Add to log collection"
					$log = New-Object PSObject -Property @{
						Title = $Update.Title
						KB = $UpdatesExtraDataCollection[$Update.Identity.UpdateID].KB
						Size = $UpdatesExtraDataCollection[$Update.Identity.UpdateID].Size
						Status = $Status
						X = 4
					} #End PSObject Property
					
					$log.PSTypeNames.Clear()
					$log.PSTypeNames.Add('PSWindowsUpdate.WUInstall')
					
					$log
				
					$NumberOfUpdate++
				} #End Foreach $Update in $objCollectionDownload
				Write-Progress -Activity "[4/$NumberOfStage] Installing updates" -Status "Completed" -Completed
				
				If($NeedsReboot)
				{
					If($AutoReboot)
					{
						Restart-Computer -Force
					} #End If $AutoReboot
					ElseIf($IgnoreReboot)
					{
						Return "Reboot is required, but do it manually."
					} #End Else $AutoReboot If $IgnoreReboot
					Else
					{
						$Reboot = Read-Host "Reboot is required. Do it now ? [Y/N]"
						If($Reboot -eq "Y")
						{
							Restart-Computer -Force
						} #End If $Reboot -eq "Y"
						
					} #End Else $IgnoreReboot	
					
				} #End If $NeedsReboot

				################################
				# End STAGE 4: Install updates #
				################################
				#endregion
			} #End If !$DownloadOnly
		} #End !$ListOnly
	} #End Process
	
	End{}		
} #In The End :)

##END DO NOT EDIT
If($count -eq 0)
	{
		Get-WUInstall -NotCategory "Language packs" -AcceptAll -Verbose -IgnoreReboot
		$count + 1 > C:\SystemTools\count.txt
		Restart-Computer
	} #End if Count 0
##DO NOT EDIT
Function Add-WUServiceManager 
{
	<#
	.SYNOPSIS
	    Register windows update service manager.

	.DESCRIPTION
	    Use Add-WUServiceManager to register new Windows Update Service Manager.
    
	.PARAMETER ServiceID	
		An identifier for the service to be registered. 
		
		Examples Of ServiceID:
		Windows Update 					9482f4b4-e343-43b6-b170-9a65bc822c77 
		Microsoft Update 				7971f918-a847-4430-9279-4a52d1efe18d 
		Windows Store 					117cab2d-82b1-4b5a-a08c-4d62dbee7782 
		Windows Server Update Service 	3da21691-e39d-4da6-8a4b-b43877bcb1b7 
	
	.PARAMETER AddServiceFlag	
		A combination of AddServiceFlag values. 0x1 - asfAllowPendingRegistration, 0x2 - asfAllowOnlineRegistration, 0x4 - asfRegisterServiceWithAU
	
	.PARAMETER authorizationCabPath	
		The path of the Microsoft signed local cabinet file (.cab) that has the information that is required for a service registration. If empty, the update agent searches for the authorization cabinet file (.cab) during service registration when a network connection is available.
		
	.EXAMPLE
		Try register Microsoft Update Service.
	
		PS H:\> Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d"

		Confirm
		Are you sure you want to perform this action?
		Performing the operation "Register Windows Update Service Manager: 7971f918-a847-4430-9279-4a52d1efe18d" on target "MG".
		[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): Y

		RegistrationState ServiceID                       IsPendingRegistrationWithAU Service
		----------------- ---------                       --------------------------- -------
                  		3 7971f918-a847-4430-9279-4a...                         False System.__ComObject

	.NOTES
		Author: Michal Gajda
		Blog  : http://commandlinegeeks.com/
		
	.LINK
		http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc
	
	.LINK
		http://msdn.microsoft.com/en-us/library/aa387290(v=vs.85).aspx
		http://support.microsoft.com/kb/926464

	.LINK
        Get-WUServiceManager
		Remove-WUServiceManager
	#>
    [OutputType('PSWindowsUpdate.WUServiceManager')]
	[CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]
    Param
    (
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceID,
		[Int]$AddServiceFlag = 2,
		[String]$authorizationCabPath
    )

	Begin
	{
		$User = [Security.Principal.WindowsIdentity]::GetCurrent()
		$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

		if(!$Role)
		{
			Write-Warning "To perform some operations you must run an elevated Windows PowerShell console."	
		} #End If !$Role		
	}
	
    Process
	{
        $objServiceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
        Try
        {
            If ($pscmdlet.ShouldProcess($Env:COMPUTERNAME,"Register Windows Update Service Manager: $ServiceID")) 
			{
				
				$objService = $objServiceManager.AddService2($ServiceID,$AddServiceFlag,$authorizationCabPath)
				$objService.PSTypeNames.Clear()
				$objService.PSTypeNames.Add('PSWindowsUpdate.WUServiceManager')
				
			} #End If $pscmdlet.ShouldProcess($Env:COMPUTERNAME,"Register Windows Update Service Manager: $ServiceID"
        } #End Try
        Catch 
        {
            If($_ -match "HRESULT: 0x80070005")
            {
                Write-Warning "Your security policy don't allow a non-administator identity to perform this task"
            } #End If $_ -match "HRESULT: 0x80070005"
			Else
			{
				Write-Error $_
			} #End Else $_ -match "HRESULT: 0x80070005"
			
            Return
        } #End Catch
		
        Return $objService	
	} #End Process

	End{}
} #In The End :)
##END DO NOT EDIT
If($count -eq 1)
{
	Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d"
	Get-WUInstall -NotCategory "Language packs" -MicrosoftUpdate -AcceptAll -Verbose -IgnoreReboot
	$count + 1 > C:\SystemTools\count.txt
	Restart-Computer
} #End if Count 1
#Checking for available updates
If($count -eq 2)
{
	$count + 1 > C:\SystemTools\count.txt
	Add-Computer -DomainName "akleg.org" -Credential (Get-Credential)
	Restart-Computer
} #End if count 2
If($count -eq 3)
{
	###Add Domain Power User Group to Local Machine Power User Group. http://serverfault.com/questions/120229/adding-a-user-to-the-local-administrator-group-using-powershell
	$group = [ADSI]("WinNT://"+$env:COMPUTERNAME+"/Power Users,group")
	$group.add("WinNT://akleg.org/Power Users,group")
	###Install GFI
	&"C:\SystemTools\GFI\gfibackup2010.msi" /msi EULA_ACCEPT=YES /qn
	###Run LanDesk Inventory Scan
	$fileExe = "C:\Program Files (x86)\LANDesk\LDClient\LDISCN32.EXE"
	& $fileExe /NTT=AVJNU00:5007 /S=AVJNU00  /I=HTTP://AVJNU00/ldlogon/ldappl3.ldz /V
	###Clean up tasks
	Set-SecureAutoLogon -Username "Administrator"
	""
	###Resets the Admin stored password to blank.
	Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\winlogon" -Name "AutoAdminLogon" -Value "0"
	###Stops auto logon from occuring.
	Remove-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "StartupScript"
	###Removes registry entry that points to the startupscript.bat
	Remove-Item C:\SystemTools\Installers -Recurse
	Remove-Item C:\SystemTools\config.csv 
	Remove-Item C:\SystemTools\Start-Setup.ps1
	Remove-Item C:\SystemTools\Start-SetupScript.bat
	Remove-Item C:\SystemTools\count.txt
	Function Global:Clear-RecycleBin {
	<#	
	.SYNOPSIS
	PowerShell function to list and delete old files in Recycle Bin
	.DESCRIPTION
	Includes -Delete parameter to remove old files.
	.EXAMPLE 
	Clear-RecycleBin -Days 30
	Clear-RecycleBin -Days 7 -Remove
	#> 
	[cmdletbinding()]
	Param (
	[parameter(Mandatory=$false)]$Days=0,
	[parameter(Mandatory=$false)][Switch]$Remove
	)
	Begin {$x=0} # End of small begin section
	Process 
	{
	$Shell= New-Object -ComObject Shell.Application 
	$Bin = $Shell.NameSpace(10)
	$Now = (Get-Date) -(New-TimeSpan -Days $Days) 
	ForEach($Item in $Bin.Items()) {
	If($Now -gt $Item.ModifyDate) {
	"{0,-22} {1,-20} {2,-20}" -f $Item.ModifyDate, $Item.Name, $Item.Path
	$x++ 
	} # End of first If
	If($Remove){
	If($Now -gt $Item.ModifyDate) {
	"{0,-22} {1,-20} {2,-20}" -f $Item.ModifyDate, $Item.Name, $Item.Path
	$x++ 
	$Item | Remove-Item -Force
             } # End of If Now
           } # End of If Remove
        } # End of Foreach
    } # End of Process Section
	End {
	"`n Detected $x files older than $Days days"
	"`n Removed = $Remove "
   	} # End of 'End' section
	} # End of Clear-RecycleBin Function
	Clear-RecycleBin -Days 0
	###Verification tasks
	#ComputerName
	"The computer is named $env:computername" >> $log
	#Description
	$description = Get-WMIObject -Class Win32_OperatingSystem | Select -ExpandProperty Description
	"Description of computer is $description" >> $log
	#Check Adobe Version
	$filename = "C:\windows\system32\macromed\flash\flash*.ocx"
	$file = get-item $filename  
	$version = $file.versionInfo.fileversion -replace ",", "."
	"Version $version of Flash is installed on $env:computername" >> $log
	###Check Reader Version
	$filename = "C:\Program Files (x86)\Adobe\Reader *\Reader\AcroRd32.exe"
	$file = get-item $filename  
	$version = $file.versionInfo.fileversion -replace ",", "."
	"Version $version of Adobe Reader is installed on $env:computername" >> $log
} #End if Count 3
##End Start Up Script