; GLOBAL =================================================================================
#SingleInstance, Force ; ALLOWS ONLY ONE RUNNING INSTANCE OF SCRIPT
#Persistent ; KEEPS SCRIPT PERMANENTLY RUNNING UNTIL TERMINATED
#NoEnv ; AVOIDS CHECKING EMPTY VARIABLES TO SEE If THEY ARE ENVIRONMENT VARIABLES
; #Warn ; ENABLES WARNINGS TO ASSIST WITH DETECTING COMMON ERRORS
#Include Class_CustomFont.ahk
SendMode, Input ; RECOMMENDED FOR NEW SCRIPTS DUE TO ITS SUPERIOR SPEED AND RELIABILITY
SetWorkingDir, %A_ScriptDir% ; ENSURES A CONSISTENT STARTING DIRECTORY
SetBatchLines, -1 ; RUNS SCRIPT AT MAXIMUM SPEED/NEVER SLEEPS
#NoTrayIcon ; DISABLES THE SHOWING OF A TRAY ICON

GuiW := 500 ; GUI WIDTH
GuiH := 400 ; GUI HEIGHT

Gui, -Caption -Border -Resize +LastFound ; GUI OPTIONS
OnExit, ExitSub

CustomFont.Add("opensans-mod.ttf")
CustomFont.Add("sourcecodepro-mod.ttf")
font1 := New CustomFont("res:dejavufont.ttf", "DejaVu Sans Mono", 20)
font2 := New CustomFont("res:Aaargh.ttf", "Aaargh", 14)

Gui, Font, s14 c009fb7, Source Code Pro
Gui, Color, 2f3738, 2f3738

Gui, Add, Text,x0 y0 w%GuiW% h120 gUImove +BackgroundTrans ; GUI MOVE TRIGGER
Gui, Add, Progress, x0 y0 w%GuiW% h25  Background026a79, 0 ; GUI TOP TITLE
Gui, Add, Progress, x0 y+m w%GuiW% h90  Backgroundc009fb7, 0 ; GUI MAIN TITLE
Gui, Add, Progress, x0 y+m w%GuiW% h10  Backgroundc2a3132, 0 ; GUI TITLE BAR SHADOW

Gui, Font, s8, Source Code Pro
Gui, Add, Edit, % "-E0x200 x" 10 " y+10m +BackgroundTrans w" GuiW-20 " r8 hwndhMyEdit vMyEdit cdddddd ReadOnly hidden"

Gui, Font, s12 cffffff, Open Sans
Gui, Add, Text, x0 y+p w%GuiW% h40 +Center vCompareTxt +BackgroundTrans cffffff hidden, Compare 

Gui, Font, s10
Gui, Add, Text, % "x" 0 " y" 5 " +Right +BackgroundTrans w" GuiW-25 " h30 vTxt_esc cffffff", Press ESC to quit

Gui, Font, s30
Gui, Add, Text, hwndhTitle x35 y45 w%GuiW% h50 +BackgroundTrans cffffff, Minified CSS 

Gui, Font, s12, Source Code Pro
Gui, Add, Text, x0 y+150m +BackgroundTrans w%GuiW% h200 center hwndhDropTxt vDropTxt ccccccc, /* Drop Your CSS File Here */


Gui, Font, s12 cffffff, Open Sans


Gui, Add, Text, % "section x" 28 " y" GuiH-60 " w" GuiW/4 " h" 30 " gUIReset vReset1 +Center +BackgroundTrans cffffff hidden"
Gui, Add, Progress, % " xs ys w" GuiW/4 " h" 30 " vReset2 Backgroundc009fb7 hidden", 0 
Gui, Add, Progress, % " y+m w" GuiW/4 " h" 5 " vReset3 Background2a3132 hidden", 0 
Gui, Add, Text,% "xs ys+3 w" GuiW/4 " +Center vReset4 +BackgroundTrans cffffff hidden", RESET 


Gui, Add, Text, % "section xs+160 ys w" GuiW/4 " h" 30 " gUISave vSave1 +Center +BackgroundTrans cffffff hidden"
Gui, Add, Progress, % " xs ys w" GuiW/4 " h" 30 " vSave2  Backgroundc009fb7 hidden", 0 
Gui, Add, Progress, % " y+m w" GuiW/4 " h" 5 " vSave3 Background2a3132 hidden", 0 
Gui, Add, Text,% "xs ys+3 w" GuiW/4 " +Center vSave4 +BackgroundTrans cffffff hidden ", SAVE 


Gui, Add, Text, % "section xs+160 ys w" GuiW/4 " h" 30 " gUICopy vCopy1 +Center +BackgroundTrans cffffff hidden"
Gui, Add, Progress, % " xs ys w" GuiW/4 " h" 30 " vCopy2 Backgroundc009fb7 hidden", 0 
Gui, Add, Progress, % " y+m w" GuiW/4 " h" 5 " vCopy3 Background2a3132 hidden", 0 
Gui, Add, Text,% "xs ys+3 w" GuiW/4 " +Center vCopy4 +BackgroundTrans cffffff hidden", CRTL+C 

Gui, Show, w%GuiW% h%GuiH%, Minified CSS
ci:=1
Return

GuiDropFiles:
 StringSplit, F, A_GuiEvent, `n
 FileRead, Text, %F1%
 StringLen, start_len, Text
; **** PULIZIA CSS
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
;Msgbox %end_len%
SetFormat, float, 6.1
start_len:=start_len/1000
end_len:=end_len/1000
Compare= Before:  ~%start_len% Kb    -    After:  ~%end_len% Kb
GuiControl, Hide, DropTxt
GuiControl, Show, MyEdit
GuiControl, Show, CompareTxt
GuiControl,, MyEdit, %RES%
GuiControl,, CompareTxt, %compare%
;clipboard = %RES%

guiButtonToggle( "Reset", True )
guiButtonToggle( "Save", True )
guiButtonToggle( "Copy", True )


;GoSub ToggleBtn
Return

UImove:
PostMessage, 0xA1, 2,,, A
Return

UISave:
Msgbox Save
;GuiControl, +cRed, SaveProgress
Return

UICopy:
Msgbox Copy
;GuiControl, +cRed, SaveProgress
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
 ExitApp

 ToggleBtn:
 GuiControl, Hide, c%ci%
 ci := ci=1 ? 2 : 1
 GuiControl, Show, c%ci%
 Return

ExitSub:
	CustomFont.Remove()
ExitApp

\::Reload

1::guiButtonToggle( "Copy", True )

guiButtonToggle( conVar, tSt ) {
	Loop, 4
	{
	    guiControl, % ( !tSt ) ? "hide" : "show", % conVar . a_index
	    
	    ;Sleep, 100
	}
}

guiDisplayToggle( conVar, tSt ) {
  guiControl, % ( tSt ) ? "hide" : "show", % conVar
}

; *.ttf files can be compiled into the executable.
FileInstall, Aaargh.ttf, -
FileInstall, dejavufont.ttf, -