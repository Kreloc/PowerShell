<#
.SYNOPSIS
    Use this script to create a slipstreamed package of Adobe Reader DC to use within Configuration Manager or any other product for distribution
.DESCRIPTION
    Use this script to create a slipstreamed package of Adobe Reader DC to use within Configuration Manager or any other product for distribution
.PARAMETER FileName
    Adobe Reader file name in the format of 'AcroRdrDCXXXXX_XX_XX.exe'
.PARAMETER DownloadFolder
    Location of the DownloadFolder where the Adobe Reader executable has been downloaded to
.PARAMETER TargetFolder
    Location of where the AIP folder will be created
.EXAMPLE
    .\New-AdobeReaderAIP.ps1 -FileName "AcroRdrDC11009_en_US.exe" -DownloadFolder "C:\AdobeReader\Downloads" -TargetFolder "C:\AdobeReader\AIP"
    Create an Adobe Reader 11.0.9 slipstreamed package by specifying the download folder to where the executable file is located in addition to the AIP location
    where the slipstreamed package files will be stored:
.NOTES
    Script name: New-AdobeReaderAIP.ps1
    Author:      Nickolaj Andersen
    Contact:     @NickolajA
    DateCreated: 2014-11-02
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
[parameter(Mandatory=$true,HelpMessage="Adobe Reader file name in the format of 'AcroRdrDCXXXXX_XX_XX.exe'")]
[string]$FileName,
[parameter(Mandatory=$true,HelpMessage="Location of the DownloadFolder where the Adobe Reader executable has been downloaded to")]
[ValidateScript({Test-Path -Path $_ -PathType Container})]
[string]$DownloadFolder,
[parameter(Mandatory=$true,HelpMessage="Location of where the AIP folder will be created")]
[ValidateScript({Test-Path -Path $_ -PathType Container})]
[string]$TargetFolder
)
Begin {
    # Check for installed version of Adobe Reader
    if ([System.Environment]::Is64BitOperatingSystem -eq $true) {
        Write-Verbose -Message "System environment is 64-bit"
        $UninstallKey = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        $AdobeReader = Get-ChildItem -Path $UninstallKey | ForEach-Object { Get-ItemProperty -Path $_.PSPath } | Where-Object { $_.DisplayName -like "*Adobe Reader*" }
        Write-Verbose -Message "Enumerating the Uninstall registry key for any Adobe Reader instances"
        if (($AdobeReader | Measure-Object).Count -ge 1) {
            Write-Warning -Message "Adobe Reader was detected on this system, please uninstall it before you continue" ; break
        }
    }
    else {
        Write-Verbose -Message "System environment is 32-bit"
        $UninstallKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
        Write-Verbose -Message "Enumerating the Uninstall registry key for any Adobe Reader instances"
        $AdobeReader = Get-ChildItem -Path $UninstallKey | ForEach-Object { Get-ItemProperty -Path $_.PSPath } | Where-Object { $_.DisplayName -like "*Adobe Reader*" }
        if (($AdobeReader | Measure-Object).Count -ge 1) {
            Write-Warning -Message "Adobe Reader was detected on this system, please uninstall it before you continue" ; break
        }    
    }
}
Process {
    Write-Verbose -Message "Extracting content from '$($FileName)' to '$($DownloadFolder)\AdobeReader'"
    # Extract the files from the executable
    $EArguments = @{
        "FilePath" = "$($DownloadFolder)\$($FileName)"
        "ArgumentList" = "-nos_o$($DownloadFolder)\AdobeReader -nos_ne"
        "Wait" = $true
        "NoNewWindow" = $true
    }
    Start-Process @EArguments
    if (Get-ChildItem -Path "$($DownloadFolder)\AdobeReader" -Filter "AcroRead.msi") {
        Write-Verbose -Message "Successfully extracted all files"
        Write-Verbose -Message "Starting to create the AIP at '$($TargetFolder)'"
        # Create the AIP
        $AIPArguments = @{
            "FilePath" = "msiexec.exe"
            "ArgumentList" = "/a $($DownloadFolder)\AdobeReader\AcroRead.msi /qb TARGETDIR=$($TargetFolder)"
            "Wait" = $true
            "PassThru" = $true
        }
        $AIPInstall = Start-Process @AIPArguments
        if ($AIPInstall.ExitCode -eq 0) {
            Write-Verbose -Message "Successfully created the AIP"
            # If any quaterly patches are found, apply them to the AIP
            $QPatches = Get-ChildItem -Path $DownloadFolder -Recurse -Filter "AcroRdrDCUpd*.msp" | Sort-Object -Property Name
            foreach ($QPatch in $QPatches) {
                $QPatchFilePath = $QPatch | Select-Object -ExpandProperty FullName
                if ($QPatch -match "AcroRdrDCUpd") {
                    Write-Verbose -Message "Found quarterly patch: '$($QPatch.Name)'"
                    Write-Verbose -Message "Applying quarterly patch: '$($QPatch.Name)'"
                    $QArguments = @{
                        "FilePath" = "msiexec.exe"
                        "ArgumentList" = "/a $($TargetFolder)\AcroRead.msi /qb /p $($QPatchFilePath) TARGETDIR=$($TargetFolder)"
                        "Wait" = $true
                        "PassThru" = $true                        
                    }
                    $QInstall = Start-Process @QArguments
                    if ($QInstall.ExitCode -eq 0) {
                        Write-Verbose -Message "Successfully applied quarterly patch: '$($QPatch)'"
                        # If any security patches are found, apply them to the AIP
                        $SPatches = Get-ChildItem -Path $DownloadFolder -Recurse -Filter "AcroRdrDCSecUpd*.msp" | Sort-Object -Property Name
                        foreach ($SPatch in $SPatches) {
                            $SPatchFilePath = $SPatch | Select-Object -ExpandProperty FullName
                            if ($SPatch -match "AcroRdrDCSecUpd") {
                                Write-Verbose -Message "Found security patch: '$($SPatch.Name)'"
                                Write-Verbose -Message "Applying security patch: '$($SPatch.Name)'"
                                $SArguments = @{
                                    "FilePath" = "msiexec.exe"
                                    "ArgumentList" = "/a $($TargetFolder)\AcroRead.msi /qb /p $($SPatchFilePath) TARGETDIR=$($TargetFolder)"
                                    "Wait" = $true
                                    "PassThru" = $true                                    
                                }
                                $SInstall = Start-Process @SArguments
                                if ($SInstall.ExitCode -eq 0) {
                                    Write-Verbose -Message "Successfully applied security patch: '$($SPatch.Name)'"
                                }
                                else {
                                    Write-Warning -Message "Failed to apply security patch, msiexec error code: $($QInstall.ExitCode)" ; break
                                }
                            }
                            else {
                                Write-Verbose -Message "Unable to locate any security patches"
                            }
                        }
                    }
                    else {
                        Write-Warning -Message "Failed to apply quarterly patch, msiexec error code: $($QInstall.ExitCode)" ; break
                    }
                }
                else {
                    Write-Verbose -Message "Unable to locate any quarterly patches"
                }
            }
        }
        else {
            Write-Warning -Message "Failed to create the AIP, msiexec error code: $($AIPInstall.ExitCode)" ; break
        }
    }
    else {
        Write-Warning -Message "Unable to locate AcroRead.msi after extraction"
    }
    if ($AIPInstall.ExitCode -eq 0) {
        Write-Verbose -Message "Successfully created a slipstreamed installer for Adobe Reader"
        Copy-Item "$($DownloadFolder)\AdobeReader\setup.ini" -Destination "$($TargetFolder)" -Force
    }
    else {
        Write-Warning -Message "An error occured during the slipstream process"
    }
}
End {
    # Clean the content that was extracted
    Remove-Item "$($DownloadFolder)\AdobeReader" -Recurse -Force -ErrorAction SilentlyContinue
}