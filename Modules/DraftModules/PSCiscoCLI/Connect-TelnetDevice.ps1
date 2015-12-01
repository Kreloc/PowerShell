Function Connect-TelnetDevice
{
	Param
	(
		[Parameter(ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$true)]
		[alias("CN","MachineName","IPAddress")]
        [string]$RemoteHost = "192.168.1.1",
        [string]$Port = "23"
	)
	Process
	{
		$global:TelnetSocket = New-Object System.Net.Sockets.TcpClient($RemoteHost, $Port)
	}
}
function Get-Stream 
{
	param($stream)
	$buffer = new-object system.byte[] 1024
	$enc = new-object system.text.asciiEncoding

	## Read all the data available from the stream, writing it to the 
	## screen when done.

	## Allow data to buffer
	start-sleep -m 100
	$output = ""
	while($stream.DataAvailable)
	{   
		$read = $stream.Read($buffer, 0, 1024)    
		$output = "$output$($enc.GetString($buffer, 0, $read))"
		## Allow data to buffer for a bit 
		start-sleep -m 100
	}
	$output.split("`n")
}

Function Invoke-TelNetCommand
{
	Param
	(
	[parameter(position=0,Mandatory=$true)][validatenotnull()]
		[String]$User,
	[parameter(position=1,Mandatory=$true)][validatenotnull()]
		[String]$Password, 
	[parameter(position=2,Mandatory=$true,valuefrompipeline=$true)][validatenotnull()]
		[String]$InputObject
	)
	begin
	{
		
		$str = $TelnetSocket.GetStream()
		$wrt = new-object system.io.streamwriter($str)
		
		Get-Stream($str)
		$wrt.writeline($user)
		$wrt.flush()
		Get-Stream($str)
		$wrt.writeline($password)
		$wrt.flush()
		Get-stream($str)
	}
	process
	{
		$wrt.writeline($InputObject)
		$wrt.flush()
		Get-Stream($str)
	}
	end
	{
		$wrt.writeline("exit")
		$wrt.flush()
		read-stream($str)

		## Close the streams 
		$wrt.Close()
		$str.Close()
		$sock.close()
	}
}