#SingleInstance Force
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
return
~RButton::
oAcc:=Acc_ObjectFromPoint(vChildID)
MouseGetPos,,, hWnd, vCtlClassNN
WinGetClass, vWinClass, % "ahk_id " hWnd
vText := ""
if (vWinClass="CabinetWClass" or vWinClass="ExploreWClass")
	try vText := oAcc.accValue(vChildID)
else
	return
Send, ^c
sleep, 100
RegDelete, HKEY_CLASSES_ROOT\Folder\shell\Files UP\command
RegWrite, REG_SZ, HKEY_CLASSES_ROOT\Folder\shell\Files UP\command, , %	"""C:\\Dih\\upfolder.exe"" """ clipboard """ " """`%1"""
;~ ToolTip,	%	vText "`n" A_, 50, 50 
;~ ToolTip	%	vText

oAcc:=""
Acc_Init()	{
	Static	h
	If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromPoint(ByRef _idChild_="", x="", y="")	{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromPoint", "Int64", x==""||y==""?0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
	Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}