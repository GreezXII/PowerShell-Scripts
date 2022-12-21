function Enable-Proxy {
    $path = "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path $path -Name "ProxyEnable" -Value 1
    Set-ItemProperty -Path $path -Name "ProxyServer" -Value "192.168.101.222:3128" 
    Set-ItemProperty -Path $path -Name "ProxyOverride" -Value "192.168.*;<local>"
}

function Install-Choco {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-Software {
    choco install 7zip libreoffice-fresh adobereader thunderbird firefox googlechrome -y
}

Enable-Proxy
Install-Choco
Install-Software