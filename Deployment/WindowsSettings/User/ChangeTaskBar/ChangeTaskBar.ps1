# Убрать Кортану, строку поиска и просмотр задач
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Value 0
Set-ItemProperty -Path "HKCU:\\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0
Set-ItemProperty -Path "HKCU:\\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
# Открепить Windows Store, Mail и Edge
$appNames = @("Microsoft.MicrosoftEdge*", "Microsoft.WindowsStore*", "microsoft.windowscommunicationsapps*")
$apps = (New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
foreach ($n in $appNames)
{
    $apps | Where-Object -FilterScript {$_.Path -like $n} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq "&Открепить от панели задач"} | ForEach-Object -Process {$_.DoIt()}}
}
# Открепить Edge - W10 20H2
Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Recurse -Force
$shell = new-object -com "Shell.Application"  
$folder = $shell.Namespace('C:\Windows')    
$item = $folder.Parsename('explorer.exe')
$verb = $item.Verbs() | ? {$_.Name -eq 'Открепить от панели задач'}
if ($verb) {$verb.DoIt()}

