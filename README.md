# radstudio-docker
RAD Studio docker images

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

# Disclaimer

This code is predetermined for educational, personal, AND non-commercial use only. Please buy and use only original licensed software.

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.
