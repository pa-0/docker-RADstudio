$hotfixes = @('http://altd.embarcadero.com/download/radstudio/10.4/Patch1.zip');

$idePath = 'C:\Program Files (x86)\Embarcadero\Studio';
$ideVersion = '21.0';
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
    if ([string]::IsNullOrEmpty($innerZip)) {
        Rename-Item -LiteralPath $dirPath -NewName $ideVersion;
        Copy-Item "C:\temp\hotfix\$ideVersion" -Destination $idePath -Recurse -Force -Verbose;
    } else {
        $innerDir = ($dirPath + '\' + $ideVersion);
        Expand-Archive -LiteralPath $innerZip -DestinationPath $innerDir;
        Copy-Item $innerDir -Destination $idePath -Recurse -Force -Verbose;
    }
    
    Remove-Item 'C:\temp\hotfix' -Recurse;
    $i = $i + 1;
}
