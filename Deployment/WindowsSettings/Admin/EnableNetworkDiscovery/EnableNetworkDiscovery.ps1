#Enable Network Discovery for Private and Domain profiles
Get-NetFirewallRule -DisplayGroup 'Включить сетевое обнаружение' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru | Out-Null

#Enable File and Printer sharing for Private and Domain profiles
Get-NetFirewallRule -DisplayGroup 'Включить общий доступ к файлам и принтерам' | Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true -PassThru | Out-Null
