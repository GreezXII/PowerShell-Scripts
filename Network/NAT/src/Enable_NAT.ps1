function Get-WindowsVersion {
    $version = [System.Environment]::OSVersion.Version.Major
    if ($Version -eq "6") {
        return 7
    }
    elseif ($version -eq "10") {
        return 10
    }
}

function Disable-Proxy {
    Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -Value 0
}

$NetworkSettingsWin7 = {
    
    function Show-Balloon {
        Add-Type -AssemblyName System.Windows.Forms
        $global:balmsg = New-Object System.Windows.Forms.NotifyIcon
        $path = (Get-Process -id $pid).Path
        $balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
        $balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
        $balmsg.BalloonTipText = 'Режим работы: NAT'
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(4000)
    }

    function Get-EthernetAdapterName {
        $interfaceName = $null
        $interfaceInfo = netsh interface show interface
        foreach($element in $interfaceInfo) {
            $matches = $null
            if($element -match '.*ethernet.*|.*Local Area Connection.*|.*Подключение по локальной сети.*') {
                $interfaceName = ($matches.values -split "\s\s")[-1] -replace "^\s"
            } 
        }
        return $interfaceName
    } 
    
    function Set-NetworkNAT {
        $interfaceName = Get-EthernetAdapterName
        netsh interface ipv4 set address name=$interfaceName static 192.168.101.230 255.255.252.0 192.168.101.254
        netsh interface ip set dns name=$interfaceName static 192.168.100.253
        netsh interface ip add dns name=$interfaceName 4.4.4.4 index=2
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
        $balmsg.BalloonTipText = 'Режим работы: NAT'
        $balmsg.Visible = $true
        $balmsg.ShowBalloonTip(4000)
    }

        function Get-EthernetAdapter {
        $Adapter = Get-NetAdapter -Physical
        if ($Adapter.Length -ge 2) {
            $Adapter = $Adapter  | Where-Object -Property Name -Like 'ethernet'
        }
        return $Adapter
    }
    
    function Set-NetworkNAT {
        $Adapter = Get-EthernetAdapter
        New-NetIPAddress -InterfaceIndex $Adapter.ifIndex -IPAddress 192.168.101.230 -DefaultGateway 192.168.101.254 -PrefixLength 22
        Set-DnsClientServerAddress -InterfaceIndex $Adapter.ifIndex -ServerAddresses ('192.168.100.253', '4.4.4.4')
		Restart-NetAdapter $Adapter
        Show-Balloon
    }
}

# Disable-Proxy
# $WindowsVersion = Get-WindowsVersion
# if($WindowsVersion -eq 7) {
#     Start-Process -FilePath PowerShell -ArgumentList "-command & { $NetworkSettingsWin7 Get-EthernetAdapterName }" -NoNewWindow -Verb RunAs 
# } elseif ($WindowsVersion -eq 10) {
#     Start-Process -WindowStyle Hidden -FilePath PowerShell -ArgumentList "-command & { $NetworkSettingsWin10 Set-NetworkNAT }" -Verb RunAs
# }
function Get-EthernetAdapterName {
    $interfaceName = $null
    $interfaceInfo = netsh interface show interface
    foreach($element in $interfaceInfo) {
        $matches = $null
        if($element -match '.*ethernet.*|.*Local Area Connection.*|.*Подключение по локальной сети.*') {
            $interfaceName = ($matches.values -split "\s\s")[-1] -replace "^\s"
        } 
    }
    return $interfaceName
} 

function Set-NetworkNAT {
    $interfaceName = Get-EthernetAdapterName
    netsh interface ipv4 set address name=$interfaceName static 192.168.101.230 255.255.252.0 192.168.101.254
    netsh interface ip set dns name=$interfaceName static 192.168.100.253
    netsh interface ip add dns name=$interfaceName 4.4.4.4 index=2
    netsh interface set interface name=$interfaceName admin="disabled"
    netsh interface set interface name=$interfaceName admin="enabled"
}
Set-NetworkNAT