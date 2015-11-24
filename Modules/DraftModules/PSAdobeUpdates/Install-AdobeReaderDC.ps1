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

		.EXAMPLE
			Install-AdobeReaderDC "THATPC"
			
			Installs AdobeReaderDC unto THATPC.
			
		.EXAMPLE
			Connect-LANDeskServer -LANDeskServer avjnu00
			Start-LANDeskQuery -QueryName "Preq Adobe Acrobat Reader DC Install" | Install-AdobeReaderDC
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName","Device Name")]
		[string]$ComputerName	
	)
	Begin
	{
		$AdobeReaderDCDirectory = "\\fsjnu\PCSoft\UserApps\Adobe\Reader\ReaderDC"
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