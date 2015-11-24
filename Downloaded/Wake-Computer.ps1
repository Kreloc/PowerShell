function Send-MagicPacket {
 param(
 [Parameter(Mandatory=$true,
 				ValueFromPipeline=$True,
		ValueFromPipelinebyPropertyName=$True,
		ParameterSetName="MACAddress",
      HelpMessage="Enter a valid MAC address")]
 [ValidatePattern('^([0-9a-fA-F]{2}[:-]{0,1}){5}[0-9a-fA-F]{2}$')]
 [string]$MAC
 )
 <#
	.NOTES
		================================================================================
		Purpose: 		To send a Wake-on-LAN magic packet with a specified MAC address
		Assumptions:
		Effects:
		Inputs:
		 $MAC:			MAC address to include in packet
		Calls:
		Returns:		

		Notes:			Based on http://thepowershellguy.com/blogs/posh/archive/
										2007/04/01/powershell-wake-on-lan-script.aspx
		================================================================================
	.SYNOPSIS
		Sends a Wake-on-LAN magic packet containing a specified MAC address
	.DESCRIPTION
	    Sends a Wake-on-LAN magic packet containing a specified MAC address. The MAC
		address is specified by the MAC parameter. The octets of the MAC address may
		be separated by dashes '-', colons ':' or nothing
	.EXAMPLE
		Send-MagicPacket -MAC 00-16-DA-2B-6F-B8

		Description
		-----------
		Sends a Wake-on-LAN magic packet containing the MAC address 00-16-DA-2B-6F-B8
	.EXAMPLE
		Send-MagicPacket -MAC 00:16:DA:2B:6F:B8

		Description
		-----------
		Sends a Wake-on-LAN magic packet containing the MAC address 00-16-DA-2B-6F-B8
	.EXAMPLE
		Send-MagicPacket -MAC 0016DA2B6FB8

		Description
		-----------
		Sends a Wake-on-LAN magic packet containing the MAC address 00-16-DA-2B-6F-B8
	.LINK

http://www.nigelboulton.co.uk/2011/09/wake-on-lan-using-a-powershell-script/

	#>            

 # Use regex to strip out separators (: or -) if present and split string every second character
 # Piping to Where-Object {$_} avoids empty elements between each pair of characters
 $MACArray = ($MAC -replace '[-:]', [String]::Empty) -split '(.{2})' | Where-Object {$_}            

 $MACByteArray = $MACArray | ForEach-Object {[Byte]('0x' + $_)}
 $UDPClient = New-Object System.Net.Sockets.UdpClient
 $UDPClient.Connect(([System.Net.IPAddress]::Broadcast),4000)
 $Packet = [Byte[]](,0xFF * 6)
 $Packet += $MACByteArray * 16
 Write-Debug "Magic packet contents: $([bitconverter]::ToString($Packet))"
 [void]$UDPClient.Send($Packet, $Packet.Length)
 Write-Debug "Wake-on-LAN magic packet of $($Packet.Length) bytes sent to $($MAC.ToUpper())"
}  