Function Get-FolderPermissions
{
	[CmdletBinding()]
	Param
	(
	[Parameter(Mandatory=$True,Position=0)]
	[string]$path,
	[Parameter(Mandatory=$True,Position=1)]
	[string]$destpath
	) 
	PROCESS
	{
		$OrgPath = $PWD
		Set-Location $Path
		$result = Get-ChildItem | Where {$_.PSIsContainer -eq $True}
		ForEach ($dir in $result)
		{
			$acl = Get-Acl $dir.FullName
			$SecurityInfo = New-Object -TypeName -PSObject
			$SecurityInfo | Add-Member -MemberType NoteProperty -Name Folder -Value $dir.FullName
			ForEach ($res in $acl)
			{
				$SecurityInfo | Add-Member -MemberType NoteProperty -Name PermissionType -Value $res.Access
			}
			
		}
	} 	
	
	##Query a single folder / path / Share
$SingleFolder = "\\ServerName\Share"

##Query off a DFS Structure or Multiple Folders in a Share or Child Folder
#$PathList = Get-ChildItem -Directory -Path \\Domain\DFSRoot\FileSharesFolder

##Define Paths via CSV
#$PathList = Import-CSV "D:\Example.CSV"

#Output Directory for Report
Function Get-SharePermissions
{
		[CmdletBinding()]
    Param (
        [Parameter(position=0,Mandatory = $true,ValueFromPipeline =
        $true,ValueFromPipelinebyPropertyName=$true)] 
        $FullName,
        [Parameter(Mandatory = $false)]
        [switch]
        $Export
	)	
$PathList = New-Object PSObject -Property @{FullName = $FullName}
$ReportDropFolder = ("$env:USERPROFILE\Documents")

Foreach ($Path in $PathList)
{
	$dateTime = get-date -format ("yyyy-MM-dd-Thhmmss")
    Write-Progress $Path.FullName "Is Being Processed"
    $ReportOutput = @()
    $DirList = @()
    $DirList = (Get-ChildItem -WarningAction SilentlyContinue -Directory -Path $Path.FullName -Recurse).FullName
    $DirList += $Path.FullName

    Foreach ($Dir in $DirList)
    {
        $GetFolderACL = $Null
        $GetFolderACL = (Get-Acl $Dir).Access | Where-Object {$_.IsInherited -EQ 0 -and $_.InheritanceFlags -ne "None"}
        If ($GetFolderACL.Count -GE 1)
        {
            $ProtectedFolder = $False
            $ProtectedFolder = (Get-Acl $Dir).AreAccessRulesProtected
            ForEach ($ACL in $GetFolderACL)
            {
                #Comment out line 36, 37, and 41 if you do not want dependence on the ActiveDirectory Module
                $ADObjectName = $ACL.IdentityReference.Value.Substring(8)
                $ADobjectType = (Get-ADObject -Filter {SamAccountName -eq $ADobjectName}).ObjectClass
                $r = New-Object -TypeName PSObject
                $r | Add-Member -MemberType NoteProperty -Name Path -Value $Dir
                $r | Add-Member -MemberType NoteProperty -Name Identity -Value $ACL.IdentityReference
                $r | Add-Member -MemberType NoteProperty -Name IdentityType -Value $ADObjectType
                $r | Add-Member -MemberType NoteProperty -Name Rights -Value $ACL.FileSystemRights
                $r | Add-Member -MemberType NoteProperty -Name InheritanceFlags -Value $ACL.InheritanceFlags
                $r | Add-Member -MemberType NoteProperty -Name Propagation -Value $ACL.PropagationFlags
                $r | Add-Member -MemberType NoteProperty -Name Protected -Value $ProtectedFolder
                $ReportOutput += $r
            }
        }
    }
	$ReportOutput
	If($Export)
	{
    	$ReportName = ($Path.FullName.Split("\") | Select -Last 1) + ("-FolderRightsReport-") + ($dateTime) + (".csv")
    	$ReportOutput | Export-CSV $ReportDropFolder\$ReportName -NoTypeInformation
	}
}
}