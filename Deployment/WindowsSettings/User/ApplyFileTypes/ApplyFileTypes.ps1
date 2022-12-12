# Установить ассоциации pdf с Acrobat Reader DC
$SetUserFTAExe = Join-Path -Path $PSScriptRoot -ChildPath "FTA\SetUserFTA.exe"
& "$SetUserFTAExe" .pdf AcroExch.Document.DC