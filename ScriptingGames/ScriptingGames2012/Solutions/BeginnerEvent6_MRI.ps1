$os = Get-WMIObject -Class Win32_OperatingSystem
$Date = Get-Date
$UpTime = $Date - ($os.ConvertToDateTime($os.LastBootUpTime))
"The computer $($os.__Server) has been up for $($UpTime.Days) days $($UpTime.hours) hours and $($UpTime.minutes) minutes, $($UpTime.seconds) seconds as of $Date"