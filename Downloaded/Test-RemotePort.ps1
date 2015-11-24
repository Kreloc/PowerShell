Function Test-RemotePort
{
    [CmdletBinding()]
    Param
	(
        [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        Position=0)]
        $servers,

        [Parameter(Mandatory=$False,
        ValueFromPipeline=$False,
        Position=1)]
        $port = '80'
    )

    Begin {}
	Process 
	{
        foreach ($server in $servers)
		{
            try
			{
                $socket = new-object Net.Sockets.TcpClient
                $connect = $socket.BeginConnect($server, $port, $null, $null)
                $NoTimeOut = $connect.AsyncWaitHandle.WaitOne(5000, $false)
                Write-Host "Connecting to"$Server":"$Port

                if ($NoTimeOut) 
				{
                    $socket.EndConnect($connect) | Out-Null
                    "Connection successful"
                } 
				else 
				{				
                     "Connection failed"
                }
       		}
            Catch
			{
                "Connection failed - $(($error[0]).Exception.message)"
            }
        }
    }
}