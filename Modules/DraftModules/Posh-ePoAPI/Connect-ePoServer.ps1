Function Connect-ePoServer 
{
	<#	
		.SYNOPSIS
			A brief description of the Connect-ePoServer function.
		
		.DESCRIPTION
			A detailed description of the Connect-ePoServer function.
		
		.PARAMETER ePOServer
			A description of the ComputerName parameter.

		.EXAMPLE
			Connect-ePoServer <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Import-CSV .\computers.csv | Connect-ePoServer
		
			Explanation of this example where computers.csv had ComputerName as a header.
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$False,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName")]
		[string]$ePOServer	= "https://mcafeeServerURL"
	)
	Begin
	{
		$OriginalWD = $PWD
		If(!(Test-Path C:\Scripts\ePoServer\temp))
		{
			New-Item -Path C:\Scripts\ePoserver\temp -ItemType Directory
		}
		Set-Location C:\Scripts\ePoserver\temp
		add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

		$global:epoServer = $ePOServer
		$Credentials = Get-Credential
		$epoUser= $Credentials.GetNetworkCredential().username
		$epoPassword=$Credentials.GetNetworkCredential().password
		$global:wc=new-object System.net.WebClient
		$wc.Credentials = New-Object System.Net.NetworkCredential -ArgumentList ($epouser,$epopassword)
	}
	Process 
	{
		$url = "$($epoServer)/remote/core.help?:output=xml"
		$wc.DownloadString($url) > .\ePoCommands.txt
		$tempCommandString = Get-Content .\ePoCommands.txt
		[xml]$global:ePoCommands = ($tempCommandString)[1..$tempCommandString.count]
		$ePoCommands.result.list.element
	}
	End{}
}