echo off
cls

echo Search directory...
if not exist c:\masm32 md c:\masm32
if not exist c:\masm32\include\ md c:\masm32\include\

if exist c:\masm32\include\io.asm ren c:\masm32\include\io.asm 

io.asm.bak

echo Copying files...
copy %cd%\io.asm c:\masm32\include\
timeout /t 10
