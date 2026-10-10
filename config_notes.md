# Various commands used to configure Windows Shit

## This is what added the qsetup.bat file to be run whenever opening a command prompt
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "G:\dev_tools\Qsetup\qsetup.bat" /f



## TODO 
 - Port the Qsetup tool to odin

