#Initiates query job for threat logs

$url = "https://$($panRootAddress)/api/?type=log&log-type=threat&nlogs=1000&key=$($PaConnectionArray.APIKey)"
[xml]$ThreatLogResponse = $WebClient.DownloadString($url)
$ThreatLogResponse
$JobdID = $ThreatLogResponse.response.result.job

#Gets status of query job
$url = "https://$($panRootAddress)/api/?type=log&log-type=threat&action=get&jobid=$($JobdID)&key=$($PaConnectionArray.APIKey)"
Do
{
[xml]$JobResponse = $WebClient.DownloadString($url)
}
Until($JobResponse.response.result.job.status -eq "FIN")
$ThreatLogs = $JobResponse.response.result.log.logs.entry
$HighThreatLogs = $ThreatLogs | Where-Object {$_.Severity -eq "high"}

#Look up whois info for IP Addresses
$WhoISResponse = [xml]$WebClient.DownloadString("http://whois.arin.net/rest/ip/$($HighThreatLogs[5].src)")
$WhoIsName = $WhoISResponse.net.Name
$WhoIsOrginzationName = $WhoISResponse.net.orgRef.Name
$WhoIsRegistrationDate = Get-Date ($WhoISResponse.net.registrationDate)
$WHoIsComments = $WhoIsResponse.net.comment.line | ForEach-Object {$_.'#text'}
$WhoIsNetBlock = $WhoIsResponse.net.netBlocks.netBlock
$WhoIsStartAddress = $WhoISResponse.net.startAddress
$WhoIsEndAddress = $WhoISResponse.net.endAddress
$WhoIsInfo = New-Object -TypeName PSObject -Property @{Name=$WhoIsName;OrginizationName=$WhoIsOrginzationName;RegistrationDate=$WhoIsRegistrationDate;Comments=$WHoIsComments;NetBlock=$WhoIsNetBlock;StartAddress=$WhoIsStartAddress;EndAddress=$WhoIsEndAddress}
