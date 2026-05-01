Write-Host 'Searching common OpenSSL install locations...'
$paths = @(
  'C:\Program Files\OpenSSL-Win64\bin\openssl.exe',
  'C:\Program Files\OpenSSL-Win64\openssl.exe',
  'C:\Program Files\OpenSSL\bin\openssl.exe',
  'C:\Program Files (x86)\OpenSSL-Win32\bin\openssl.exe'
)
$found = $paths | Where-Object { Test-Path $_ }
if (-not $found) {
  $item = Get-ChildItem 'C:\Program Files*' -Filter openssl.exe -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($item) { $found = $item.FullName }
}
if ($found) {
  Write-Host 'Found OpenSSL at:' $found
  Write-Host 'Running s_client (this may take a few seconds)...'
  & $found s_client -connect secureevoting.3almt4h.mongodb.net:27017 -servername secureevoting.3almt4h.mongodb.net -showcerts -tls1_2 2>&1 | Out-File -FilePath .\openssl_s_client_output.txt -Encoding utf8
  Write-Host 'Saved output to openssl_s_client_output.txt'
  Get-Content .\openssl_s_client_output.txt -TotalCount 200
} else {
  Write-Host 'OpenSSL not located on disk.'
}
