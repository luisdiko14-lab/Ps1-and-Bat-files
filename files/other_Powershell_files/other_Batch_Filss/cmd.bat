echo off
title C:/Script.cmd
start
start
start Host-Name "Service1"
start-service "Service1"
echo Error!
echo Fixing
echo broken
echo re launching
echo done
title C:/Something.exe
echo MsgBox "Windows will be booted with HackedOs.iso", 64, "Message" > "%temp%\box.vbs"
cscript //nologo "%temp%\box.vbs"
del "%temp%\box.vbs"
