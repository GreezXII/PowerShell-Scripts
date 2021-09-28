# Disable proxy
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 0

# Set IP Address, Default Gateway, Prefix and DNS Servers
$NetworkSettings = {
    function Show-Balloon {
        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
        $balmsg.BalloonTipText = 'NAT присвоен.'
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
    
    function Set-NetworkNAT {
        $AdapterIndex = Get-EthernetAdapterIndex
        New-NetIPAddress -InterfaceIndex $AdapterIndex -IPAddress 192.168.101.230 -DefaultGateway 192.168.101.254 -PrefixLength 22
        Set-DnsClientServerAddress -InterfaceIndex $AdapterIndex -ServerAddresses ('192.168.100.253', '4.4.4.4')
		Restart-NetAdapter -InterfaceIndex $AdapterIndex
        Show-Balloon
    }
}

# Apply network settings as Administrator
Start-Process -WindowStyle Hidden -FilePath PowerShell -ArgumentList "-command & { $NetworkSettings Set-NetworkNAT }" -Verb RunAs

