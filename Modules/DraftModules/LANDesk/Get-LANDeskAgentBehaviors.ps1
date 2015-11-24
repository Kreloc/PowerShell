Function Get-LANDeskAgentBehaviors
{
	<#	
		.SYNOPSIS
			Returns all of the agent behaviors on the connected LANDesk webservice. AgentBehavior Id number is used as input for scheduling patches
		
		.DESCRIPTION
			Returns all of the agent behaviors on the connected LANDesk webservice. Uses the GetAgentBehaviors method
			of the LANDesk Web Service object.

		.EXAMPLE
			Get-LANDeskAgentBehaviors
			
			Retruns an object with the name and ID of the Agent Behvaiors on the connected LANDesk webservice.

			
	#>
	[CmdletBinding()]
	param()
	Begin
	{
		If(!($LANDeskWebService))
		{
			Write-Error "Please run Connect-LANDeskServer. This function cannot be performed without an active connection to the LANDesk Web Service."
			Break
		}
	}
	Process 
	{
		Write-Verbose "Starting to loop through Agent Behaviors"
		$i = 0
		Do
		{
			Write-Verbose "Getting Agent Behaviors an int value of $($i)"
			$Behaviors = $LANDeskWebService.GetAgentBehaviors($i)
			$count = $Behaviors.count
			$i++
			Write-Verbose "Adding Agent Behaviors to array for further processing"
			[array]$AgentBehaviors += $Behaviors
		}
		Until($count -eq 0)
		Write-Verbose "Manipulating Agent Behaviors array to return single object with Name and ID"
		$Behaviors = ForEach($AgentBehavior in $AgentBehaviors)
		{
			$AgentBehavior.AgentBehaviors
		}
		$Behaviors
	}
	End{}
}