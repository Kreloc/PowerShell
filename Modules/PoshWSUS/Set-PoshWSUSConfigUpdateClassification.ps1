function Set-PoshWSUSConfigUpdateClassification {

    <#
    .SYNOPSIS  
        Sets whether the classifications of updates that Windows Server Update Services (WSUS)
        synchronizes are enabled or disabled.
    
    .DESCRIPTION
        The Set-PoshWsusClassification cmdlet enables or disables the category of updates
        (for example security or critical) to be synchronized.

        Using this cmdlet without filtering results. Get-PoshWSUSUpdateClassification cmdlet must be run,
        then the results are piped it into this cmdlet.
    
        Using this cmdlet with filtered results. The Get-WsusClassification cmdlet must be run,
        then results are filtered using the Where-Object cmdlet and piped into this cmdlet.

    .PARAMETER Classification
        Specifies the classification of updates that are to be synchronized. If the Disable parameter is used,
        then this parameter specifies the classification of updates that are not to be synchronized. 
        This parameter value is piped from the Get-PoshWSUSUpdateClassification cmdlet.
    
    .PARAMETER Disable
        Specifies that updates are not to be synchronized for the specified classification.

    .NOTES  
        Name: Set-PoshWSUSConfigUpdateClassification
        Author: Dubinsky Evgeny
        DateCreated: 10MAY2013
        Modified 05 Feb 2014 -- Boe Prox
            -Changed aliases to expanded name
            -Added -WhatIf support
    
    .EXAMPLE
        Get-PoshWSUSUpdateClassification | Set-PoshWSUSConfigUpdateClassification
        
        Description
        -----------
        This command enable all classification, to sync with MS Windows Update.

    .EXAMPLE
        Get-PoshWSUSUpdateClassification | where {$_.Title -eq "Drivers" } | Set-PoshWSUSConfigUpdateClassification -Disable
        
        Description
        -----------
        This command will disable Drivers class from sync with MS Windows Update.
    
    .EXAMPLE
        Get-PoshWSUSUpdateClassification | where {$_.Title -in @( 'Critical Updates', 'Service Packs' )} | Set-PoshWSUSConfigUpdateClassification

        Description
        -----------
        This command will enable to sync with MS Windows Update Critical Updates and Service Packs.

    .LINK
        http://blog.itstuff.in.ua/?p=62#Set-PoshWSUSConfigUpdateClassification
    #>
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param
    (
        [Parameter(
            Mandatory = $True,
            Position = 0,
            ValueFromPipeline = $True)]
            [Microsoft.UpdateServices.Administration.UpdateClassificationCollection]$Classification,
        [Parameter()]
            [switch]$Disable
    )

    Begin
    {
        if(-NOT $wsus)
        {
            Write-Warning "Use Connect-PoshWSUSServer for establish connection with your Windows Update Server"
            Break
        }
        if($PSBoundParameters['Disable'])
        {
            $Collection = $wsus.GetSubscription().GetUpdateClassifications()
        }
        else 
        {
            $Collection = New-Object -TypeName Microsoft.UpdateServices.Administration.UpdateClassificationCollection
                
        }
        $Subscription = $wsus.GetSubscription()
    }
    Process
    { 
        foreach ($Class in $Classification)
        {    
            If ($PSCmdlet.ShouldProcess($class, 'Set Update Config Classification')) {        
                if($PSBoundParameters['Disable'])
                {
                    $ClassTitle = $Class.Title
                    if ($Collection.Title -notcontains $ClassTitle)
                    {
                        Write-Warning "Class $ClassTitle not enable."
                    }
                    else
                    {
                        $Classification | ForEach { 
                            $Collection.Remove($_) 
                        } 
                    }
                } 
                else
                {
                    $Collection.Add($class) | Out-Null 
                }
            }
        }
        
    }
    End
    {
        If ($PSCmdlet.ShouldProcess($wsus.ServerName, 'Set Update Config Classification')) {  
            $Subscription.SetUpdateClassifications($Collection)
            $Subscription.Save()
        }
    }
}