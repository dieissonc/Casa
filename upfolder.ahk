if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))	{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
#SingleInstance, force   
#NoTrayIcon
Sleep 100
RegRead,	local,	HKEY_CLASSES_ROOT, Folder\shell\Files UP\command
Localx:=StrSplit(local,""" """)
Loop,	Files,	%	localx[2] "\*.*"
{
	if(instr(A_LoopFileFullPath,".exe")=0 and instr(A_LoopFileFullPath,".txt")=0 and instr(A_LoopFileFullPath,".nfo")=0 and instr(A_LoopFileFullPath,".jpg")=0)
		FileMove,	%	A_LoopFileFullPath, %	SubStr(local,1,InStr(local,"\",,1,d.count()-1)) A_LoopFileName, 1
	else
		FileDelete,	%	A_LoopFileFullPath
}
FileRemoveDir,	% localx[2]"\",	1
ExitApp
