FROM mcr.microsoft.com/dotnet/framework/runtime:4.8-windowsservercore-ltsc2019
SHELL ["powershell"]

COPY DockerBuild/extract.ps1 /temp/download/extract.ps1
COPY DockerBuild/copy.ps1 /temp/download/copy.ps1
COPY DockerBuild/EnvOptions.proj /temp/download/EnvOptions.proj

RUN $ErrorActionPreference = 'Stop'; \
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted; \
    # define uri
    $uri_7z = 'https://www.7-zip.org/a/7z1900-x64.exe'; \
    $uri_aria2 = 'https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0-win-64bit-build1.zip'; \
    $uri_radstudio = 'http://altd.embarcadero.com/download/radstudio/10.4/radstudio_10_4_99797b.iso'; \
    $uri_innounp = 'https://github.com/magicxor/radstudio-docker/releases/download/0.49/innounp.exe'; \
    # install 7-zip
    Invoke-WebRequest -Uri $uri_innounp -OutFile /temp/download/innounp.exe -PassThru -UseBasicParsing; \
    Invoke-WebRequest -Uri $uri_7z -OutFile /temp/download/7z.exe -PassThru -UseBasicParsing; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\temp\download\7z.exe' -ArgumentList '/S'; \
    Remove-Item /temp/download/7z.exe; \
    # get aria2 to download radstudio
    Invoke-WebRequest -Uri $uri_aria2 -OutFile /temp/download/aria2.zip -PassThru -UseBasicParsing; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', '-oC:\temp\download\aria2', '-r', 'C:\temp\download\aria2.zip'; \
    $aria2 = ((Get-ChildItem -Path /temp/download/aria2 -Filter aria2c.exe -Recurse -ErrorAction SilentlyContinue -Force | Select -First 1).FullName); \
    # download radstudio
    Start-Process -Wait -NoNewWindow -FilePath $aria2 -ArgumentList '--max-connection-per-server=10', '--split=10', '--dir=C:\temp\download', '--out=radstudio.iso', $uri_radstudio; \
    # unpack iso
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', '-oC:\temp\download\radstudio', '-r', 'C:\temp\download\radstudio.iso'; \
    Remove-Item /temp/download/radstudio.iso; \
    # unpack gof and installer
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', ('-p' + 'ImRoVkEvOW9WtXMzLZYjKz9ZXrA='), '-oC:\temp\download\radstudio_gof', '-r', 'C:\temp\download\radstudio\radstudio_10_4_esd_99797b.gof'; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\temp\download\innounp.exe' -ArgumentList '-x', '-m', '-dC:\temp\download\radstudio_unpacked\inno', 'C:\temp\download\radstudio\radstudio_10_4_esd_99797b.exe'; \
    Remove-Item -Recurse -Force /temp/download/radstudio; \
    # extract 7zips from gof
    /temp/download/extract.ps1; \
    Remove-Item -Recurse -Force 'C:\temp\download\radstudio_gof'; \
    # copy radstudio files
    /temp/download/copy.ps1; \
    Remove-Item -Recurse -Force /temp/download; \
    # set path
    [System.Environment]::SetEnvironmentVariable('BDS', 'C:\Program Files (x86)\Embarcadero\Studio\21.0', [System.EnvironmentVariableTarget]::Machine); \
    $bdsBin = 'C:\Program Files (x86)\Embarcadero\Studio\21.0\bin'; \
    $bdsBin64 = 'C:\Program Files (x86)\Embarcadero\Studio\21.0\bin64'; \
    [System.Environment]::SetEnvironmentVariable('BDSBIN', $bdsBin, [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSCOMMONDIR', 'C:\Users\Public\Documents\Embarcadero\Studio\21.0', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSINCLUDE', 'C:\Program Files (x86)\Embarcadero\Studio\21.0\include', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSLIB', 'C:\Program Files (x86)\Embarcadero\Studio\21.0\lib', [System.EnvironmentVariableTarget]::Machine); \
    $frameworkDir = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319'; \
    [System.Environment]::SetEnvironmentVariable('FrameworkDir', $frameworkDir, [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('FrameworkVersion', 'v4.5', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('LANGDIR', 'EN', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('Path', ([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';' + $frameworkDir + ';' + $bdsBin + ';' + $bdsBin64), [System.EnvironmentVariableTarget]::Machine); \
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';' + [System.Environment]::GetEnvironmentVariable('Path','User');
