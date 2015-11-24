Function Get-InnerText
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string]$Link			
	)
    PROCESS
    {
        $WebPage = Invoke-WebRequest "$Link"
        $Page = $webpage.ParsedHtml.body.OuterText
        $PageObject = New-Object -TypeName PSOBject -Property @{
            'Description' = $Page
            'Link' = $Link
        }
            $PageObject 
    }   
}
#This is designed as a helper function for scraping websites.