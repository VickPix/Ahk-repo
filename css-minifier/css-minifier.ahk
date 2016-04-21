; GLOBAL =================================================================================
#SingleInstance, Force ; ALLOWS ONLY ONE RUNNING INSTANCE OF SCRIPT
#Persistent ; KEEPS SCRIPT PERMANENTLY RUNNING UNTIL TERMINATED
#NoEnv ; AVOIDS CHECKING EMPTY VARIABLES TO SEE If THEY ARE ENVIRONMENT VARIABLES
SendMode, Input ; RECOMMENDED FOR NEW SCRIPTS DUE TO ITS SUPERIOR SPEED AND RELIABILITY
SetWorkingDir, %A_ScriptDir% ; ENSURES A CONSISTENT STARTING DIRECTORY
SetBatchLines, -1 ; RUNS SCRIPT AT MAXIMUM SPEED/NEVER SLEEPS
#NoTrayIcon ; DISABLES THE SHOWING OF A TRAY ICON

Title := "CSS Minifier"
GuiW := 500 ; GUI WIDTH
GuiH := 350 ; GUI HEIGHT

#IfWinActive CSS Minifier

Gui, -Caption -Border -Resize +LastFound ; GUI OPTIONS
OnExit, ExitSub
Gui, Color, 2f3738 , 2f3738

Gui, Add, Text, % "x" GuiW-50 " y0 w50 h25 gGuiClose +BackgroundTrans" ; GUI EXIT
Gui, Add, Text,x0 y0 w%GuiW% h120 gUImove +BackgroundTrans ; GUI MOVE TRIGGER
Gui, Add, Progress, x0 y0 w%GuiW% h25  Backgroundc026a79, 0 ; GUI TOP TITLE
Gui, Add, Progress, x0 y+0 w%GuiW% h90  Backgroundc009fb7, 0 ; GUI MAIN TITLE
Gui, Add, Progress, x0 y+0 w%GuiW% h10  Backgroundc2a3132, 0 ; GUI TITLE BAR SHADOW
 
; Output TextBox
gui, font, s8, Verdana
Gui, Add, Edit, % "-E0x200 x" 10 " y+10m +BackgroundTrans w" GuiW-20 " r8 hwndhMyEdit vMyEdit cdddddd ReadOnly hidden"

; Label Compare
gui, font, s12, Verdana 
Gui, Add, Text, x0 y+10 w%GuiW% h40 +Center vCompareTxt hwndhCompareTxt +BackgroundTrans cffffff hidden, Compare 

; Label Exit
gui, font, s10, Verdana 
Gui, Add, Text, % "x" 0 " y" 5 " +Right +BackgroundTrans w" GuiW-15 " h30 gError hwndhTxt_esc vTxt_esc cffffff", EXIT: Press ESC or click HERE

; Label Title
gui, font, s26, Verdana 
Gui, Add, Text, hwndhTitle x35 y50 w%GuiW% h50 +BackgroundTrans cffffff, %Title% 

; Label center
gui, font, s12, Verdana 
Gui, Add, Text, x0 y+100m +BackgroundTrans w%GuiW% h200 center gOpenFile hwndhDropTxt vDropTxt ccccccc, /* Drop Your CSS File Here */ `n Or Click Here


gui, font, s14, Verdana 
Gui, Add, Text, % "section x" 28 " y" GuiH-60 " w" GuiW/4 " h" 30 " gUIReset vReset1 +Center +BackgroundTrans cffffff hidden"
Gui, Add, Progress, % " xs ys w" GuiW/4 " h" 30 " vReset2 Backgroundc009fb7 hidden", 0 
Gui, Add, Progress, % " y+0 w" GuiW/4 " h" 5 " vReset3 Background2a3132 hidden", 0 
Gui, Add, Text,% "xs ys+3 w" GuiW/4 " h" 30 " +Center vReset4 hwndhBtnReset +BackgroundTrans cffffff hidden", RESET 


Gui, Add, Text, % "section xs+160 ys w" GuiW/4 " h" 30 " gUISave vSave1 +Center +BackgroundTrans cffffff hidden"
Gui, Add, Progress, % " xs ys w" GuiW/4 " h" 30 " vSave2  Backgroundc009fb7 hidden", 0 
Gui, Add, Progress, % " y+0 w" GuiW/4 " h" 5 " vSave3 Background2a3132 hidden", 0 
Gui, Add, Text,% "xs ys+3 w" GuiW/4 " h" 30 " +Center vSave4 hwndhBtnSave +BackgroundTrans cffffff hidden ", SAVE 


Gui, Add, Text, % "section xs+160 ys w" GuiW/4 " h" 30 " gUICopy vCopy1 +Center +BackgroundTrans cffffff hidden"
Gui, Add, Progress, % " xs ys w" GuiW/4 " h" 30 " vCopy2 Backgroundc009fb7 hidden", 0 
Gui, Add, Progress, % " y+0 w" GuiW/4 " h" 5 " vCopy3 Background2a3132 hidden", 0 
Gui, Add, Text,% "xs ys+3 w" GuiW/4 " h" 30 " +Center vCopy4 hwndhBtnCopy +BackgroundTrans cffffff hidden", CRTL+C 

Gui, Show, w%GuiW% h%GuiH% , %Title%
ci:=1
Return

GuiDropFiles:
	StringSplit, F, A_GuiEvent, `n
	SelectedFile = %F1%
	if SubStr(SelectedFile, -2) = "css"
		{
		FileRead, Text, %SelectedFile%
	    GoSub CSSMinifier
		}else
		GoSub Error
 Return

OpenFile:
	if A_EventInfo=0 
	{
		FileSelectFile, SelectedFile, 3, , Open a file, CSS File(*.css)
		if SelectedFile =
			return
		else{
			if SubStr(SelectedFile, -2) = "css"
			{
			FileRead, Text, %SelectedFile%
		    GoSub CSSMinifier
			}else
			GoSub Error
		}
	}
	Return

CSSMinifier:
	StringLen, start_len, Text
	; **** CSS Minifier MAIN
	; ******************************************************
	RES := RegExReplace(Text, "/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/" ,"")
	RES := RegExReplace(RES, "(\n+|\t+|\r+)+" ,"")
	RES := RegExReplace(RES, "[ ]*}[ ]*","}")
	RES := RegExReplace(RES, "[ ]*{[ ]*","{")
	RES := RegExReplace(RES, "[ ]*:[ ]*",":")
	RES := RegExReplace(RES, "[ ]*,[ ]*",",")
	RES := RegExReplace(RES, "[ ]*;[ ]*",";")
	RES := RegExReplace(RES, "[ ]*![ ]*","!")
	; StringReplace, RES, RES, %A_TAB%, , All
	StringLen, end_len, RES
	SetFormat, float, 6.1
	start_len:=start_len/1000
	end_len:=end_len/1000
	Compare= Before:  ~%start_len% Kb    -    After:  ~%end_len% Kb
	GuiControl, Hide, DropTxt
	GuiControl, Show, MyEdit
	GuiControl, Show, CompareTxt
	GuiControl,, MyEdit, %RES%
	GuiControl,, CompareTxt, %compare%
	guiButtonToggle( "Reset", True )
	guiButtonToggle( "Save", True )
	guiButtonToggle( "Copy", True )
	Return

Error:
	MsgBox, 0, File Error, This is not a CSS file. 
	Return

UImove:
	PostMessage, 0xA1, 2,,, A
	Return

UISave:
	SplitPath, SelectedFile, name, dir, ext, name_no_ext
	FileSelectFile, SelectedSaveFile, S,%dir%\%name_no_ext%_min.%ext% , Save file, CSS File(*.css)
	if SelectedSaveFile =
		return
	else{
		SplitPath, SelectedSaveFile, name, dir, ext
		;MsgBox %name%, %dir%, %ext%
		if ext =
		{
			SelectedSaveFile = %SelectedSaveFile%.css
			GoSub SaveFile
		}
		else{
			if ext = css
				GoSub SaveFile
			else{
				MsgBox, 4,Warning, Extension is not .CSS `nAre you sure to continue?
				IfMsgBox Yes
				    GoSub SaveFile
				else
				    return
			}
		}
	}
	Return

SaveFile:
	IfExist, %SelectedSaveFile%
	{
		MsgBox, 4,Warning (File exists), File already exists.`nDo you want to overwrite it?
			IfMsgBox No
			    Return
		FileDelete, %SelectedSaveFile%
	}
	FileAppend, %RES%, %SelectedSaveFile%
	Return

UICopy:
	clipboard = %RES%
	MsgBox,0, Success, CSS copied to clipboard
	Return

UIReset:
	GuiControl,, MyEdit, 
	GuiControl, Hide, MyEdit
	GuiControl,, CompareTxt,
	GuiControl, Hide, CompareTxt
	guiButtonToggle( "Reset", False )
	guiButtonToggle( "Save", False )
	guiButtonToggle( "Copy", False )
	GuiControl, Show, DropTxt
	Return

GuiClose:
GuiEscape:
ExitSub:
	ExitApp

\::Reload

guiButtonToggle( conVar, tSt ) {
	Loop, 4
	    guiControl, % ( !tSt ) ? "hide" : "show", % conVar . a_index
}