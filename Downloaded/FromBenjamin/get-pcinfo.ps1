<# 
     .Synopsis
    Collects PC inventory information and then emails it. Version 2.6.2
    

    .Description
        This script:
        1. Collects a variety of information about a PC specific to DOT Crg IT's environment;
           - Computer name
           - Some installed software and its versions (currently just TeamViewer, IE, and LANDesk)
           - TeamViewer ID
           - Some day, maybe, MAK/KMS
           - Some hardware info: BIOS (which inludes service tag / serial), MAC addresses (some errors there still)
           - Active Network adapter configuration (ala ipconfig)
           
        2. then emails to a specified email address
        
        There a few sections of this script:
        1. Declare functions for data collecting
        2. Declare functions for formatting report
        3. Declare functions for sending report
        4. Declare final helper/wrapper functions
        5. Run functions (at the end)
    
        Some warnings about what I do here:
        1.  Function Declarations: I don't use the full [CmdletBinding()] param() stuff, in order
            to make things more readable.

        Prequisites: Likely Powershell 2.0 or above, but only tested with PS4.0
    

#>






########################################################################################
## Begin data collectors ##
###########################

function collect-systemInfo ($PC) {
    
    Write-Progress -CurrentOperation "Collecting System Info" -Activity "Collecting info on $PC" -status "Collecting System Info on $PC"
    $systeminfo = Get-WmiObject Win32_ComputerSystem -computer $PC | Select Name,Domain,Model,Manufacturer
    <#$systeminfo = New-Object -TypeName PSObject
    $systeminfo | Add-Member -MemberType NoteProperty -Name Name -Value ($system.name)
    $systeminfo | Add-Member -MemberType NoteProperty -Name DomainOrWorkGroup -Value ($system.domain)
    $systeminfo | Add-Member -MemberType NoteProperty -Name Model -Value ($system.model)
    $systeminfo | Add-Member -MemberType NoteProperty -Name Manufacturer -Value ($system.manufacturer)
    $systeminfo
    Creating a new object is uneccessary when you can use select object to trim the excess off of the original object.
    #>
}

function collect-biosInfo ($PC)
{
    Write-progress -CurrentOperation "Collecting BIOS info" -Activity "Collecting info on $PC" -status "Collecting System Info on $PC"
    $bios = Get-WmiObject win32_bios -computer $PC
    $biosInfo = New-Object -TypeName PsObject
    $biosInfo | Add-Member -MemberType NoteProperty -Name Serial -value ($bios.serialnumber)
    $biosInfo | Add-Member -MemberType NoteProperty -Name BiosRevision -Value ($bios.SMBIOSBIOSVersion)
    $biosInfo

}

function collect-diskInfo ($PC) 
{
    $FixedDrives = Get-WmiObject win32_logicaldisk -computer $PC -Filter "DriveType = '3'"
    
    ForEach ($disk in $FixedDrives) 
	{
		$disk.size = $disk.size / 1GB
        $disk.freespace = $disk.freespace / 1GB

    	[array]$diskCollection += $disk | select DeviceID,VolumeName,Size,FreeSpace
    } 
    $diskCollection
}

function collect-OSInfo ($PC)
{
        $osinfoWmi = Get-WmiObject Win32_OperatingSystem -computer $PC
		$lastboot = $osinfoWmi.LastBootUpTime
		$version = $osinfoWmi.version
		$caption = $osinfoWmi.caption
		$architecture = $osinfoWmi.OSArchitecture
		$freememory = $osinfoWmi.FreePhysicalMemory
        $InstallDate = $osinfoWmi.installdate
		$osinfo = New-Object -TypeName PSObject
		$osinfo | Add-Member -MemberType NoteProperty -Name OS -Value $caption
		$osinfo | Add-Member -MemberType NoteProperty -Name OSVersion -Value $version
		$osinfo | Add-Member -MemberType NoteProperty -Name Architecture -Value $architecture
        $osinfo | Add-Member -MemberType NoteProperty -Name InstallDate -Value $InstallDate
		$osinfo | Add-Member -MemberType NoteProperty -Name LastBootTime -Value $lastboot
		$osinfo | Add-Member -MemberType NoteProperty -Name FreePhysicalMemory -Value $freememory
		$osinfo
}


##Function to acquire network config
##Limitations: May not get info for NICs not currently assigned an IP
Function collect-NetConfig($PC)
{
	<#
	    .SYNOPSIS
            Retrieve information on network connections on computer(s) specified.
	    .DESCRIPTION
	        Retrieves network adapter information and IP Address settings on computer(s) specified. Leverages Win32_NetworkAdapter and Win32_NetworkAdapterConfiguration. 
            For more info on these two Classes, see:
	            http://msdn.microsoft.com/en-us/library/aa394216(v=vs.85).aspx
		        http://msdn.microsoft.com/en-us/library/aa394217(v=vs.85).aspx
	    .EXAMPLE
    	    Get-IPConfig PC1
	    .PARAMETER ComputerName
    	    The computer name to query
    #>

    
    # Multi-line capture and filter of NIC properties/config
	$NicConfigs = Get-WmiObject Win32_NetworkAdapterConfiguration -computer $PC | select Description,MACAddress,DHCPEnabled,IPAddress,DHCPServer,DHCPLeaseExpires,IPEnabled | `
            Where-Object {$_.description -notlike "*miniport*" -and $_.description -notlike "*Multiplex*"  `
                            -and $_.description -notlike "*vpn*" -and $_.description -notlike "*RAS Async*" `
                            -and $_.description -notlike "*ISATAP*" }
                            # Caution: Things get messy with Virtual Adapters, e.g. HyperV adapters that take over IP for the actual physical adapter it shares a MAC with
	
	#Cast $nics as $Null array to initialize; else if it was not explicitly cast as an array we could have problems
	[array]$NICS = $null
        
    ForEach($selectedNicConfig in $NicConfigs)
    {
        #Define what the new object properties will be
        $properties = @{ 
            Name=$selectedNicConfig.description
            MAC=$selectedNicConfig.MACAddress
            DHCP=$selectedNicConfig.DHCPEnabled
            
        }

        #If there's an IP address, add it to the list of properties
        if($selectedNicConfig.IPAddress -ne $null)  { $properties.IPAddress=($selectedNicConfig).IPAddress[0] }
        
		#IP Addresses are returned as a part of a PropertySet, not a string, thus the ".$IPAddress[0]"
        #See http://stackoverflow.com/questions/13513635/tostring-returns-system-object-in-error
        else {$properties.IPAddress="Null"}

        #Finally add the new object to the array
		$NICS += New-Object PSObject -Property $properties 
    }
    
    #Return completed list of NICS
    $NICS
}

## Function to get users of the PC
function Collect-UsersOfPC ($PC)
{
		
	#Not compatible with PS2.0 or less: 	$users = ( (Get-WmiObject win32_SystemUsers).partComponent ) #Example line: \\DOTANNISD103471\root\cimv2:Win32_UserAccount.Name="Administrator",Domain="DOTANNISD103471"
	$users = ( (Get-WmiObject win32_SystemUsers -Computer $PC) | select partcomponent )#Example line: \\DOTANNISD103471\root\cimv2:Win32_UserAccount.Name="Administrator",Domain="DOTANNISD103471"
	$users | ForEach-Object { $_.partcomponent.toString().substring(47) } #Converts the property to a string, then trims first 47 characters off, e.g. : Name="Administrator",Domain="DOTANNISD103471"
	
}

# Function to collect all acconts that are local admins
Function Collect-LocalAdminAccounts($PC)
{
    # Major credit to: http://commondollars.wordpress.com/2013/12/19/getting-the-members-of-a-local-group-via-powershell/
    $admingroup = get-wmiobject win32_group -computername $PC -Filter "LocalAccount=True AND SID='S-1-5-32-544'"
    $query="GroupComponent = `"Win32_Group.Domain='" + $admingroup.Domain + "',NAME='" + $admingroup.Name + "'`""
    [array]$LocalAdminUsers = (Get-WmiObject win32_groupuser -ComputerName $PC -Filter $query) | select PartComponent | ForEach-Object {$_.partComponent.ToString().subString(34) }
    $LocalAdminUsers
}


#Function to collect Teamviewer ID and version from registry using reg.exe
function Collect-RemoteTeamViewerInfo($PC)
{

    #Check for 32/64 bit, define Regkey as appropriate
    If((Get-WmiObject win32_operatingsystem -ComputerName "$PC").osarchitecture -like "32*") { $regKeyPath = "\\$PC\HKLM\SOFTWARE\TeamViewer\" }
    ElseIf((Get-WmiObject win32_operatingsystem -ComputerName "$PC").osarchitecture -like "64*") {$regKeyPath = "\\$PC\HKLM\SOFTWARE\WOW6432Node\TeamViewer\" }

    
    # query using reg.exe, get multiline response, parse multi-line response for relevant text, convert hex to decimal
    $ClientIDreg = Reg.exe query $regKeyPath /f "ClientID" /s /t REG_DWORD | Where-Object {$_ -like "* ClientID *"}
    $ClientIDhex = $ClientIDreg.substring(29) # Trim down to just the (hexadecimal) client ID.
    
    if($ClientIDhex -is [system.array])  # Check to see if we got more than one matching result...usually the same thing multiple times
    { 
        $ClientIDdecimal = $ClientIDhex | ForEach-Object { [Convert]::ToInt32($_,16) }
        $ClientIDdecimal = $ClientIDdecimal -join ";" # Our error handling is to join all results into one for human perusal
    }

    ElseIf($ClientIDhex -isnot [system.array] )  { $ClientIDdecimal = [Convert]::ToInt32($ClientIDhex,16) }
        
    $ClientVersionRegKey = Reg.exe query $regKeyPath /f "version" /s /t REG_SZ | Where-Object {$_ -like "* version  *"}
    if($ClientVersionregKey -is [system.array]) 
    {
        $ClientVersionRegKey = $ClientVersionRegKey | ForEach-Object { $_.substring(25) } #Trim down just to version number, taking out "REG_SZ" etc
        $ClientVersion = $ClientVersionRegkey -join ";" # Alternative approach to this would be to only return highest number. However, since these are strings, sorting is more complex.
    } 
    
    ElseIf($ClientVersionRegKey -isnot [system.array])  { $ClientVersion = $ClientVersionRegKey.substring(25) }

    New-Object PSObject -Property @{ClientID=$ClientIDdecimal;Version=$ClientVersion}


    <# Notes on the above quick-and-dirty, fragile, string manipulation;
            This is expected behavior upon which the string manipulation depends.

            $ClientIDreg must have results like this:
                _________________________________________
                PS C:\Windows\system32> Reg.exe query \\$PC\HKLM\SOFTWARE\Wow6432Node\TeamViewer\ /f "ClientID" /s /t REG_DWORD

                HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer\Version9
                    ClientID    REG_DWORD    0x1376a378

                End of search: 1 match(es) found.
                PS C:\Windows\system32>
                ________________________________________     
            
            $ClientVersionReg must have result as follows:
                ____________________________________________
                PS C:\Windows\system32> Reg.exe query \\$PC\HKLM\SOFTWARE\Wow6432Node\TeamViewer\ /f "version" /s /t REG_SZ

                HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer\Version9
                    InstallationDirectory    REG_SZ    C:\Program Files (x86)\TeamViewer\Version9
                    Version    REG_SZ    9.0.31064

                End of search: 3 match(es) found.
                PS C:\Windows\system32>
                ____________________________________________
        #>


}

#Function to just get the local PC's Teamviewer ID
function Collect-LocalTeamViewerInfo
{
        #For 64-bit systems
	    if (test-path HKLM:\SOFTWARE\Wow6432Node\TeamViewer\)
	    { 
            #Get teamviewer clientID and version properties, format them nicely to a list
	        Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\TeamViewer\version* | select ClientID, version | where-object {$_.clientID -match "\d"}
	        #You could also do: (Get-itemProperty HKLM:\SOFTWARE\Wow6432Node\TeamViewer\version*).version or .clientID
            #Teamviewer typically uses \version8 or \version7 format, thus the version*
	    }
    
        #For 32-bit systems
        elseif(test-path HKLM:\SOFTWARE\TeamViewer\)
        {
            Get-ItemProperty HKLM:\SOFTWARE\TeamViewer\version* | select ClientID, version | where-object {$_.clientID -match "\d"} 
            #see notes for the 64-bit if statement
        }
    
        #Else if no TeamViewer ID found
        else
        {
            @{ClientID="__No TeamViewer registry entry found in HKLM:\SOFTWARE\Teamviewer or HKLM:\SOFTWARE\Teamviewer__";Version="__Unknown__"}
        }
    
}

##Wrapper function to select best method to get TeamviewerID, and turning on/off the remoteRegistry service if necessary
function Collect-TVID($PC)
{

    #For Local PC only - Get-ItemProperty is much simpler than reg.exe
    if($PC -like $env:COMPUTERNAME)
    { Collect-LocalTeamViewerInfo }
        
    #For Remote PCs
    elseif($PC -notlike $env:COMPUTERNAME)
    {
        #Remote Registry service must be running and available for Reg.exe to function correctly
        
        #Check RemoteRegistry service to see if it is running
        #write-progress -CurrentOperation "Querying RemoteRegistry service status" -Activity "Collecting info on $PC"
        $RemoteRegSvcStatus = sc.exe \\$PC query RemoteRegistry | Where-Object {$_ -like "*STATE*"}
        
        #If Remote Registry service is stopped, start, run query, then stop
        if($RemoteRegSvcStatus -like "*stopped*")
        {
            #Start RemoteRegistry service
         #   write-progress -CurrentOperation "Starting RemoteRegistry service on $PC" -Activity "Collecting info on $PC"
            sc.exe \\$PC start RemoteRegistry
            Start-Sleep 5 #to give service time to start
                        
            Collect-RemoteTeamViewerInfo $PC
            
            #Return RemoteRegistry service to state in which we found it
          #  write-progress -CurrentOperation "Stopping RemoteRegistry Service on $PC" -Activity "Collecting info on $PC"
            sc.exe \\$PC stop RemoteRegistry
        }
        
        #If service is already running, query
        elseif( ( (sc.exe \\$PC query RemoteRegistry) | Where-Object {$_ -like "*STATE*"} ) -like "*running*" )
        { Collect-RemoteTeamViewerInfo $PC }
        

        #If service is neither running nor stopped
        else 
        { Write-Error "Unknown RemoteRegistry service state, aborting registry query" }
    
    }
	
}

#Function to get LANDesk version
function collect-LDversion($PC)
{
   
    #64-bit
    if( Test-Path ("\\$PC" + '\C$\Program Files (x86)\LANDesk\LDClient') )
    { ( Get-Item ("\\$PC" + '\C$\Program Files (x86)\LANDesk\LDClient\LDIScn32.exe') ).versioninfo.fileversion }
    
    #32-bit
    elseif ( Test-Path ("\\$PC" + '\C$\Program Files\LANDesk\LDClient\LDIScn32.exe') )
    { ( Get-Item ("\\$PC" + '\C$\Program Files\\LANDesk\LDClient\LDIScn32.exe') ).versioninfo.fileversion }
    
    #unable to retrieve
    else {"Unable to retrieve LANDesk Inventory Scanner version"}
 
}

#Function to get Internet Explorer version info
function collect-IEversion($PC)
{
    
    #64-bit
    if( Test-Path ("\\$PC" + '\C$\Program Files (x86)\internet explorer') )
    { ( Get-Item ("\\$PC" + '\C$\Program Files (x86)\internet Explorer\iexplore.exe') ).versioninfo.fileversion }
    
    #32-bit
    elseif ( Test-Path ("\\$PC" + '\C$\Program Files\internet explorer') )
    { ( Get-Item ("\\$PC" + '\C$\Program Files\internet Explorer\iexplore.exe') ).versioninfo.fileversion }
    
    #unable to retrieve
    else {"Unable to retrieve IE version"}
    
}

Function Collect-McAgentVersion($PC)
{
    #64-bit
    if( Test-Path ("\\$PC" + '\C$\Program Files (x86)\mcafee\common framework\') )
    { ( Get-Item ("\\$PC" + '\C$\Program Files (x86)\mcafee\common framework\udaterui.exe') ).versioninfo.fileversion }
    
    #32-bit
    elseif ( Test-Path ("\\$PC" + '\C$\Program Files\mcafee\common framework\') )
    { ( Get-Item ("\\$PC" + '\C$\Program Files\mcafee\common framework\udaterui.exe') ).versioninfo.fileversion }
    
    #unable to retrieve
    else {"Unable to retrieve McAfee Udaterui.exe (Agent) version"}
    
 }








#Function to invoke other functions
#Prerequisites: At least PS2.0 or above, 3.0 or above for ordered objects (all testing done with PS4.0)
function Collect-PCinfo ($PClist){

    #If nothing specified, assume current PC
    if($PClist -eq $null) { $PClist = $env:COMPUTERNAME }

    #Define date in a nicely sortable format
    $date = Get-Date -UFormat "%Y.%m.%d.%H%M" 
    
    #initialize and cast $PCReport as an array
    [array]$PCreport = $null

    $numberOfPCsChecked = 0

	ForEach ($PC in $PClist) 
    {
        $numberOfPCsChecked += 1    
        Write-Progress -Activity "Collecting report info" -Status "Collecting info on $PC" -PercentComplete (100 * $numberOfPCsChecked / $PClist.length)
        Write-Progress -Activity "Collecting info on $PC" -Status "Collecting info on $PC" -PercentComplete 0
        
        
        # If there is a PC there
        If($PC -eq $env:COMPUTERNAME) { $continue = $true }
        ElseIf(Test-Connection $PC -count 1) { $continue = $true } # To address case where Test-Connection fails for local PC
        #Else if there is no response from the PC
        Else { $continue = $false 
                 Write-Verbose "No response from $PC" }
                 
        If($continue)
        {
        
            #Old form of this script used this syntax: $PCinfo = New-Object -TypeName PSObject
            #V2 of this script uses hashtable format
            
            # [ordered] hash tables are PS v3 and above only...$PSVersionTable is 2.0 and above
            # Edge-case, $PSVersionTable does not always work for remote sessions, but if you
            # run the script locally (even targeting remote PCs), it should be fine.

            If( $PSVersionTable.PSVersion.major -ge 3 ) { $PcInfo = [ordered]@{} }             
            Else { $PcInfo = @{} }
            
            $PCinfo.CollectedDate = ($date)

            Write-Verbose "Querying WMI Objects on $PC"

            $PercentComplete = 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying System info" -PercentComplete $PercentComplete
            $sysinfo = collect-systemInfo($PC)
            $PCinfo.PCName = ($PC)
            $PCinfo.Domain = ($sysinfo.domainorworkgroup)
            $PCinfo.Model = ($sysinfo.model)
            $PCinfo.Manufacturer = ($sysinfo.manufacturer)
        
            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying bios info" -PercentComplete 10
            $biosinfo = collect-biosInfo($PC)
            $PCinfo.Serial = $biosinfo.serial
            $PCinfo.BiosRevision = $biosinfo.biosRevision

            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying OS info" -PercentComplete $PercentComplete        
            $OSinfo = collect-OSInfo($PC)
            $PcInfo.OS = $OSinfo.OS
            $PCInfo.OSVersion = $OSinfo.OSVersion
            $PcInfo.Architecture = $OSinfo.Architecture
            $PCinfo.LastBootTime = $osInfo.LastBootTime.substring(0,4) + "." + $osInfo.LastBootTime.Substring(4,2) + "." + $osInfo.LastBootTime.Substring(6,2) + "." + $osInfo.LastBootTime.substring(8,4)
            $PcInfo.InstallDate = $osInfo.InstallDate.substring(0,4) + "." + $osInfo.InstallDate.Substring(4,2) + "." + $osInfo.InstallDate.Substring(6,2) + "." + $osInfo.InstallDate.substring(8,4)
            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying disk info" -PercentComplete $PercentComplete
            $PCinfo.Disks = collect-diskInfo($PC) 

            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying RAM info" -PercentComplete $PercentComplete
            $PCinfo.RAM = Get-WmiObject Win32_PhysicalMemory -computer $PC | select Capacity,Tag,Speed,BankLabel,DeviceLocator
		    $PCinfo.totalRAMinGB = ( ($PCinfo.RAM | Measure-Object 'Capacity' -Sum).Sum ) / 1GB
            $PCInfo.FreePhysicalMemory = $OSinfo.FreePhysicalMemory / 1MB
        
            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying network info" -PercentComplete $PercentComplete
            $PCinfo.NetworkInfo = Collect-NetConfig($PC)

            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying user account info" -PercentComplete $PercentComplete
            $PCinfo.users = Collect-UsersOfPC($PC)
            $PCinfo.admins = Collect-LocalAdminAccounts($PC)
        
            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying teamviewer info" -PercentComplete $PercentComplete
            $TVinfo = Collect-TVID($PC)
            $PCInfo.TeamViewerID = $TVinfo.ClientID
            $PCInfo.TeamViewerversion = $TVinfo.Version
            
            $PercentComplete += 10
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Querying LANDesk and IE version info" -PercentComplete $PercentComplete
            
            $PcInfo.LDversion = collect-LDversion($PC)
            $PCInfo.IEVersion = Collect-IEVersion($PC)
            $PCInfo.McafeeAgentVersion = Collect-McAgentVersion($PC)

            #To add: KMS query

     
            write-progress -status "Collecting information for $PC" -Activity "Collecting info on $PC" -CurrentOperation "Writing PC report info" -PercentComplete 100
            $PCreport += New-Object PSObject -Property $PCinfo
        }
                
    }
    
    $PCreport
}

#########################
## End Data collectors ##
########################################################################################







########################################################################################
## Begin data reformatting functions ##
#######################################


function ConvertUserList-ToString ($userList)
{
    [array]$users=$null
    ForEach ($user in $userList)
    {
        $userString = $user -split ","          #Breaks out the 'Name="Administrator",Domain="DOTANNISD103472"' section into two separate lines
        $userString[0] = $userString[0].TrimStart('Name=').TrimStart('"').TrimEnd('"')       # 'Name="Administrator"' becomes 'Administrator'
        $userString[1] = $userString[1].TrimStart('Domain=').TrimStart('"').TrimEnd('"')     # 'Domain="DotAnnIsd103472"' becomes 'DotAnnIsd103472' ; will get tricky if you combine both TrimStart()
        $users += ($userString[1] + '\' + $userString[0])
    }
    $users -join " ; `n" # Join all lines into one line with semi-colon delimiters
}

Function ConvertAdminList-ToString($adminList)
{
    [array]$adminUsers=$null
    ForEach ($admin in $adminList)
    {
        $userString=$admin -split ","
        $userString[1] = $userString[1].TrimStart('Name=').TrimStart('"').TrimEnd('"')
        If($userString[0] -like "UserAccount*") { $userString[0] = "User=" + $userString[0].substring(19).TrimStart('"').TrimEnd('"') }
        ElseIf($userString[0] -like "Group*")   { $userString[0] = "Group=" + $userString[0].substring(13).TrimStart('"').TrimEnd('"') }
        $AdminUsers += $userString -join '\'
    }

    $adminUsers -join ";`n"
}

function ConvertDiskInfo-ToString($disks)
{
        [array]$DiskStrings = $null
        ForEach ($disk in $disks)
        { 
            $DiskStrings += "Volume=" + $disk.DeviceID + " ; " + "LabelName=" + $disk.VolumeName + " ; " + "Size=" + ($disk.size).toString() + "GB ; " + "Freespace=" + ($disk.FreeSpace).toString() + "GB ; "
        }

        $DiskStrings -join " ; `n " 
}

Function ConvertIPinfo-ToString($nics)
{
        [array]$netinfo = $null
        ForEach ($nic in $nics)
        {
            $netinfo += "Name=" + $nic.name + "; MAC=" + $nic.mac + "; DHCP=" + $nic.dhcp + "; IP= " + $nic.IPAddress + ";"
        }
        $netinfo -join " ; `n "  #maybe should revise to two separate objects for wired and wireless, concat'ing wired if more than one?
}


# Wrapper function for 
function ConvertReport-ToStrings($Report)
{
    #Modify report
    foreach ($PCreport in $Report)
    {
        $PCreport.disks = ConvertDiskInfo-ToString($PCreport.disks)
        $PCreport.NetworkInfo = ConvertIPinfo-ToString($PCreport.NetworkInfo)
        $PCreport.users = ConvertUserList-ToString ($PCreport.users)
        $PCreport.admins = ConvertAdminList-ToString ($PCreport.admins)
        #RAMdimms-toString
    }
    
    $Report
}


#####################################
## End data reformatting functions ##
##################################################################################




#################################################################################
## Begin data send functions ##
###############################


function Write-Report($report,$filepath)
{
    if(!(test-path C:\IT-temp))
    {
        write-progress -status "No folder at C:\IT-temp, creating one now" -Activity "Collecting info on $PC"
        New-item C:\IT-temp\ -ItemType Directory
    }
    if(!(test-path C:\IT-temp))
    {
        write-progress -status "Unable to create folder; exiting"  -Activity "Collecting info on $PC"
        timeout /t 10        
    }
    else 
    { 
        write-progress -status "Writing $Report to $filepath" -Activity "Final steps"
        $report | Out-File $filepath 
    }

}

# Function to pre-format some fields for the report email and provide defaults
function Send-ReportEmail($attachment,$to,$from,$subject)
{
    $date = Get-Date -UFormat "%Y.%m.%d.%H%M" 
    
    #Define defaults for To,From,Subject
    if($to -eq $null) { $to = "Dot.Anc.Isd@alaska.gov" }
    if($from -eq $null) { $from = "NoReply-DotAncInventoryReports@alaska.gov" }
    if($subject -eq $null) { $subject = "Scripted report email for $attachment" }

    #Send mail message
    Send-MailMessage -Attachments $attachment -To $to -from $from -SmtpServer "smtpa.state.ak.us" -Subject $subject -Body "Scripted report email for $attachment"
}


#############################
## End data send functions ##
#################################################################################



#################################################################################
## Begin data final wrapper/helper functions ##
###############################################

#Helper function to ask user of this script what PC or file to query
function Ask-ForTargetPCs
{
    $target = Read-Host -Prompt "What computer do you want an inventory report on? No input will default to local PC. Alternatively, type ""File"" to use a txt list"
    if($target -like "") { $target = $env:COMPUTERNAME }
    elseif($target -like "File"){ $target = Get-Content (Read-Host -Prompt "Please input full filepath: ") }
    #Return the (list of) PC(s).
    $target
}

#Wrapper function for Collect-PCinfo; invokes Collect-PCinfo and then sends it to Send-ReportEmail
Function Get-PCinfo($PClist,[switch]$prompt,$file, $email,[switch]$raw)
{

   <#
        .Synopsis
            Get-PCInfo calls Collect-PCInfo to collect data about one or many computers, formats it, and optionally emails the report.

        .Description
            Get-PCInfo relies on Collect-PCInfo and its associated functions, Ask-ForTargetPCs
            
        .Parameter PClist
            A list of PCs; conflicts with $Prompt and $file

        .Parameter prompt
            Causes Get-PCinfo to prompt user for PC info with Ask-ForTargetPCs

        .Parameter file
            Uses Get-Content on the provided file argument. Will skip Prompt.

        .Parameter email
            Defines the email address to send to. If not provided, report will be output to the pipeline.

        .Parameter raw
            This optional switch returns raw powershell objects to the pipeline
            



        .Example
            Get-PCInfo -email "Ben.Newman@alaska.gov"
        
        .Example
            Get-PCInfo -raw
        
        .Example
            Get-PCInfo -PCList "DotAnnIsd103471"
        
        .Example
            Get-PCInfo -PCList (get-content .\listOfPCs.txt)
        
        .Example
            Get-PCInfo -file .\listOfPCs.txt


    #>

    $TempFolder = "C:\IT-temp" # Define temp folder
    if ($file -ne $null) { $PClist = Get-Content $file }
    elseif ($prompt) { $PClist = Ask-ForTargetPCs }
    if ($PClist -eq $null) {$PClist = $env:COMPUTERNAME } #If no PC defined, make the script target the local PC
    
    if ($PClist -isnot [system.array] ) { $ReportFileName = "InventoryReport-" + $PClist + "-" + (get-date -uformat "%Y.%m.%d.%H%M") + ".txt" }
    else { $ReportFileName = "InventoryReport-Multiple-" + (get-date -uformat "%Y.%m.%d.%H%M") + ".txt"}
    
    Write-Verbose "Creating report"
    Write-Progress -Activity "Collecting data" -Status "Initial steps" -PercentComplete 0
    $filePath = $tempFolder + "\" + $ReportFileName #Combine Report name with temp folder
    $rawreport = (Collect-PCinfo $PClist) #Report with all objects
    
    Write-Progress -Activity "Finalizing steps" -Status "Reformatting raw objects to strings"
    $FormattedReport = ConvertReport-ToStrings $rawreport #Report with many objects replaced with strings, to aid export. 

    if($raw) { $rawreport }
    elseif($email -eq $null) { $FormattedReport }
    
    
    if($email -ne $null)
    { 
        Write-Progress -Activity "Final steps" -Status "Writing report to $filepath and emailing to $email"
        Write-Report -report $FormattedReport -filepath $filepath     
        Send-ReportEmail -attachment $filepath -to $email -subject "Get-PCInfo.ps1 automated report; $ReportFileName" 
    }
    
}


#############################################
## End data final wrapper/helper functions ##
#################################################################################



#Below line of code in case you want to copy/paste and just run the script ; 
#Get-PCinfo -raw to get the raw report without emailing it

Get-PCinfo -prompt -email ben.newman@alaska.gov #____Put a new email address here!_____#