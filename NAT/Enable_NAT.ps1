# Disable proxy
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 0

# Set IP Address, Default Gateway, Prefix and DNS Servers
$NetworkSettings = {
    function Get-EthernetAdapterIndex {
        $Adapter = Get-NetAdapter -Physical
        if ($Adapter.Length -ge 2) {
            $Adapter = $Adapter  | Where-Object -Property Name -Like 'ethernet'
        }
        return $Adapter.ifIndex
    }
    
    function Set-NetworkNAT {
        $AdapterIndex = Get-EthernetAdapterIndex
        New-NetIPAddress -InterfaceIndex $AdapterIndex -IPAddress 192.168.101.230 -DefaultGateway 192.168.101.254 -PrefixLength 22
        Set-DnsClientServerAddress -InterfaceIndex $AdapterIndex -ServerAddresses ('192.168.100.253', '4.4.4.4')
    }
}

# Apply network settings as Administrator
Start-Process -FilePath PowerShell -ArgumentList "-command & { $NetworkSettings Set-NetworkNAT }" -Verb RunAs
