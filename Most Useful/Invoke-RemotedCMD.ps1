	#region Run-RemoteCMD
	#http://gallery.technet.microsoft.com/scriptcenter/56962f03-0243-4c83-8cdd-88c37898ccc4
Function Invoke-RemoteCMD 
{ 
    param
	( 
	    [Parameter(Mandatory=$true,valuefrompipeline=$true)] 
	    [string]$ComputerName,
		[string]$Command
	)
	begin 
	{	        
        [string]$cmd = "CMD.EXE /C " +$command 
    } 
    process 
	{ 
        $newproc = Invoke-WmiMethod -class Win32_process -name Create -ArgumentList ($cmd) -ComputerName $ComputerName 
        if ($newproc.ReturnValue -eq 0 ) 
        { 
			Write-Output " Command $($command) invoked Sucessfully on $($ComputerName)" 
		}
		#This opens the command prompt window visibiliy on target computer. 
        # if command is sucessfully invoked it doesn't mean that it did what its supposed to do 
        #it means that the command only sucessfully ran on the cmd.exe of the server 
        #syntax errors can occur due to user input  
    } 
    End{}
}