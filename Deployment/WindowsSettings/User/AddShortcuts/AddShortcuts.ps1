# Вынести ярлык Public на рабочий стол
Copy-Item -Path $PSScriptRoot\Shortcuts\Public.lnk -Destination $env:UserProfile\Desktop\Public.lnk