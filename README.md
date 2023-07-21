# Autolaod_for_WinPE<br>

***

## Introduction <br>
This is my practical about the WinPE.<br>
We should format the OS with automatically and officially by using WinPE.<br>
Here is the script [startnet.cmd](https://github.com/yutsunoki/Autolaod_for_WinPE/edit/main/src/startnet.cmd).<br>

### Table of contants.
* [Guide](#guide)
  - [To create a WinPE](#to-create-a-WinPE) 
  - [Install to the USB](#install-to-the-USB)
  - [Where to find `install.wim` file](Where-to-find-installwim-file)

***

## Guide

### To create a WinPE

Create a [`WinPE`](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11) with [Windows ADK](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install).<br>
Run `Deployment and Imaging Tools Environment` and execute this command.<br>
```
copype amd64 \winpe\winpe_c
cd \winpe
```
<br>

Then we should mount the WinPE image to the `"mount" file`.<br>
You can copy the build command from [Autolaod_for_WinPE/build](https://github.com/yutsunoki/Autolaod_for_WinPE/tree/main/build) to `"\winpe"`.<br>
```
imagex /mountrw \winpe\winpe_c\media\sources\boot.wim 1 \winpe\mount
```
<br>

Copy the `findstr.exe` to the WinPE.<br>
```
copy \Windows\System32\findstr.exe \winpe\mount\Windows\system32\
```
<br>

Here is the drivers and packages install for the WinPE. These drivers and packages can be found from `"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs"`[^1]. <br>
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
[^1]: Here is the official manual of [WinPE option component](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11). Also can refer to [HaroldMitts/Build-CustomPE](https://github.com/HaroldMitts/Build-CustomPE).<br> 

After, we can copy the `startnet.cmd` from [Autolaod_for_WinPE/src](https://github.com/yutsunoki/Autolaod_for_WinPE/tree/main/src) to the `"\winpe\winpe_c\media\Windows\System32"`.<br>
```
copy startnet.cmd \winpe\winpe_c\media\Windows\System32\
```
<br>

Then, we can umount and commit for the `"mount" file`.<br>
```
imagex /unmount /commit \winpe\winpe_c\mount
imagex /cleanup
```
<br>

Next, we gotta build iso with `oscdimg` command[^2]. <br>
```
oscdimg -bootdata:2#p0,e,bwinpe_c\fwfiles\etfsboot.com#pEF,e,bwinpe_c\fwfiles\efisys.bin -u1 -udfver102 winpe_c\media winpe_f.iso
```
[^2]: [Oscdimg Command-Line Options](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oscdimg-command-line-options?view=windows-11).<br>

### Install to the USB

After, the iso file builded, we should mount that iso file and switch to the iso drive.
Then we'll copy all the folders and files to the `"WINPE_F"` of the USB partition.<br>

> The USB partition and format should be like this!!! 🔻<br>
![disk](https://github.com/yutsunoki/Autolaod_for_WinPE/blob/main/img/disk.png)<br>

> Here are the inside of `"USBdata"` partition. 🔻<br>
![map](https://github.com/yutsunoki/Autolaod_for_WinPE/blob/main/img/map.png)<br>

### Where to find `install.wim` file 

The `install.wim` file that can be found from original ISO file `"sources\install.wim"`.

***


[^]: [Capture and apply a Windows image](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-using-a-single-wim?view=windows-11)
