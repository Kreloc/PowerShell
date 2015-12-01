Function Install-AdobeReaderDC 
{
	<#	
		.SYNOPSIS
			Install-AdobeReaderDC installs Adobe Reader DC onto a remote computer.
		
		.DESCRIPTION
			Install-AdobeReaderDC installs Adobe Reader DC onto a remote computer. Uses a msi file created by Administrator and placed in software share.
			Uses Win32_process class to iniate the msiexec process on remote computer.
		
		.PARAMETER ComputerName
			The name of the computer to install Adobe Reader DC onto.

		.PARAMETER Source
			The directory that conatains the msi installer for Adobe Reader DC

		.EXAMPLE
			Install-AdobeReaderDC "THATPC" -Source "C:\Installers\AdobeReaderDC"
			
			Installs AdobeReaderDC unto THATPC.
			
		.EXAMPLE
			Connect-LANDeskServer -LANDeskServer avjnu00
			Start-LANDeskQuery -QueryName "Preq Adobe Acrobat Reader DC Install" | Install-AdobeReaderDC -Source "C:\Installers\AdobeReaderDC"
		
			Runs a query against the LANDeskServer to return devices that need to have Adobe Reader DC installed
			and pipes the resulting computerNames to Install-AdobeReaderDC onto each computer.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName","Device Name")]
		[string]$ComputerName,
		[Parameter(Mandatory=$True,ValueFromPipelinebyPropertyName=$true)]
		[string]$Source

	)
	Begin
	{
		$AdobeReaderDCDirectory = $Source
		$AdobeMSI = $AdobeReaderDCDirectory + '\AcroRead.msi'
		$AdobeMSITransform = $AdobeReaderDCDirectory + '\AcroRead.mst'
	}
	Process 
	{
		$ErrorMessage = ""
		Write-Verbose "Pinging $ComputerName"
		If(test-connection -ComputerName $ComputerName -Count 1 -Quiet)
		{
			Write-Verbose "Initiating install process on remote computer"
			try 
			{
		  		$returnval = ([WMICLASS]"\\$ComputerName\ROOT\CIMV2:win32_process").Create("msiexec `/i $AdobeMSI TRANSFORMS=$AdobeMSITransform `/qn")
				Write-Verbose "Running install on remote computer"
		 	}
			catch
			{
		  		Write-error "Failed to trigger the installation. Review the error message"
		 		$ErrorMessage = $_
		 	}
			 $props = {InstallerRan=$True
			 			ErrorMessage=$ErrorMessage
						 ComputerName=$ComputerName
						 Online=$True
			 }
		}
		else
		{
			Write-Verbose "$ComputerName is offline"
			$props= {InstallerRan=$False
			 			ErrorMessage=$ErrorMessage
						 ComputerName=$ComputerName
						 Online=$False				
			}
		}
		Write-Verbose "Creating custom object of output"
		New-Object -TypeName PSObject -Property $props
	}
	End{}
}