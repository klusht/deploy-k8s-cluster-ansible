@echo off
SetLocal EnableDelayedExpansion



REM ####  Minimum update details
SET drive_path=%CD%
SET cluster_name=web-cluster
REM # The folder of the base OS VMX this can differ from the config file
SET base_dir=c7_base
REM # Configuration vmx file
SET base_vmx_name=c7_base.vmx
REM name of the start all script
SET start_script_name=start_VMs.cmd
REM --------------------------------------------------------------------------
ECHO 1 - Creating new folder
timeout 0
ECHO 1 - DELETE AND Create cluster folder
rd /s /q %cluster_name%
mkdir %cluster_name%

REM Define pool [CPU-Cores,MEM size]
SET "poolLarge=8,8192"
SET "poolMedium=4,4096"
SET "poolSmall=2,2048"

REM SET your Reserved MAC addresses. Same IPs need to be set into build_host_file.sh
SET "vm[0]=00:00:00:00:00:01,k-master,poolMedium"    REM 192.168.0.100
SET "vm[1]=00:00:00:00:00:02,k-L-node-0,poolLarge"   REM 192.168.0.101
SET "vm[2]=00:00:00:00:00:03,k-L-node-1,poolLarge"   REM 192.168.0.102
SET "vm[3]=00:00:00:00:00:04,k-M-node-0,poolMedium"  REM 192.168.0.103
SET "vm[4]=00:00:00:00:00:05,k-M-node-1,poolMedium"  REM 192.168.0.104
SET "vm[5]=00:00:00:00:00:06,k-S-node-0,poolSmall"   REM 192.168.0.105
SET "vm[6]=00:00:00:00:00:07,k-S-node-1,poolSmall"   REM 192.168.0.106


set "x=0"
:SymLoop
if defined vm[%x%] set /a "x+=1" & GOTO :SymLoop
SET /a x=%x%-1



for /l %%n in (0,1,%x%) do (

  FOR /f "tokens=1,2,3 delims=," %%a IN ("!vm[%%n]!") do (

    set mac=%%a
	set name=%%b
	set pool=!%%c!
    REM echo -- !mac!
	REM echo -- !name!
	REM echo -- !pool!
	FOR /f "tokens=1,2 delims=," %%a IN ("!pool!") do (
	  set cores=%%a
	  set ram=%%b



ECHO START OF !name! ----------------------------------------------------------------
ECHO Copy base as !name!
Xcopy /E /I /q %base_dir% %cluster_name%\!name!

ECHO Update !name! node vmx
powershell -Command "(gc %cluster_name%\!name!\%base_vmx_name%) -replace 'displayName = \".+\"', 'displayName = \"!name!_%cluster_name%\"' | Out-File -encoding ASCII %cluster_name%\!name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!name!\%base_vmx_name%) -replace 'numvcpus = \".+\"', 'numvcpus = \"!cores!\"'  | Out-File -encoding ASCII %cluster_name%\!name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!name!\%base_vmx_name%) -replace 'memsize = \".+\"', 'memsize = \"!ram!\"' | Out-File -encoding ASCII %cluster_name%\!name!\%base_vmx_name%"
REM Update MAC
powershell -Command "(gc %cluster_name%\!name!\%base_vmx_name%) -replace 'ethernet0.addressType = \".+\"', 'ethernet0.addressType = \"static\"' | Out-File -encoding ASCII %cluster_name%\!name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!name!\%base_vmx_name%) -replace 'ethernet0.generatedAddress = \".+\"', 'ethernet0.Address = \"!mac!\"' | Out-File -encoding ASCII %cluster_name%\!name!\%base_vmx_name%"

ECHO Create Windows Shortcut for !name!
SET cSctVBS=CreateShortcut.vbs
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!drive_path!\!cluster_name!\!name!.lnk"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
  echo oLink.TargetPath = "C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
  echo oLink.Arguments = "!drive_path!\!cluster_name!\!name!\!base_vmx_name!"
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q )

ECHO Add vm to start all script
((
  echo start !drive_path!\!cluster_name!\!name!
)1>>%cluster_name%\%start_script_name% )

((
  echo timeout 1
)1>>%cluster_name%\%start_script_name% )

ECHO END OF !name! ----------------------------------------------------------------
	)
  )
)



