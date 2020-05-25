FROM mcr.microsoft.com/dotnet/framework/runtime:3.5-windowsservercore-ltsc2019
SHELL ["powershell"]

COPY DockerBuild/EnvOptions.proj /temp/download/EnvOptions.proj
COPY DockerBuild/kill_fastreport.ps1 /tools/kill_fastreport.ps1

RUN $ErrorActionPreference = 'Stop'; \
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted; \
    /tools/kill_fastreport.ps1; \
    # define uri
    $uri_7z = 'https://www.7-zip.org/a/7z1900-x64.exe'; \
    $uri_aria2 = 'https://github.com/aria2/aria2/releases/download/release-1.35.0/aria2-1.35.0-win-64bit-build1.zip'; \
    $uri_radstudio = 'http://altd.embarcadero.com/download/radstudio/xe2/delphicbuilder_xe2_4504_win.iso'; \
    # install 7-zip
    New-Item -ItemType Directory -Force -Path /temp/download; \
    Invoke-WebRequest -Uri $uri_7z -OutFile /temp/download/7z.exe -UseBasicParsing; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\temp\download\7z.exe' -ArgumentList '/S'; \
    Remove-Item /temp/download/7z.exe; \
    # get aria2 to download radstudio
    Invoke-WebRequest -Uri $uri_aria2 -OutFile /temp/download/aria2.zip -UseBasicParsing; \
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', '-oC:\temp\download\aria2', '-r', 'C:\temp\download\aria2.zip'; \
    Remove-Item /temp/download/aria2.zip; \
    $aria2 = ((Get-ChildItem -Path /temp/download/aria2 -Filter aria2c.exe -Recurse -ErrorAction SilentlyContinue -Force | Select -First 1).FullName); \
    # download radstudio
    Start-Process -Wait -NoNewWindow -FilePath $aria2 -ArgumentList '--max-connection-per-server=10', '--split=10', '--dir=C:\temp\download', '--out=radstudio.iso', $uri_radstudio; \
    Remove-Item -Recurse -Force /temp/download/aria2; \
    # unpack radstudio
    Start-Process -Wait -NoNewWindow -FilePath 'C:\Program Files\7-Zip\7z.exe' -ArgumentList 'x', '-oC:\temp\download\radstudio', '-r', 'C:\temp\download\radstudio.iso'; \
    Remove-Item /temp/download/radstudio.iso; \
    # install radstudio
    Start-Process -NoNewWindow -Wait -FilePath 'C:\temp\download\radstudio\Install\Setup.exe' -ArgumentList '/S', '/SUPPRESSMSGBOXES', '/SP-', '/ALLUSERS', '/NOCANCEL', '/NORESTART', '/NOICONS', '/LANG=English', 'LANGUAGE=English', 'EN=TRUE', 'KEY1=2AAE', 'KEY2=E3SSSD', 'KEY3=RXN5NE', 'KEY4=HACS', 'USERNAME=Stefan', 'USERCOMPANY=HomeCorp', 'PERSON_DW32=TRUE', 'PERSON_CPPB=FALSE', 'INSTALL_AQTIME=FALSE', 'INSTALL_CODESITE=FALSE', 'INSTALL_FINALBUILDER=FALSE', 'INSTALL_HELP=FALSE', 'INSTALL_RAVE_REPORTS=FALSE', 'INSTALL_SVNCLIENT=FALSE', 'INSTALL_FEATURE_DatabaseDesktop=FALSE', 'INSTALL_FEATURE_IntraWeb=FALSE', 'INSTALL_FEATURE_SampleDataFiles=FALSE', 'INSTALL_FEATURE_SamplePrograms=FALSE', 'INSTALL_INTERBASE=FALSE', 'INSTALL_ANDROID_NDK=FALSE', 'INSTALL_ANDROID_SDK=FALSE', 'INSTALL_JDK=FALSE', 'INSTALL_FEATURE_RADCOREBCBW64=FALSE', 'INSTALL_FEATURE_COREOSXW32=FALSE', 'INSTALL_BDE=FALSE', 'INSTALL_FEATURE_DATABASE=FALSE', 'INSTALL_FEATURE_HELPFILES=FALSE', 'INSTALL_FEATURE_IBX=FALSE', 'INSTALL_FEATURE_COREMOBILE=FALSE', 'INSTALL_FEATURE_CORBA=FALSE'; \
    $envOptionsPath = ($env:APPDATA + '\Embarcadero\BDS\9.0\EnvOptions.proj'); \
    New-Item -ItemType File -Path $envOptionsPath -Force; \
    Copy-Item 'C:\temp\download\EnvOptions.proj' -Destination $envOptionsPath -Force; \
    Remove-Item -Recurse -Force /temp; \
    # set path
    [System.Environment]::SetEnvironmentVariable('BDS', 'C:\Program Files (x86)\Embarcadero\RAD Studio\9.0', [System.EnvironmentVariableTarget]::Machine); \
    $bdsBin = 'C:\Program Files (x86)\Embarcadero\RAD Studio\9.0\bin'; \
    $bdsBin64 = 'C:\Program Files (x86)\Embarcadero\RAD Studio\9.0\bin64'; \
    [System.Environment]::SetEnvironmentVariable('BDSBIN', $bdsBin, [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSCOMMONDIR', 'C:\Users\Public\Documents\RAD Studio\9.0', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSINCLUDE', 'C:\Program Files (x86)\Embarcadero\RAD Studio\9.0\include', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('BDSLIB', 'C:\Program Files (x86)\Embarcadero\RAD Studio\9.0\lib', [System.EnvironmentVariableTarget]::Machine); \
    $frameworkDir = 'C:\Windows\Microsoft.NET\Framework\v3.5'; \
    [System.Environment]::SetEnvironmentVariable('FrameworkDir', $frameworkDir, [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('FrameworkVersion', 'v3.5', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('LANGDIR', 'EN', [System.EnvironmentVariableTarget]::Machine); \
    [System.Environment]::SetEnvironmentVariable('Path', ([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';' + $frameworkDir + ';' + $bdsBin + ';' + $bdsBin64), [System.EnvironmentVariableTarget]::Machine); \
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) + ';' + [System.Environment]::GetEnvironmentVariable('Path','User');
