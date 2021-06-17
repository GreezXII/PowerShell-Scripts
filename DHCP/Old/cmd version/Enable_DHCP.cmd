@echo off
netsh interface ip set address "Ethernet" dhcp
netsh interface ip set dnsservers "Ethernet" dhcp