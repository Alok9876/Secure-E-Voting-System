$iface='Wi-Fi'
$orig=(Get-DnsClientServerAddress -InterfaceAlias $iface -ErrorAction SilentlyContinue).ServerAddresses
Write-Host "Original DNS: $($orig -join ',')"
Try {
  Set-DnsClientServerAddress -InterfaceAlias $iface -ServerAddresses 8.8.8.8 -ErrorAction Stop
  Write-Host 'Set DNS to 8.8.8.8'
  nslookup -type=SRV _mongodb._tcp.secureevoting.3almt4h.mongodb.net 8.8.8.8
  Write-Host '--- Running mongoose direct connect test ---'
  Push-Location 'd:\VS CODE\secure-evoting\backend'
  node tmp_mongoose_test.js
  Pop-Location
} Catch {
  Write-Error "Error setting DNS or running test: $_"
} Finally {
  if($orig -and $orig.Count -gt 0){
    Set-DnsClientServerAddress -InterfaceAlias $iface -ServerAddresses $orig -ErrorAction SilentlyContinue
    Write-Host "Restored DNS to: $($orig -join ',')"
  } else {
    Set-DnsClientServerAddress -InterfaceAlias $iface -ResetServerAddresses -ErrorAction SilentlyContinue
    Write-Host 'Restored DNS to DHCP (reset)'
  }
  Get-DnsClientServerAddress -InterfaceAlias $iface | Format-List
}
