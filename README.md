# radstudio-docker
RAD Studio docker images

[![ci_ltsc2019](https://github.com/magicxor/radstudio-docker/actions/workflows/ci_ltsc2019.yml/badge.svg)](https://github.com/magicxor/radstudio-docker/actions/workflows/ci_ltsc2019.yml)
[![ci_ltsc2022](https://github.com/magicxor/radstudio-docker/actions/workflows/ci_ltsc2022.yml/badge.svg)](https://github.com/magicxor/radstudio-docker/actions/workflows/ci_ltsc2022.yml)

# Usage

```Dockerfile
FROM magicxor/radstudio:xe-delphi-net3.5-ltsc2019
SHELL ["powershell"]

COPY YourApp /build/app
WORKDIR /build/app
RUN msbuild /t:build YourApp.dproj;
```

or

```powershell
docker run -v C:\host_dir:C:\build\app magicxor/radstudio:xe-delphi-net3.5-ltsc2019 msbuild /t:build C:\build\app\YourApp.dproj
```
