###Experimental GUI For ToolKit Functions###
#Build the GUI
Powershell -sta
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$xaml = @"
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window" Title="Initial Window" WindowStartupLocation = "CenterScreen" 
    Width = "313" Height = "800" ShowInTaskbar = "True" Background = "lightgray"> 
    <ScrollViewer VerticalScrollBarVisibility="Auto">
        <StackPanel >
            <StackPanel.Resources>
                <Style x:Key="AlternatingRowStyle" TargetType="{x:Type Control}" >
                    <Setter Property="Background" Value="LightGray"/>
                    <Setter Property="Foreground" Value="Black"/>
                    <Style.Triggers>
                        <Trigger Property="ItemsControl.AlternationIndex" Value="1">                            
                            <Setter Property="Background" Value="White"/>
                            <Setter Property="Foreground" Value="Black"/>                                
                        </Trigger>                            
                    </Style.Triggers>
                </Style>                    
            </StackPanel.Resources>          
            <TextBox  IsReadOnly="True" TextWrapping="Wrap">
                With Binding
            </TextBox>
            <Button x:Name="button1" Content="Get Services"/>
            <Expander IsExpanded="True">
                <ListBox x:Name="listbox" DisplayMemberPath = "DisplayName" AlternationCount="2" 
                ItemContainerStyle="{StaticResource AlternatingRowStyle}"/>
            </Expander >
            <TextBox  IsReadOnly="True" TextWrapping="Wrap">
                Without Binding
            </TextBox>   
            <Button x:Name="button2" Content="Get Services"/>
            <Expander IsExpanded="True">
                <ListBox x:Name="listbox1" AlternationCount="2" 
                ItemContainerStyle="{StaticResource AlternatingRowStyle}"/>                 
            </Expander>
        </StackPanel>
    </ScrollViewer >
</Window>
"@
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Window=[Windows.Markup.XamlReader]::Load( $reader )
 
#Connect to Controls
$button1 = $Window.FindName('button1')
$button2 = $Window.FindName('button2')
$listbox = $Window.FindName('listbox')
$listbox1 = $Window.FindName('listbox1')
 
#Events
$button1.Add_Click({
    $services = Get-Service
    $listbox.ItemsSource = $services
})
$button2.Add_Click({
    $services = Get-Service
    $listbox1.ItemsSource = $services
})
 
$Window.ShowDialog() | Out-Null