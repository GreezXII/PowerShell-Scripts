function Get-WindowsVersion {
    $version = [System.Environment]::OSVersion.Version.Major
    if ($Version -eq "6") {
        return 7
    }
    elseif ($version -eq "10") {
        return 10
    }
}

function Enable-Proxy {
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 1
}

$NetworkSettingsWin7 = 
{
    function Show-Balloon {
        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
        $balmsg.BalloonTipText = 'Режим работы: DHCP'
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(4000)
    }
    function Get-EthernetAdapterName {
        $interfaceName = $null
        $interfaceInfo = netsh interface show interface
        foreach($element in $interfaceInfo) {
            $matches = $null
            if($element -match ".*ethernet.*|.*Local Area Connection.*|.*Подключение по локальной сети.*") {
                $interfaceName = ($matches.values -split "\s\s")[-1] -replace "^\s"
            } 
        }
        return $interfaceName
    } 
    
    function Set-NetworkDHCP {
        $interfaceName = Get-EthernetAdapterName
        netsh interface ipv4 set address name=$interfaceName dhcp
        netsh interface ip set dns name=$interfaceName dhcp
        netsh interface set interface name=$interfaceName admin="disabled"
        netsh interface set interface name=$interfaceName admin="enabled"
    }
}

$NetworkSettingsWin10 = {
    function Show-Balloon {
        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
        $balmsg.BalloonTipText = 'Режим работы: DHCP'
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(4000)
    }
    function Get-EthernetAdapter {
        $Adapter = Get-NetAdapter -Physical
        if ($Adapter.Length -ge 2) {
            $Adapter = $Adapter  | Where-Object -Property Name -Like 'Ethernet'
        }
        return $Adapter
    }
    function Set-NetworkDHCP {
        $Adapter = Get-EthernetAdapter

        Get-NetIPAddress -InterfaceIndex $Adapter.ifIndex | Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -NextHop "192.168.101.254" -Confirm:$false
        Set-DnsClientServerAddress -InterfaceIndex $Adapter.ifIndex -ResetServerAddresses
        Set-NetIPInterface -InterfaceIndex $Adapter.ifIndex -DHCP Enabled
        Restart-NetAdapter $Adapter
        Show-Balloon
    }
}

Enable-Proxy
$WindowsVersion = Get-WindowsVersion
if($WindowsVersion -eq 7) {
    Start-Process -WindowStyle Hidden -FilePath PowerShell -ArgumentList "-command & { $NetworkSettingsWin7 Set-NetworkDHCP }" -Verb RunAs
} elseif ($WindowsVersion -eq 10) {
    Start-Process -WindowStyle Hidden -FilePath PowerShell -ArgumentList "-command & { $NetworkSettingsWin10 Set-NetworkDHCP }" -Verb RunAs
}
