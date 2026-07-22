$instance = C:\'Program Files (x86)'\'Microsoft Visual Studio'\Installer\vswhere.exe -latest -property instanceid
Import-Module "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
Enter-VsDevShell $instance -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"
