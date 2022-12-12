function Enable-Proxy {
    $proxySettingsRegKey = "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path $proxySettingsRegKey -Name ProxyServer -Value "192.168.101.222:3128"
    Set-ItemProperty -Path $proxySettingsRegKey -Name ProxyOverride -Value "192.168*;<local>"
    Set-ItemProperty -Path $proxySettingsRegKey -Name "ProxyEnable" -Value 1
}

function Install-Chocolatey {
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Programs {
    choco install 7zip adobereader libreoffice-fresh thunderbird Firefox GoogleChrome -y
}

Enable-Proxy
Install-Chocolatey
Install-Programs