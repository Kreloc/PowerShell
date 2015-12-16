Function Move-ItemFound
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Filter,
		[Parameter(Mandatory=$True,
		ValueFromPipelinebyPropertyName=$true)]
		[string]$Destintation
                
	)
	Begin{}
	Process 
	{
        Get-ChildItem "*$($Filter)*" | Where-Object {$_.FullName -ne $_.Destination} |
        ForEach-Object {Move-Item -Path $_.FullName -Destination $Destintation}
	}
	End{}
}