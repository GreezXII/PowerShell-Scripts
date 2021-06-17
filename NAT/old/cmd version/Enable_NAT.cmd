@echo off
netsh interface ip set address "Ethernet" static 192.168.101.230 255.255.252.0 192.168.101.254
netsh interface ip add dnsservers "Ethernet" 192.168.100.253
netsh interface ip add dnsservers "Ethernet" 4.4.4.4 index=2
