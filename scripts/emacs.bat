@echo off
set PATH=C:\msys64\ucrt64\bin;C:\msys64\usr\bin;%PATH%
C:\msys64\ucrt64\bin\runemacs.exe %*

rem C:\msys64\ucrt64\bin\emacsclientw.exe -c -n -a "C:\msys64\ucrt64\bin\runemacs.exe"
