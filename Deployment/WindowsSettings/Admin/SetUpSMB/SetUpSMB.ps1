# Включить поддержку общего доступа к файлам SMB 1.0
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -WarningAction SilentlyContinue | Out-Null
# Отключить сервер SMB 1.0
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Server -NoRestart -WarningAction SilentlyContinue | Out-Null
# Отключить автоматическое удаление протокола SMB 1.0
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Deprecation -NoRestart -WarningAction SilentlyContinue | Out-Null