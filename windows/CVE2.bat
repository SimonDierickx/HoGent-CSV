@echo off
setlocal

REM Declare variables
echo Declaring variables...
set VMNAME=CVE-2018-15473-VM
set installed=not installed

timeout /t 5 /nobreak >nul
echo Executing the script...
VBoxManage guestcontrol "%VMNAME%" run --exe "/usr/bin/sudo" --username osboxes --password osboxes.org --wait-stdout --wait-stderr -- -u root bash /home/osboxes/script.sh

timeout /t 5 /nobreak >nul

REM Checking SSH status
echo Checking if SSH is installed...
VBoxManage guestcontrol "%VMNAME%" run --exe "/usr/bin/sudo" --username osboxes --password osboxes.org --wait-stdout --wait-stderr -- /usr/bin/dpkg -l openssh-server > ssh_status.txt 2>nul
type ssh_status.txt | findstr /I /C:"ii  openssh-server" >nul
if errorlevel 1 (
	set installed=not installed
	echo SSH Server is not installed, rerunning the script...
	timeout /t 3 /nobreak >nul
	VBoxManage guestcontrol "%VMNAME%" run --exe "/usr/bin/sudo" --username osboxes --password osboxes.org --wait-stdout --wait-stderr -- -u root bash /home/osboxes/script.sh
	timeout /t 3 /nobreak >nul
    echo Let's check the installation again...
	pause
)

REM Checking SSH status again
VBoxManage guestcontrol "%VMNAME%" run --exe "/usr/bin/sudo" --username osboxes --password osboxes.org --wait-stdout --wait-stderr -- /usr/bin/dpkg -l openssh-server > ssh_status2.txt 2>nul
type ssh_status2.txt | findstr /I /C:"ii  openssh-server" >nul
if errorlevel 1 (
	set installed=not installed
	VBoxManage guestcontrol "%VMNAME%" run --exe "/usr/bin/sudo" --username osboxes --password osboxes.org --wait-stdout --wait-stderr -- -u root bash /home/osboxes/script.sh
	echo SSH installation failed, retrying again...
) else (
	set installed=installed
)

REM Checking SSH status again
VBoxManage guestcontrol "%VMNAME%" run --exe "/usr/bin/sudo" --username osboxes --password osboxes.org --wait-stdout --wait-stderr -- /usr/bin/dpkg -l openssh-server > ssh_status3.txt 2>nul
type ssh_status2.txt | findstr /I /C:"ii  openssh-server" >nul
if errorlevel 1 (
	set installed=not installed
	echo SSH installation failed, retry later...
) else (
	set installed=installed
)


echo SSH is %installed%.


del ssh_status.txt ssh_status2.txt ssh_status3.txt >nul

echo Let's start the Kali VM now...
timeout /t 5 /nobreak >nul
call "C:\Users\simon\OneDrive - Hogeschool Gent\2023-2024\Semester 2\2. Cybersecurity & Virtualisation\10. NPE\KALI.bat"
