Function Export-HTML
{
	
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)] 
        [string[]]$Object,
		[Parameter(position=1,Mandatory = $false)]
		$Path = "$env:userprofile\Documents"
	)
	BEGIN
	{
		$date = Get-Date -format "MMddhhmmss"
	}
	PROCESS
	{
		$fragment = $Object | ConvertTo-HTML -Fragment -PreContent '<div class="comp"><h2>Computer Information</h2>' -PostContent '</div>'| Out-String
		$innerHtml += $fragment
	}	
	END
	{
		$prehtml = '<html><head><title>Computer Report</title><style>body {background-color:WhiteSmoke;}h1, h2 {text-align:center;}.info{font:12px arial,sans-serif;color:DarkGreen;height:83%;width:83%;margin: auto;}.info table {border-collapse: collapse; margin:auto; }td, th {  width: 4rem;  height: 2rem;  border: 1px solid #ccc;  text-align: center;}.info h1 {text-align:center;}.info table th, td {color:ForestGreen;}.flag table td {color:red;}</style><body><div class="info">'
		$endhtml = '</div></body></html>'
		$prehtml + $innerHtml + $endhtml | Out-File "$Path\Report$date.htm"		
	}
}