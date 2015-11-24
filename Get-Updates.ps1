function Get-Updates
{
	[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)][String] 
        $ComputerName
	)
	PROCESS
	{
	[System.Reflection.Assembly]::LoadWithPartialName(‘Microsoft.Update.Session‘) | Out-Null
    $Session = [activator]::CreateInstance([type]::GetTypeFromProgID(“Microsoft.Update.Session“,$ComputerName))
    $Searcher = $Session.CreateUpdateSearcher()
    $historyCount = $Searcher.GetTotalHistoryCount()
    $Searcher.QueryHistory(0, $historyCount) | Select-Object Date,
    @{name="Operation"; expression={switch($_.operation){
    1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}},
    @{name="Status"; expression={switch($_.resultcode){
	1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};
	4 {"Failed"}; 5 {"Aborted"}
	}}}, Title,@{name="KB"; expression={(($_.title -split ".*\(") -replace "\)*","")[1]}},@{name="PC";expression={$ComputerName}}
	}
}