# Удалить OfficeHub
Get-AppxPackage -Name "Microsoft.MicrosoftOfficeHub" | Remove-AppxPackage
# Удалить лишние принтеры
$printers = @("Fax", "Microsoft XPS Document Writer", "OneNote*")
foreach ($p in $printers)
{
    $p = Get-Printer -Name $p -ErrorAction SilentlyContinue
    if ($p)
    {
        $p | Remove-Printer
    }
}