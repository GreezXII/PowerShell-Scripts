# Импортировать схему плиток в меню пуск
$DefaultLayoutsXMLPath = Join-Path -Path $PSScriptRoot -ChildPath "Layouts\DefaultLayouts.xml"
$DefaultLayoutsRegPath = Join-Path -Path $PSScriptRoot -ChildPath "Layouts\DefaultLayouts.reg"
Copy-Item $DefaultLayoutsXMLPath -Destination "$env:LOCALAPPDATA\Microsoft\Windows\Shell" -Force
reg import $DefaultLayoutsRegPath | Out-Null