$installChoco = {
    # Set up proxy
    Write-Host "Proxy"
    $path = '"Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings"'
    Set-ItemProperty -Path $path -Name '"ProxyEnable"' -Value 1
    Set-ItemProperty -Path $path -Name '"ProxyServer"' -Value '"192.168.101.222:3128"' 
    Set-ItemProperty -Path $path -Name '"ProxyOverride"' -Value '"192.168.*;<local>"'
    # Install choco
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('"https://community.chocolatey.org/install.ps1"'))

    $installSoftware = {
        Write-Host '"Run choco"'
        choco install 7zip libreoffice-fresh adobereader thunderbird firefox googlechrome -y
        Write-Host '"End!"'
    }
    Start-Process -FilePath PowerShell -ArgumentList """-ExecutionPolicy Bypass -Command & {$installSoftware}"""
}

Start-Process -FilePath PowerShell -ArgumentList "-ExecutionPolicy Bypass -Command & {$installChoco}" -Verb RunAs -Wait