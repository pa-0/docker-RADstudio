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
    $uri_radstudio = 'http://altd.embarcadero.com/download/radstudio/10.3/delphicbuilder10_3_3_7899_nt.iso'; \
    # install 7-zip
    Invoke-WebRequest -Uri $uri_7z -OutFile /temp/download/7z.exe -PassThru -UseBasicParsing; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\temp\download\7z.exe' -ArgumentList '/S'; \
    Remove-Item /temp/download/7z.exe; \
    # get aria2 to download radstudio
    Invoke-WebRequest -Uri $uri_aria2 -OutFile /temp/download/aria2.zip -PassThru -UseBasicParsing; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', '-oC:\temp\download\aria2', '-r', 'C:\temp\download\aria2.zip'; \
    $aria2 = ((Get-ChildItem -Path /temp/download/aria2 -Filter aria2c.exe -Recurse -ErrorAction SilentlyContinue -Force | Select -First 1).FullName); \
    # download radstudio
    Start-Process -Wait -NoNewWindow -FilePath $aria2 -ArgumentList '--max-connection-per-server=10', '--split=10', '--dir=C:\temp\download', '--out=radstudio.iso', $uri_radstudio; \
    # unpack radstudio
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', '-oC:\temp\download\radstudio', '-r', 'C:\temp\download\radstudio.iso'; \
    Remove-Item /temp/download/radstudio.iso; \
    # extract radstudio files
    cd /temp/download/radstudio/Install; \
    /temp/download/extract.ps1; \
    cd /temp; \
    Remove-Item -Recurse -Force /temp/download/radstudio; \
    # copy radstudio files
    /temp/download/copy.ps1; \
    Remove-Item -Recurse -Force /temp/download; \
    # set path
    [System.Environment]::SetEnvironmentVariable('BDS', 'C:\Program Files (x86)\Embarcadero\Studio\20.0', [System.EnvironmentVariableTarget]::Machine); \
    $bdsBin = 'C:\Program Files (x86)\Embarcadero\Studio\20.0\bin'; \
    $bdsBin64 = 'C:\Program Files (x86)\Embarcadero\Studio\20.0\bin64'; \
    [System.Environment]::SetEnvironmentVariable('BDSBIN', $bdsBin, [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSCOMMONDIR', 'C:\Users\Public\Documents\Embarcadero\Studio\20.0', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSINCLUDE', 'C:\Program Files (x86)\Embarcadero\Studio\20.0\include', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSLIB', 'C:\Program Files (x86)\Embarcadero\Studio\20.0\lib', [System.EnvironmentVariableTarget]::Machine); \
    $frameworkDir = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319'; \
    [System.Environment]::SetEnvironmentVariable('FrameworkDir', $frameworkDir, [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('FrameworkVersion', 'v4.5', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('LANGDIR', 'EN', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('Path', ([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';' + $frameworkDir + ';' + $bdsBin + ';' + $bdsBin64), [System.EnvironmentVariableTarget]::Machine); \
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';' + [System.Environment]::GetEnvironmentVariable('Path','User');
