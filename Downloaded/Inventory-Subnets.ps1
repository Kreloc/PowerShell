<#
.SYNOPSIS
   Get inventory data for all Windows Computers on a range of subnets
.DESCRIPTION
   Get inventory data for all Windows Computers on a range of subnets, export results to CSV file, including errors encountered
.PARAMETER Site
   The name of the site you are inventorying. The sitename is appended to the OutputPath to ensure the inventory site is documented.
.PARAMETER OutputPath
   The base output path for the inventory CSV file. This path is the root, which will contain a folder for the site. Inside of the Site folder will be the completed inventory CSV for the site.
.PARAMETER Subnets
   The path to a list of subnets to inventory, enter the subnets in the format of 192.168.1. , one per line in a .txt file, DO NOT include the final Octet of the ip address.
.PARAMETER DomainUser
   The domain username to use to inventory computers, this username must be in the form of Domain\User. This domain user account must have sufficient priveledges to perform WMI querries and run systeminfo.exe on the Computers to be inventoried.
.PARAMETER Password
   The password associated with the domain user account entered for DomainUser. 
.PARAMETER LocalAdministratorPassword
   The password associated with the local computer Administrator user account that might be found on computers on the subnets being inventoried(Incase the computer doesnt have the domain support group listed in its local administrators group).
.PARAMETER LocalAdminPassword
   The password associated with the local computer Admin user account that might be found on computers on the subnets being inventoried(Incase the computer doesnt have the domain support group listed in its local administrators group).
.EXAMPLE
    PS > &.\Inventory-Subnets.ps1 -Site SOFL1 -OutputPath C:\inventory -Subnets c:\networkdocumentation\SOFL1\Subnets.txt -DomainUser Domain\User -Password YourPassword

   This will inventory all subnets included in the text file c:\networkdocumentation\SOFL1\Subnets.txt. Outputting the results to C:\Inventory\SOFL1\SOFL1 - CompletedInventory.csv
.EXAMPLE
    PS > $job = start-job -scriptblock {&$env:Myscripts\Inventory-Subnets.ps1 -Site SOFL1 -OutputPath C:\inventory -Subnets c:\networkdocumentation\SOFL1\Subnets.txt -DomainUser Domain\User -Password YourPassword}

   This will inventory all subnets included in the text file c:\networkdocumentation\SOFL1\Subnets.txt. Outputting the results to C:\Inventory\SOFL1\SOFL1 - CompletedInventory.csv as a background job saved to the $job variable.
   You can then check the status via $job.state, or continually via something like: 
        While($job.state -like "Running"){get-job | receive-job -keep;sleep(10)}
    Or you can simply use:
        $job | wait-job | receive-job 
    to wait for the job to complete and then receive the results, if you dont need to use the shell for anything else while the job is running.
    
    ####################################################################################################
    !!!Best time to scan for inventory is friday mornings at 9am, that is when most employees are in!!!
    ####################################################################################################
#>

        [CmdletBinding()]
        [OutputType([PSObject[]])]
        Param
        (
            [Parameter(Mandatory=$true)]
            [string]
            $Site,
            [Parameter(Mandatory=$true)]
            [string]
            $outputPath,
            [Parameter(Mandatory=$true)]
            $subnets,
            [Parameter(Mandatory=$true)]
            [string]
            $DomainUser,
            [Parameter(Mandatory=$true)]
            [string]
            $Password,
            [Parameter(Mandatory=$true)]
            [string]
            $LocalAdministratorPassword,
            [Parameter(Mandatory=$true)]
            [string]
            $LocalAdminPassword,
            [Parameter(Mandatory=$false)]
            [int]
            $Threads=25
        )

    function inventory-subnets
        {
            [CmdletBinding()]
            [OutputType([PSObject[]])]
            Param
            (
                [Parameter(Mandatory=$true)]
                [string]
                $Site,
                [Parameter(Mandatory=$true)]
                [string]
                $outputPath,
                [Parameter(Mandatory=$true)]
                $subnets,
                [Parameter(Mandatory=$true)]
                $DomainUser,
                [Parameter(Mandatory=$true)]
                [string]
                $Password,
                [Parameter(Mandatory=$true)]
                [string]
                $LocalAdministratorPassword,
                [Parameter(Mandatory=$true)]
                [string]
                $LocalAdminPassword,
                [Parameter(Mandatory=$false)]
                [int]
                $Threads=25
            )
 
            begin {
                $secstr = New-Object -TypeName System.Security.SecureString
                $Password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
                $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $DomainUser, $secstr
                
                $header = 'Hostname','OSName','OSVersion','OSManufacturer','OSConfig','Buildtype',`
                'Registered Owner','Registered Organization','ProductID','InstallDate','StartTime','Manufacturer',`
                'Model','Type','Processor','BIOSVersion','WindowsFolder','SystemFolder','StartDevice','Culture',`
                'UICulture','TimeZone','PhysicalMemory','AvailablePhysicalMemory','MaxVirtualMemory',`
                'AvailableVirtualMemory','UsedVirtualMemory','PagingFile','Domain','LogonServer','Hotfix',`
                'NetworkAdapter'
                
                $potentialhosts = $subnets | foreach {for($i =2; $i -lt 255;$i++){"$_"+"$i"}}
                $computers = $potentialhosts
                
                $compscomplete = @()
                
                mkdir "$outputpath\$Site" -ErrorAction SilentlyContinue
                
                $hash = [ordered]@{            
                        Hostname         = $null                 
                        User             = $null           
                        Manufacturer     = $null           
                        Model            = $null            
                        Serial           = $null  
                        OS               = $null
                        PhysicalMemory   = $null
                        Processor        = $null
                        HDD              = $null
                        ReplyFrom        = $null
                        Error            = $null
                        }
                $csvheader = New-Object -TypeName psobject -Property $hash 
                $csvheader | Export-Csv -Path "$outputPath\$Site\$Site - CompletedInventory.csv" -NoTypeInformation -Force
            }
        
            process {
                foreach($computername in $computers){
                    While ($(Get-Job -state Running).Count -ge $Threads) {
                        Start-Sleep -Milliseconds 500
                    }
                    start-job -ScriptBlock {
                        Param($computername, $cred, $DomainUser, $Password, $header, $LocalAdminPassword, $LocalAdministratorPassword, $outputpath, $site)
                        $ErrorActionPreference='Stop'
                        if(Test-Connection -Quiet -Count 1 -ComputerName $computername){
                            $hostname = $computername
                            $user= 'No User'
                            try {
                                $discoveredhost =  Get-WmiObject -class win32_computersystem -Property  username, __SERVER -ComputerName $computername -Credential $cred -ErrorAction stop
                                $hdd = Get-WmiObject -class win32_logicaldisk -Filter "DriveType='3'" -ComputerName $computername -Credential $cred -ErrorAction stop | Select-Object -Property DeviceID, Freespace, Size | ft -AutoSize
                                $serial = Get-WmiObject -class win32_bios -ComputerName $computername -Credential $cred -ErrorAction stop| Select-Object -ExpandProperty 'Serial*'                        
                                $hostname = $discoveredhost| Select-Object -ExpandProperty __SERVER
                                $user = $discoveredhost | Select-Object -ExpandProperty username      
                                $object = &systeminfo /S $hostname /U $DomainUser /P $Password /fo csv | Select-Object -Skip 1 | ConvertFrom-CSV -Header $header
                                
                                $hash = [ordered]@{            
                                Hostname         = $object.HostName                 
                                User             = $User           
                                Manufacturer     = $object.Manufacturer          
                                Model            = $object.Model           
                                Serial           = $serial  
                                OS               = ($object.'OSName' + " " +$object.'OSVersion')
                                PhysicalMemory   = $Object.PhysicalMemory
                                Processor        = $object.Processor
                                HDD              = $(($hdd | out-string).TrimStart().TrimEnd())
                                ReplyFrom        = $computername
                                Error            = $error[0]
                                }
                                $object | Add-Member -NotePropertyMembers $hash -ErrorAction SilentlyContinue

                                $compscomplete += $object
                                $object | Select-Object 'HostName', 'User', 'Manufacturer', 'Model',  'Serial', 'OS' , 'PhysicalMemory', 'Processor', 'HDD', 'ReplyFrom', 'Error'  | Export-Csv -path "$outputPath\$Site\$Site - CompletedInventory.csv" -NoTypeInformation -Force -Append
                                write-output $object
                            }
                            Catch [System.UnauthorizedAccessException] {
                                try {
                                    $ALTPassword = $LocalAdministratorPassword
                                    $ALTsecstr = New-Object -TypeName System.Security.SecureString
                                    $ALTPassword.ToCharArray() | ForEach-Object {$ALTsecstr.AppendChar($_)}
                                    $ALTcred = new-object -typename System.Management.Automation.PSCredential -argumentlist 'administrator', $ALTsecstr
                                    
                                    $discoveredhost =  Get-WmiObject -class win32_computersystem -Property  username, __SERVER -ComputerName $computername -Credential $ALTcred -ErrorAction stop
                                    $hdd = Get-WmiObject -class win32_logicaldisk -Filter "DriveType='3'" -ComputerName $computername -Credential $ALTcred -ErrorAction stop | select -Property DeviceID, Freespace, Size | ft -AutoSize
                                    $serial = Get-WmiObject -class win32_bios -ComputerName $computername -Credential $ALTcred -ErrorAction stop| Select-Object -ExpandProperty 'Serial*'                       
                                    $hostname = $discoveredhost| Select-Object -ExpandProperty __SERVER
                                    $user = $discoveredhost | Select-Object -ExpandProperty username      
                                    $object = &systeminfo /S $hostname /U Administrator /P $LocalAdministratorPassword /fo csv | Select-Object -Skip 1 | ConvertFrom-CSV -Header $header
                                    
                                    $hash = [ordered]@{            
                                    Hostname         = $object.HostName                 
                                    User             = $User           
                                    Manufacturer     = $object.Manufacturer          
                                    Model            = $object.Model           
                                    Serial           = $serial  
                                    OS               = ($object.'OSName' + " " +$object.'OSVersion')
                                    PhysicalMemory   = $Object.PhysicalMemory
                                    Processor        = $object.Processor
                                    HDD              = $(($hdd | out-string).TrimStart().TrimEnd())
                                    ReplyFrom        = $computername
                                    Error            = $error[0]
                                    }
                                    $object | Add-Member -NotePropertyMembers $hash -ErrorAction SilentlyContinue                                  
                                    
                                    $compscomplete += $object
                                    $object | Select-Object 'HostName', 'User', 'Manufacturer', 'Model',  'Serial', 'OS' , 'PhysicalMemory', 'Processor', 'HDD', 'ReplyFrom', 'Error'  | Export-Csv -path "$outputPath\$Site\$Site - CompletedInventory.csv" -NoTypeInformation -Force -Append
                                    write-output $object
                                    }
                                Catch [System.UnauthorizedAccessException] {
                                    $ALTPassword = $LocalAdminPassword
                                    $ALTsecstr = New-Object -TypeName System.Security.SecureString
                                    $ALTPassword.ToCharArray() | ForEach-Object {$ALTsecstr.AppendChar($_)}
                                    $ALTcred = new-object -typename System.Management.Automation.PSCredential -argumentlist 'admin', $ALTsecstr
                                    
                                    $discoveredhost =  Get-WmiObject -class win32_computersystem -Property  username, __SERVER -ComputerName $computername -Credential $ALTcred -ErrorAction stop
                                    $hdd = Get-WmiObject -class win32_logicaldisk -Filter "DriveType='3'" -ComputerName $computername -Credential $ALTcred -ErrorAction stop | Select-Object -Property DeviceID, Freespace, Size | ft -AutoSize
                                    $serial = Get-WmiObject -class win32_bios -ComputerName $computername -Credential $ALTcred -ErrorAction stop| Select-Object -ExpandProperty 'Serial*'                        
                                    $hostname = $discoveredhost| Select-Object -ExpandProperty __SERVER
                                    $user = $discoveredhost | Select-Object -ExpandProperty username      
                                    $object = &systeminfo /S $hostname /U Administrator /P $LocalAdminPassword /fo csv | Select-Object -Skip 1 | ConvertFrom-CSV -Header $header
                                    
                                    $hash = [ordered]@{            
                                    Hostname         = $object.HostName                 
                                    User             = $User           
                                    Manufacturer     = $object.Manufacturer          
                                    Model            = $object.Model           
                                    Serial           = $serial  
                                    OS               = ($object.'OSName' + " " +$object.'OSVersion')
                                    PhysicalMemory   = $Object.PhysicalMemory
                                    Processor        = $object.Processor
                                    HDD              = $(($hdd | out-string).TrimStart().TrimEnd())
                                    ReplyFrom        = $computername
                                    Error            = $error[0]
                                    }
                                    $object | Add-Member -NotePropertyMembers $hash -ErrorAction SilentlyContinue
                                    
                                    $compscomplete += $object
                                    $object | Select-Object 'HostName', 'User', 'Manufacturer', 'Model',  'Serial', 'OS' , 'PhysicalMemory', 'Processor', 'HDD', 'ReplyFrom', 'Error'  | Export-Csv -path "$outputPath\$Site\$Site - CompletedInventory.csv" -NoTypeInformation -Force -Append
                                    write-output $object
                                    }
                                }     
                            Catch {
                                Write-Verbose "Some other Error, $error"
                                $error | % {$ErrorMessage = $_}
                                Write-verbose "Unable to inventory: $computername, $ErrorMessage"
                                $object = New-Object -TypeName psobject
                                Add-Member -InputObject $object -MemberType NoteProperty  -Name ReplyFrom -Value "$computername"
                                Add-Member -InputObject $object -MemberType NoteProperty -Name Error -Value "$error"
                                $compscomplete += $object
                                $object | Select-Object 'ReplyFrom', 'Error'  | Export-Csv -path "$outputPath\$Site\$Site - CompletedInventory.csv" -NoTypeInformation -Force -Append
                                write-output $object
                            }
                        return $object
                        }
                        Else {
                            write-verbose "Pinging $computername, No response."
                        }
                    } -ArgumentList $computername, $cred, $DomainUser, $Password, $header, $LocalAdminPassword, $LocalAdministratorPassword, $outputpath, $site
                }
            }

            end {
            }
        }

. Inventory-Subnets -site $Site -outputPath $outputPath -subnets (Get-Content -Path $subnets) -DomainUser $DomainUser -Password $Password -LocalAdminPassword $LocalAdminPassword -LocalAdministratorPassword $LocalAdministratorPassword -Threads $Threads

Write-Output 'Receiving Inventory Results!'
$compscompleted = get-job | wait-job -Timeout 900 -ErrorAction Continue -ErrorVariable $joberrors | Receive-Job
$compscompleted | Select-Object 'HostName', 'User', 'Manufacturer', 'Model',  'Serial', 'OS' , 'PhysicalMemory', 'Processor', 'HDD', 'ReplyFrom', 'Error'  | Export-Csv -path "$outputPath\$Site\$Site - CompletedInventory - finished.csv" -NoTypeInformation -Force -Append
Write-Output 'Inventory Complete!'
Write-Output "Results located at $outputPath\$site\"