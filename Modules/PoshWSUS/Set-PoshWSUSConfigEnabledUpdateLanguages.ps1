function Set-PoshWSUSConfigEnabledUpdateLanguages {
    <#
	.SYNOPSIS
		Sets whether the WSUS server downloads updates for all languages or for a subset of languages. 

	.DESCRIPTION 
       Collection of language codes to enable for updates. Language codes that are not included in the collection are disabled. 
       You must specify the language code strings in lowercase.

	.PARAMETER Language
		Enables updates for the specified languages.

	.PARAMETER  AllUpdateLanguagesEnabled
		Sets whether the WSUS server downloads updates for all languages or for a subset of languages.
        If $true, the WSUS server downloads updates for all languages. If $false, a call to Languages property
        is made to specify the languages supported by this WSUS server.

	.EXAMPLE
		Get-PoshWSUSConfigSupportedUpdateLanguages | where {$_ -in @( 'ru', 'en')} | Set-PoshWSUSConfigEnabledUpdateLanguages

	.EXAMPLE
		Set-PoshWSUSConfigEnabledUpdateLanguages -Language 'ru','en','uk'

	.EXAMPLE
        Set-PoshWSUSConfigEnabledUpdateLanguages -AllUpdateLanguagesEnabled

	.INPUTS
		System.Collections.Specialized.StringCollection

	.NOTES
		Name: Set-PoshWSUSConfigEnabledUpdateLanguages
        Author: Dubinsky Evgeny
        DateCreated: 1DEC2013

	.LINK
		http://msdn.microsoft.com/en-us/library/windows/desktop/microsoft.updateservices.administration.iupdateserverconfiguration.setenabledupdatelanguages(v=vs.85).aspx
    
    .LINK
	    http://msdn.microsoft.com/en-us/library/windows/desktop/microsoft.updateservices.administration.iupdateserverconfiguration.allupdatelanguagesenabled(v=vs.85).aspx    
    
    .LINK
		http://blog.itstuff.in.ua/?p=62#Set-PoshWSUSConfigEnabledUpdateLanguages

    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true,Position = 0)]$Language,
        [switch]$AllUpdateLanguagesEnabled
    )

    Begin
    {
        if(-NOT $wsus)
        {
            Write-Warning "Use Connect-PoshWSUSServer for establish connection with your Windows Update Server"
            Break
        }

        if($PSBoundParameters['Language'])
        {
            $objects = @()
            $config.AllUpdateLanguagesEnabled = $false
        }#endif
    }
    Process
    {
        if($PSBoundParameters['Language'])
        {
            [System.Collections.Specialized.StringCollection]$objects += $Language
        }#endif
    }
    End{
        if($PSBoundParameters['AllUpdateLanguagesEnabled'])
        {
            $config.AllUpdateLanguagesEnabled = $true
        }#endif
        If ($PSCmdlet.ShouldProcess($wsus.ServerName,'Set Update Languages')) {
            Write-Verbose "Setting Languages for wsus updates."
            if ($AllUpdateLanguagesEnabled -eq $false)
            {
                $config.SetEnabledUpdateLanguages($objects)            
            }#endif
            $config.Save()
        }
    }
}