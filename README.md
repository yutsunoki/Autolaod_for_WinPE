# Autolaod_for_WinPE

This is my practical about the WinPE.<br>
We should format the OS with automatically and officially by using WinPE.<br>
Here is the script [startnet.cmd](https://github.com/yutsunoki/Autolaod_for_WinPE/edit/main/src/startnet.cmd).<br>
___
## Guide
Create a [`WinPE`](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11) with [Windows ADK](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install).<br>
Run `Deployment and Imaging Tools Environment` and execute this command.<br>
```
copype amd64 \winpe
cd \winpe
mkdir winpe_c
move media winpe_c
```
Then we should mount the WinPE image to the "mount" file.<br>
```
imagex /mountrw \winpe\winpe_c\media\sources\boot.wim 1 \winpe\mount
```
Copy the `findstr.exe` to the WinPE.<br>
```
copy \Windows\System32\findstr.exe \winpe\mount\Windows\system32\
```
Here is the driver and package install for the WinPE. Please refer to the [WinPE option component](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11)<br>
Also can refer to the [HaroldMitts/Build-CustomPE](https://github.com/HaroldMitts/Build-CustomPE)<br>
```
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-DismCmdlets.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-EnhancedStorage.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-Fonts-Legacy.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-LegacySetup.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-PowerShell.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-Scripting.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-SecureBootCmdlets.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-SecureStartup.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-Setup.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-StorageWMI.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-WDS-Tools.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-WinReCfg.cab
dism /image:\winpe\winpe_c\mount /add-package /packegepath:WinPE-WMI.cab
```
