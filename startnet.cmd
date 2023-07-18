wpeinit
@echo off
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

%== check for the architecture ==%
if %PROCESSOR_ARCHITECTURE%==AMD64 (
	set ARCH=x64
) else (
	set ARCH=x86
)
%== check for the sources ==%
for %%A in (
	C D E F G H I J K L M N O P Q R S T U V W X Y Z
) do (
	if exist %%A:\win_c\sources\install.wim set DRIVE=%%A
)
echo( & echo;The sources drive is %DRIVE%

%== check for the BIOS type ==%
wpeutil UpdateBootInfo > NUL && echo( & echo;wpeutil UpdateBootInfo
for /f "tokens=2* delims=	 " %%A in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType'
	) do (set FIRMWARE=%%B)

%== check for the C drive ==%
set theC=
for /f "tokens=3-8" %%i in ('diskpart /s %DRIVE%:\win_c\sources\1\diskpart_check.inf ^|findstr /i partition'
) do (
	echo( & echo;%%i %%j %%k %%l %%m %%n & echo(
	if %%i==C (set theC=%%i %%j %%k %%l %%m %%n)
)
echo( & echo;%theC%
for %%i in (%theC%) do (
	echo( & echo;%%i
	if %%i==GB goto haveDisk
)

goto noDisk

%== if C Drive exist ==%
:haveDisk
if %DRIVE%==C goto noDisk
echo;HAVE DISK
if %FIRMWARE%==0x1 (
	diskpart /s %DRIVE%:\win_c\sources\2\diskpart_legacy.inf
	echo( & echo;[*] this is legacy
	goto applyImageHaveDisk
) 
if %FIRMWARE%==0x2 (
	:: check for the efi system partition
	set theS=
	for /f "tokens=1-6" %%i in ('diskpart /s %DRIVE%:\win_c\sources\1\diskpart_lispart.inf ^|findstr /i system'
	) do (
		echo;%%i %%j %%k %%l %%m %%n
		if %%k==System (goto haveDisk2)
	)
	echo( & echo;but no system partition
	goto noDisk

	:haveDisk2
	diskpart /s %DRIVE%:\win_c\sources\2\diskpart_uefi.inf
	echo( & echo;[*] this is UEFI
	goto applyImageHaveDisk
)

:applyImageHaveDisk
set winDrive=C
set sysDrive=S

diskpart /s %DRIVE%:\win_c\sources\1\diskpart_check.inf
:: apply the image
dism /apply-image /imagefile:%DRIVE%:\win_c\sources\install.wim /index:1 /applydir:%winDrive%:\
if %errorlevel%==112 (goto noDisk)
:: set up bootloader
if %FIRMWARE%==0x1 (
	bcdboot %winDrive%:\windows /s %winDrive%:\ /f all)
if %FIRMWARE%==0x2 (
	bcdboot %winDrive%:\windows /s %sysDrive%:\ /f all)

goto reboot

%== if C Drive not exist ==%
:noDisk
echo;NO DISK 
if %FIRMWARE%==0x1 (
	diskpart /s %DRIVE%:\win_c\sources\1\diskpart_legacy.inf
	echo( & echo;[*] this is legacy
	goto applyImage
) 
if %FIRMWARE%==0x2 (
	diskpart /s %DRIVE%:\win_c\sources\1\diskpart_uefi.inf
	echo( & echo;[*] this is UEFI
	goto applyImage
)

:applyImage

for /f "tokens=3 delims= " %%i in (
	'diskpart /s %DRIVE%:\win_c\sources\1\diskpart_check.inf ^|findstr /i Windows'
) do (
	set winDrive=%%i
)
for /f "tokens=3 delims= " %%i in (
	'diskpart /s %DRIVE%:\win_c\sources\1\diskpart_check.inf ^|findstr /i System'
) do (
	set sysDrive=%%i
)

echo;Win drive is %winDrive%
echo;Sys drive is %sysDrive%

diskpart /s %DRIVE%:\win_c\sources\1\diskpart_check.inf
:: apply the image
dism /apply-image /imagefile:%DRIVE%:\win_c\sources\install.wim /index:1 /applydir:%winDrive%:\
:: set up bootloader
if %FIRMWARE%==0x1 (
	bcdboot %winDrive%:\windows /s %winDrive%:\ /f all)
if %FIRMWARE%==0x2 (
	bcdboot %winDrive%:\windows /s %sysDrive%:\ /f all)

:reboot
wpeutil reboot
