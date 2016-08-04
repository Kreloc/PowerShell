
#Script Browser Begin
#Version: 1.3.2
Add-Type -Path 'C:\Program Files (x86)\Microsoft Corporation\Microsoft Script Browser\System.Windows.Interactivity.dll'
Add-Type -Path 'C:\Program Files (x86)\Microsoft Corporation\Microsoft Script Browser\ScriptBrowser.dll'
Add-Type -Path 'C:\Program Files (x86)\Microsoft Corporation\Microsoft Script Browser\BestPractices.dll'
$scriptBrowser = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Script Browser', [ScriptExplorer.Views.MainView], $true)
$scriptAnalyzer = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Script Analyzer', [BestPractices.Views.BestPracticesView], $true)
$psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $scriptBrowser
#Script Browser End

###Region Profile Internal Functions
function Export-ISEState
{
<#
.SYNOPSIS
    Stores the opened files in a serialized xml so that later the same set can be opened
 
.DESCRIPTION
    Creates an xml file with all PowerShell tabs and file information
   
.PARAMETER fileName
    The name of the project to create a new version from. This will also be the name of the new project, but with a different version
 
.EXAMPLE
    Stores current state into c:\temp\files.isexml
    Export-ISEState c:\temp\files.isexml
#>
 
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$fileName
    )
   
    # We are exporting a "tree" worth of information like this:
    #
    #  SelectedTabDisplayName: PowerShellTab 1
    #  SelectedFilePath: c:\temp\a.ps1
    #  TabInformation:
    #      PowerShellTab 1:
    #           File 1:
    #                FullPath:     c:\temp\a.ps1
    #                FileContents: $null
    #           File 2:
    #                FullPath:     Untitled.ps1
    #                FileContents: $a=0...
    #       PowerShellTab 2:
    #       ...
    #  Hashtables and arraylists serialize rather well with export-clixml
    #  We will keep the list of PowerShellTabs in one ArrayList and the list of files
    #  and contents(for untitled files) inside each tab in a couple of ArrayList.
    #  We will use Hashtables to group the information.
    $tabs=new-object collections.arraylist
   
    # before getting file information, save all untitled files to make sure their latest
    # text is on disk
    Save-AllISEFiles
 
    foreach ($tab in $psISE.PowerShellTabs)
    {
        $files=new-object collections.arraylist
        $filesContents=new-object collections.arraylist
        foreach($file in $tab.Files)
        {
            # $null = will avoid $files.Add from showing in the output
            $null = $files.Add($file.FullPath)
           
            if($file.IsUntitled)
            {
                # untitled files are not yet on disk so we will save the file contents inside the xml
                # export-clixml performs the appropriate escaping for the contents to be inside the xml
                $null = $filesContents.Add($file.Editor.Text)
            }
            else
            {
                # titled files get their content from disk
                $null = $filesContents.Add($null)  
            }
        }
        $simpleTab=new-object collections.hashtable
       
        # The DisplayName of a PowerShellTab can only be change with scripting
        # we want to maintain the chosen name       
        $simpleTab["DisplayName"]=$tab.DisplayName
       
        # $files and $filesContents is the information gathered in the foreach $file above
        $simpleTab["Files"]=$files
        $simpleTab["FilesContents"]=$filesContents
       
        # add to the list of tabs
        $null = $tabs.Add($simpleTab)
       
    }
   
    # tabsToSerialize will be a hashtable with all the information we want
    # it is the "root" of the information to be serialized in the hashtable we store...
    $tabToSerialize=new-object collections.hashtable
   
    # the $tabs information gathered in the foreach $tab above...
    $tabToSerialize["TabInformation"] = $tabs
   
    # ...and the selected tab and file.
    $tabToSerialize["SelectedTabDisplayName"] = $psISE.CurrentPowerShellTab.DisplayName
    $tabToSerialize["SelectedFilePath"] = $psISE.CurrentFile.FullPath
   
    # now we just export it to $fileName
    $tabToSerialize | export-clixml -path $fileName
}
 
 
function Import-ISEState
{
<#
.SYNOPSIS
    Reads a file with ISE state information about which files to open and opens them
 
.DESCRIPTION
    Reads a file created by Export-ISEState with the PowerShell tabs and files to open
   
.PARAMETER fileName
    The name of the file created with Export-ISEState
 
.EXAMPLE
    Restores current state from c:\temp\files.isexml
    Import-ISEState c:\temp\files.isexml
#>
 
    Param
    (
        [Parameter(Position=0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$fileName
    )
   
   
    # currentTabs is used to keep track of the tabs currently opened.
    # If "PowerShellTab 1" is opened and $fileName contains files for it, we
    # want to open them in "PowerShellTab 1"
    $currentTabs=new-object collections.hashtable
    foreach ($tab in $psISE.PowerShellTabs)
    {
        $currentTabs[$tab.DisplayName]=$tab
    }
   
    $tabs=import-cliXml -path $fileName
 
    # those will keep track of selected tab and files   
    $selectedTab=$null
    $selectedFile=$null
 
    foreach ($tab in $tabs.TabInformation)
    {
        $newTab=$currentTabs[$tab.DisplayName]
        if($newTab -eq $null)
        {
            $newTab=$psISE.PowerShellTabs.Add()
            $newTab.DisplayName=$tab.DisplayName
        }
        #newTab now has a brand new or a previouslly existing PowerShell tab with the same name as the one in the file
       
        # if the tab is the selected tab save it for later selection
        if($newTab.DisplayName -eq $tabs.SelectedTabDisplayName)
        {
            $selectedTab=$newTab
        }
       
        # currentUntitledFileContents keeps track of the contents for untitled files
        # if you already have the content in one of your untitled files
        # there is no reason to add the same content again
        # this will make sure calling import-ISEState multiple times
        # does not keep on adding untitled files
        $currentUntitledFileContents=new-object collections.hashtable
        foreach ($newTabFile in $newTab.Files)
        {
            if($newTabFile.IsUntitled)
            {
                $currentUntitledFileContents[$newTabFile.Editor.Text]=$newTabFile
            }
        }
       
        # since we will want both file and fileContents we need to use a for instead of a foreach
        for($i=0;$i -lt $tab.Files.Count;$i++)
        {
            $file = $tab.Files[$i]
            $fileContents = $tab.FilesContents[$i]
 
            #fileContents will be $null for titled files
            if($fileContents -eq $null)
            {
                # the overload of Add taking one string opens the file identified by the string
                $newFile = $newTab.Files.Add($file)
            }
            else # the file is untitled
            {
                #see if the content is already present in $newTab
                $newFile=$currentUntitledFileContents[$fileContents]
               
                if($newFile -eq $null)
                {
                    # the overload of Add taking no arguments creates a new untitled file
                    # The number for untitled files is determined by the application so we
                    # don't try to keep the untitled number, we just create a new untitled.
                    $newFile = $newTab.Files.Add()
               
                    # and here we restore the contents
                    $newFile.Editor.Text=$fileContents
                }
            }
       
            # if the file is the selected file in the selected tab save it for later selection   
            if(($selectedTab -eq $newTab) -and ($tabs.SelectedFilePath -eq $file))
            {
                $selectedFile = $newFile
            }
        }
    }
   
    #finally we selected the PowerShellTab that was selected and the file that was selected on it.
    $psISE.PowerShellTabs.SetSelectedPowerShellTab($selectedTab)
    if($selectedFile -ne $null)
    {
        $selectedTab.Files.SetSelectedFile($selectedFile)
    }
}

### End Region Profile Functions


#Add own SubMenu
$MyMenu = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("MyTools", $null, $null)
#Add function help and Cmdlet Binding
 $text = @'
 Function [function]
 {
	<#	
		.SYNOPSIS
			A brief description of the [function] function.
		
		.DESCRIPTION
			A detailed description of the [function] function.
		
		.PARAMETER ComputerName
			A description of the ComputerName parameter.
		
		.EXAMPLE
			[function] <ComputerName>
			
			Explanation of this example
			
		.EXAMPLE
			Get-Content computers.txt | [function]
		
			Explanation of this example.

        .INPUTS
            Input a string or an array of strings.

        .OUTPUTS
            Produces a DateTime object
            
        .NOTES
            Advanced function template

        .LINK
            https://github.com/Kreloc
			
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[string[]]$ComputerName	
	)
    retrun
    #Instruction for supporting WhatIf
    #Change to [CmdletBinding(SupportsShouldProcess=$true)]
    #Add this If statement block around each piece of code that would change something or produce output
    #unless it is using Cmdlets that already support WhatIf, those will inherit it down when -WhatIf is used in the function.
    <#
    If($PSCmdlet.ShouldProcess("$ComputerName","Attempting to do stuff"))
    {
        "Do Stuff"
    }
    #>
    Begin{}
    Process{}
    End{}
}
'@
$action = {
    $psise.CurrentFile.Editor.InsertText("$text")
    #jump cursor to the end
    $psise.CurrentFile.editor.SetCaretPosition($psise.CurrentFile.Editor.CaretLine,$psise.CurrentFile.Editor.CaretColumn)
}
 
#add the action to the Add-Ons menu
$MyMenu.Submenus.Add("Insert Advanced Function Snippet",$Action,"Alt+N" ) | Out-Null
#End Insert Advanced function SubMenu

#Begin Save-All function SubMenu
$action = {
$psise.CurrentPowerShellTab.Files.Where({-Not $_.isSaved -AND -Not $_.IsUntitled}).Foreach({$_.save()})
}
$MyMenu.Submenus.Add("Save all unsaved files", $action, "Ctrl+Alt+S") | Out-Null
#End Save-All function
#Begin load PowerShell Console Profile
$action = {
$path = "$($profile.CurrentUserCurrentHost)" -replace "ISE"
.$path
}
$MyMenu.Submenus.Add("Load User PS Profile",$Action,"Alt+P" ) | Out-Null
#End load user PowerShell profile
#Begin check spelling
#$action = {
#$words = $psISE.CurrentFile.Editor.Text -split " "
#}
##  [xml]$xaml = @"
## <Window 
##     xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
##     xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
##     x:Name="Window" Title="Initial Window" WindowStartupLocation = "CenterScreen" ResizeMode="NoResize"
##     SizeToContent = "WidthAndHeight" ShowInTaskbar = "True" Background = "lightgray"> 
##     <StackPanel >  
##         <Label Content='Type in this textbox' />
##         <TextBox x:Name="Content" Height = "50" Text="$text" SpellCheck.IsEnabled="True"/>  
##         <Button x:Name = "button1" Height = "75" Width = "75" Content = 'OK' Background="Yellow" />
##     </StackPanel>
## ## </Window>
## "@ 
##  
## $reader=(New-Object System.Xml.XmlNodeReader $xaml)
## $Window=[Windows.Markup.XamlReader]::Load( $reader )
## $txtBox = $Window.FindName('Content')
## $button1 = $Window.FindName('button1')
## $button1.Add_Click({
##     $newText = $txtBox.Text
## })
## 
## $Window.ShowDialog() | Out-Null
#End check spelling
#Comment out selected text
$action = {
$text = $psISE.CurrentFile.editor.selectedText
$psISE.CurrentFile.Editor.InsertText( [regex]::Replace($text, '^', '##', 'Multiline'))
}
$MyMenu.Submenus.Add("Comment Code",$Action,"Alt+3" ) | Out-Null
#End Comment selected text
#Uncomment selected text
$action = {
$text = $psISE.CurrentFile.editor.selectedText
$psISE.CurrentFile.Editor.InsertText( [regex]::Replace($text, '^##', '', 'Multiline'))
}
$MyMenu.Submenus.Add("UnComment Code",$Action,"Alt+4" ) | Out-Null
#End uncomment selected text
#Begin move to cursor
$addonName = "Go To _Cursor"
$addonkey = "Alt+C"
$action = {
    $psise.CurrentFile.Editor.EnsureVisible($psise.CurrentFile.Editor.CaretLine)
    $psise.CurrentFile.Editor.Focus()
}
$MyMenu.SubMenus.Add($addonName,$action,$addonkey) | Out-Null
#Save state file path
$ISE_STATE_FILE_PATH = Join-Path (Split-Path $profile -Parent) "IseState.xml"

# Add a new option in the Add-ons menu to export the current ISE state.
if (!($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | Where-Object { $_.DisplayName -eq "Save ISE State" }))
{
    $MyMenu.Submenus.Add("Save ISE State",{Export-ISEState $ISE_STATE_FILE_PATH},"Alt+Shift+S") | Out-Null
}

# Add a new option in the Add-ons menu to export the current ISE state and exit.
if (!($MyMenu.Submenus | Where-Object { $_.DisplayName -eq "Save ISE State And Exit" }))
{
    $MyMenu.Submenus.Add("Save ISE State And Exit",{Export-ISEState $ISE_STATE_FILE_PATH; exit},"Alt+Shift+E") | Out-Null
}

# Add a new option in the Add-ons menu to import the ISE state.
if (!($MyMenu.Submenus | Where-Object { $_.DisplayName -eq "Load ISE State" }))
{
    $MyMenu.Submenus.Add("Load ISE State",{Import-ISEState $ISE_STATE_FILE_PATH},"Alt+Shift+L") | Out-Null
}

## Region running scripts

if (($psISE.PowerShellTabs.Count -eq 1) -and ($psISE.CurrentPowerShellTab.Files.Count -eq 1) -and ($psISE.CurrentPowerShellTab.Files[0].IsUntitled) -and (Test-Path $ISE_STATE_FILE_PATH))
{
    # Remove the default "Untitled1.ps1" file and then load the session.
    if (!$psISE.CurrentPowerShellTab.Files[0].IsRecovered) { $psISE.CurrentPowerShellTab.Files.RemoveAt(0) }
    Import-ISEState $ISE_STATE_FILE_PATH
}

## End Region running scripts