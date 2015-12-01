function Get-PoshWSUSConfigEnabledUpdateLanguages {
<#
	.SYNOPSIS
		Gets the language codes that are enabled on the WSUS server.

	.DESCRIPTION
		The collection contains a snapshot of the languages that are enabled at this time.

	.EXAMPLE
		Get-PoshWSUSConfigEnabledUpdateLanguages

	.OUTPUTS
		System.String

	.NOTES
		Name: Get-PoshWSUSConfigEnabledUpdateLanguages
        Author: Dubinsky Evgeny
        DateCreated: 1DEC2013
        Modified: 06 Feb 2014 -- Boe Prox
            -Removed instances where set actions are occuring

	.LINK
		http://blog.itstuff.in.ua/?p=62#Get-PoshWSUSConfigEnabledUpdateLanguages

	.LINK
		http://msdn.microsoft.com/en-us/library/windows/desktop/microsoft.updateservices.administration.iupdateserverconfiguration.getenabledupdatelanguages(v=vs.85).aspx
#>

    [CmdletBinding()]
    Param()

    Begin
    {
        if( -NOT $wsus)
        {
            Write-Warning "Use Connect-PoshWSUSServer for establish connection with your Windows Update Server"
            Break
        }
    }
    Process
    {
        Write-Verbose "Getting WSUS Enabled Update Languages."
        $config.GetEnabledUpdateLanguages()
    }
    End{}
}