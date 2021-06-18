# Enable proxy
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 1

# Enable DHCP, reset default gateway and DNS servers
$NetworkSettings = {
    function Get-EthernetAdapterIndex {
        $Adapter = Get-NetAdapter -Physical
        if ($Adapter.Length -ge 2) {
            $Adapter = $Adapter  | Where-Object -Property Name -Like 'ethernet'
        }
        return $Adapter.ifIndex
    }
    function Set-NetworkDHCP {
        $AdapterIndex = Get-EthernetAdapterIndex
        Get-NetIPAddress -InterfaceIndex $AdapterIndex | Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -NextHop "192.168.101.254" -Confirm:$false
        Set-DnsClientServerAddress -InterfaceIndex $AdapterIndex -ResetServerAddresses
        Set-NetIPInterface -InterfaceIndex $AdapterIndex -DHCP Enabled
        Start-Sleep -Seconds 3
    }
}

# Apply network settings as Administrator
Start-Process -FilePath PowerShell -ArgumentList "-command & { $NetworkSettings Set-NetworkDHCP }" -Verb RunAs