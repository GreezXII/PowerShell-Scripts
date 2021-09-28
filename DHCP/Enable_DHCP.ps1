# Enable proxy
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 1

# Enable DHCP, reset default gateway and DNS servers
$NetworkSettings = {
    function Show-Balloon {
        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
        $balmsg.BalloonTipText = 'DHCP присвоен.'
        $balmsg.BalloonTipTitle = "Внимание!"
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(4000)
    }
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
        Restart-NetAdapter -InterfaceIndex $AdapterIndex
        Show-Balloon
    }
}

# Apply network settings as Administrator
Start-Process -WindowStyle Hidden -FilePath PowerShell -ArgumentList "-command & { $NetworkSettings Set-NetworkDHCP }" -Verb RunAs