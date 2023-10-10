$hotfixes = 'http://altd.embarcadero.com/download/radstudio/10.3/RS1033_Indy_SSL_Patch.zip', 
    'http://altd.embarcadero.com/download/radstudio/10.3/R1033_Delphi_OpenArray_Prologue_Patch.zip';

$i = 1;
foreach ($hotfix in $hotfixes) {
    $fileName = "$i.zip";
    $filePath = "C:\temp\hotfix\$fileName";
    $dirPath = "C:\temp\hotfix\$i";
    New-Item -ItemType File -Path $filePath -Force;
    Remove-Item $filePath;
    Write-Host ('Apply hotfix [' + $i.ToString() + ' of ' + $hotfixes.Count + '] ' + $hotfix);
    Invoke-WebRequest -Uri $hotfix -OutFile $filePath -UseBasicParsing;
    Expand-Archive -LiteralPath $filePath -DestinationPath $dirPath;
    $innerZip = ((Get-ChildItem -Path $dirPath -Filter *.zip -Recurse -ErrorAction SilentlyContinue -Force | Select-Object -First 1).FullName);
    $innerDir = ($dirPath + '\20.0');
    Expand-Archive -LiteralPath $innerZip -DestinationPath $innerDir;
    Copy-Item $innerDir -Destination 'C:\Program Files (x86)\Embarcadero\Studio' -Recurse -Force -Verbose;
    Remove-Item $filePath;
    Remove-Item $dirPath -Recurse;
    $i = $i + 1;
}
