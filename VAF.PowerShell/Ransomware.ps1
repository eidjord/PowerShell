# Henter ned filter for ransomware og lager en fil som kan brukes på filserver til varsling av slike filer

$url = "https://fsrm.experiant.ca/api/v1/combined"
$matching = "\*." # for eksempel: "xxx" eller "\*."
$filnavn = "ran.xml"


Write-Host "Kaller api: $url" 
$api = Invoke-RestMethod -Uri $url

Write-Host "Filtrere liste med filter: $matching"
$list = $api.filters.Where{$_ -match $matching }

Write-Host "Lastet ned liste med " + $list.Count + " filter"

$template = "<?xml version=""1.0""?><Root><Header DatabaseVersion = '2.0'></Header><QuotaTemplates></QuotaTemplates><DatascreenTemplates></DatascreenTemplates><FileGroups><FileGroup Name = 'Ransomware' Id = '{99238e10-91ce-4440-aae6-335d5bf07998}' Description = ''><Members>PATTERNS</Members><NonMembers></NonMembers></FileGroup></FileGroups></Root>"
$patterns = -join ($list | ForEach-Object {"<Pattern PatternValue=`"" + $_ + "`"/>" })
$filinnhold = $template -replace "PATTERNS", $patterns

Write-Host "Skriver fil: $filnavn"
Set-Content $filnavn $filinnhold

Write-Host "Fedig."