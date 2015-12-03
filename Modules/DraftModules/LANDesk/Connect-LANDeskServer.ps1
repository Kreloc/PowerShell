Function Connect-LANDeskServer
{
	<#	
		.SYNOPSIS
			Connects to the webservice of inputted LANDesk server.
		
		.DESCRIPTION
			Connects to the webservice of inputted LANDesk server. Creates a global variable for use in the PSLANDesk Module.
		
		.PARAMETER LANDeskServer
			The name of the LANDesk server to connect to.

		.EXAMPLE
			Connect-LANDeskServer -LANDeskServer "LDServer"
			
			Connects to the LDServer. It then verifies the rights you have on that server.		
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$LANDeskServer	
	)
	begin{}
	Process
	{
        Write-Verbose "Connecting to LANDesk"
		$global:LANDeskWebService = New-WebServiceProxy -uri http://$LANDeskServer/MBSDKService/MsgSDK.asmx?WSDL -UseDefaultCredential
		Write-Verbose "Resolving rights, this should come back True."
        $LANDeskWebService.ResolveScopeRights()	
	}
	end{}
}