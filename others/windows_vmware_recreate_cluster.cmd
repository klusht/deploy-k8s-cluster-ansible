SetLocal EnableDelayedExpansion

SET drive_path=%CD%
SET cluster_name=web-cluster
SET base_dir=c7_base
SET base_vmx_name=centos_7.vmx
SET start_script_name=start_VMs.cmd

REM --------------------------------------------------------------------------
ECHO Creating new folder
timeout 0
ECHO  DELETE AND recreates cluster folder
rd /s /q %cluster_name%
mkdir %cluster_name%




REM --------------------------------------------------------------------------
set "node_name=master"
set "cores=4"
set "memory=4096"

ECHO Copy base as !node_name!
Xcopy /E /I %base_dir% %cluster_name%\!node_name!

ECHO Update !node_name! node vmx
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'displayName = \".+\"', 'displayName = \"%cluster_name%_!node_name!\"' | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'numvcpus = \".+\"', 'numvcpus = \"%cores%\"'  | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'memsize = \".+\"', 'memsize = \"%memory%\"' | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"

ECHO ----- create shortcut
SET cSctVBS=CreateShortcut.vbs
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!drive_path!\!cluster_name!\!node_name!.lnk"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
  echo oLink.TargetPath = "C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
  echo oLink.Arguments = "!drive_path!\!cluster_name!\!node_name!\!base_vmx_name!"
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q )



ECHO ------- add vm to start all script
((
  echo start !drive_path!\!cluster_name!\!node_name!
)1>%cluster_name%\%start_script_name% )



REM --------------------------------------------------------------------------
set "pool_name=medium"
SET "cores=4"
SET "memory=4096"

for /l %%x in (1, 1, 2) do (

Set "node_name=node-%pool_name%-%%x"

ECHO Copy base as %cluster_name%\!node_name!
Xcopy /E /I %base_dir% %cluster_name%\!node_name!

ECHO Update !node_name! node vmx
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'displayName = \".+\"', 'displayName = \"%cluster_name%_!node_name!\"' | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'numvcpus = \".+\"', 'numvcpus = \"%cores%\"'  | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'memsize = \".+\"', 'memsize = \"%memory%\"' | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"

ECHO ----- create shortcut
SETLOCAL ENABLEDELAYEDEXPANSION
SET cSctVBS=CreateShortcut.vbs
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!drive_path!\!cluster_name!\!node_name!.lnk"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
  echo oLink.TargetPath = "C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
  echo oLink.Arguments = "!drive_path!\!cluster_name!\!node_name!\!base_vmx_name!"
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q )

ECHO ------- add vm to start all script
((
  echo start !drive_path!\!cluster_name!\!node_name!
)1>>%cluster_name%\%start_script_name% )


)

REM --------------------------------------------------------------------------
set "pool_name=small"
SET "cores=2"
SET "memory=2048"

for /l %%x in (1, 1, 2) do (

Set "node_name=node-%pool_name%-%%x"

ECHO Copy base as %cluster_name%\!node_name!
Xcopy /E /I %base_dir% %cluster_name%\!node_name!

ECHO Update !node_name! node vmx
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'displayName = \".+\"', 'displayName = \"%cluster_name%_!node_name!\"' | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'numvcpus = \".+\"', 'numvcpus = \"%cores%\"'  | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"
powershell -Command "(gc %cluster_name%\!node_name!\%base_vmx_name%) -replace 'memsize = \".+\"', 'memsize = \"%memory%\"' | Out-File -encoding ASCII %cluster_name%\!node_name!\%base_vmx_name%"

ECHO ----- create shortcut
SETLOCAL ENABLEDELAYEDEXPANSION
SET cSctVBS=CreateShortcut.vbs
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!drive_path!\!cluster_name!\!node_name!.lnk"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
  echo oLink.TargetPath = "C:\Program Files (x86)\VMware\VMware Player\vmplayer.exe"
  echo oLink.Arguments = "!drive_path!\!cluster_name!\!node_name!\!base_vmx_name!"
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q )

ECHO ------- add vm to start all script
((
  echo start !drive_path!\!cluster_name!\!node_name!
)1>>%cluster_name%\%start_script_name% )


)