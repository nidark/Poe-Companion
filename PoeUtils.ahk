#IfWinActive Path of Exile
#SingleInstance force
#NoEnv  
#Warn  
#Persistent 
#MaxThreadsPerHotkey 2

SetTitleMatchMode 3
SendMode Input  
CoordMode, Mouse, Client
SetWorkingDir %A_ScriptDir%  
Thread, interrupt, 0

; The most updated version is always here: https://github.com/nidark/PoeUtils
; Support: https://discord.gg/qfDkyTs
 
; If you need to make changes, DONT change the variables from the script! 
; Change them in the INI file!

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Most of the functions will work without any changes for windowed full-screen 1920x1080, having the wisdom & portal scrolls respectively on the last 2 positions of the first row. 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; The SwichGem function & Main/Secondary attack auto pot will work only if you have the same setup like me.   
; BUT most probably you will need to adjust those positions in INI using "ALT+O", as this is mostly character & skill-key based.
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; For different setups (resolution and/or scroll positions) you need to use the "ALT+O" function and change the coordonates in teh INI file.
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Legend:
; ! = Alt
; ^ = Ctrl
; + = Shift 

; Global variables -> Default setup for 1920x1080, having wisdom & portal scrolls respectively on the last 2 positions of the first row.  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; DON'T CHANGE them here. If you need to make changes, do change the INI file!
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;General
global CtrlLoopCount=50
global ShiftLoopCount=50
global InventoryColumnsToMove=10
global InventoryRowsToMove=5
global KeyToKeepPress="Q"

; Dont change the speed & the tick unless you know what you are doing
global Speed=1
global Tick=250

;Coordinates
global CellWith=53
global InventoryX=1297
global InventoryY=616
global StashX=41
global StashY=188
global PortalScrollX=1859
global PortalScrollY=616
global WisdomScrollX=1820
global WisdomScrollY=616
global TradeButtonX=628
global TradeButtonY=735	
global TradedItemX=646
global TradedItemY=565
global GuiX=215
global GuiY=935

;ItemSwap
global CurrentGemX=1483
global CurrentGemY=372
global AlternateGemX=1379 
global AlternateGemY=171
global AlternateGemOnSecondarySlot=1

;AutoPot Setup
global ChatColor=0x2E8BD1
global ChatX1=13
global ChatY1=875
global ChatX2=20
global ChatY2=890

global HPColor=0x2112B1
global HPX1=100
global HPY1=873
global HPX2=132
global HPY2=1077

global HPQuitTreshold=25 ; dont go lower than 25
global HPLowTreshold=40
global HPAvgTreshold=65
global HPHighTreshold=90 ; don't go higer than 90
global MainAttackKey="Q"
global SecondaryAttackKey="W"

;The default flask setup/example is based on the following assumptions, but you can use any flask and any trigger combinations by changing the setup in the INI file
; Flask 1 = Dot life flask with long effect (>7 sec - see also cooldowns)  
; Flask 2 = Offensive (ex Sulphur, Diamond)
; Flask 3 = Offensive/Defensive (ex Atziri)
; Flask 4 = Defensive (ex Basalt, Stibnite)
; Flask 5 = Instant HP 

;On low hp we fire all flasks
global TriggerHPLow=11111
;on avg HP we fire all, excepting main attack and instant HP
global TriggerHPAvg=10110
;on avg HP we fire the first flask and the 4th flask
global TriggerHPHigh=10010
;On pressing the main attack we fire the main attack flask
global TriggerMainAttack=01000
;On pressing the main attack we fire both attack flasks
global TriggerSecondaryAttack=01100

; Cooldowns for each of the 5 Flasks
global CoolDownFlask1:=7000
global CoolDownFlask2:=5000
global CoolDownFlask3:=5000
global CoolDownFlask4:=5000
global CoolDownFlask5:=500

; Not in INI
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
global HPY=HPY2-HPY1
global Trigger=00000
global AutoQuit=0 
global AutoPot=0 
global CurrentHP=100
global KeyOn:=False
global Flask=1
global OnCoolDown:=[0,0,0,0,0]
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IfNotExist, cports.exe
{
UrlDownloadToFile, http://lutbot.com/ahk/cports.exe, cports.exe
        if ErrorLevel
                MsgBox, Error ED02 : There was a problem downloading cports.exe
UrlDownloadToFile, http://lutbot.com/ahk/cports.chm, cports.chm
        if ErrorLevel
                MsgBox, Error ED03 : There was a problem downloading cports.chm 
UrlDownloadToFile, http://lutbot.com/ahk/readme.txt, readme.txt
        if ErrorLevel
                MsgBox, Error ED04 : There was a problem downloading readme.txt
}


If FileExist("PoeUtils.ini"){ 
	IniRead, CtrlLoopCount, PoeUtils.ini, General, CtrlLoopCount
	IniRead, ShiftLoopCount, PoeUtils.ini, General, ShiftLoopCount
	IniRead, InventoryColumnsToMove, PoeUtils.ini, General, InventoryColumnsToMove
	IniRead, InventoryRowsToMove, PoeUtils.ini, General, InventoryRowsToMove	
	IniRead, KeyToKeepPress, PoeUtils.ini, General, KeyToKeepPress
	IniRead, Speed, PoeUtils.ini, General, Speed
	IniRead, Tick, PoeUtils.ini, General, Tick
	
	IniRead, CellWith, PoeUtils.ini, Coordinates, CellWith
	IniRead, InventoryX, PoeUtils.ini, Coordinates, InventoryX
	IniRead, InventoryY, PoeUtils.ini, Coordinates, InventoryY
	IniRead, StashX, PoeUtils.ini, Coordinates, StashX
	IniRead, StashY, PoeUtils.ini, Coordinates, StashY
	IniRead, PortalScrollX, PoeUtils.ini, Coordinates, PortalScrollX
	IniRead, PortalScrollY, PoeUtils.ini, Coordinates, PortalScrollY
	IniRead, WisdomScrollX, PoeUtils.ini, Coordinates, WisdomScrollX
	IniRead, WisdomScrollY, PoeUtils.ini, Coordinates, WisdomScrollY
	IniRead, TradeButtonX, PoeUtils.ini, Coordinates, TradeButtonX
	IniRead, TradeButtonY, PoeUtils.ini, Coordinates, TradeButtonY
	IniRead, TradedItemX, PoeUtils.ini, Coordinates, TradedItemX
	IniRead, TradedItemY, PoeUtils.ini, Coordinates, TradedItemY
	IniRead, GuiX, PoeUtils.ini, Coordinates, GuiX
	IniRead, GuiY, PoeUtils.ini, Coordinates, GuiY
		
	IniRead, CurrentGemX, PoeUtils.ini, ItemSwap, CurrentGemX
	IniRead, CurrentGemY, PoeUtils.ini, ItemSwap, CurrentGemY
	IniRead, AlternateGemX, PoeUtils.ini, ItemSwap, AlternateGemX
	IniRead, AlternateGemY, PoeUtils.ini, ItemSwap, AlternateGemY
	IniRead, AlternateGemOnSecondarySlot, PoeUtils.ini, ItemSwap, AlternateGemOnSecondarySlot
		
	IniRead, ChatColor, PoeUtils.ini, AutoPot, ChatColor
	IniRead, ChatX1, PoeUtils.ini, AutoPot, ChatX1
 	IniRead, ChatY1, PoeUtils.ini, AutoPot, ChatY1
 	IniRead, ChatX2, PoeUtils.ini, AutoPot, ChatX2
 	IniRead, ChatY2, PoeUtils.ini, AutoPot, ChatY2
 	IniRead, HPColor, PoeUtils.ini, AutoPot, HPColor
	IniRead, HPX1, PoeUtils.ini, AutoPot, HPX1
	IniRead, HPY1, PoeUtils.ini, AutoPot, HPY1
	IniRead, HPX2, PoeUtils.ini, AutoPot, HPX2
	IniRead, HPY2, PoeUtils.ini, AutoPot, HPY2
	IniRead, HPQuitTreshold, PoeUtils.ini, AutoPot, HPQuitTreshold
 	IniRead, HPLowTreshold, PoeUtils.ini, AutoPot, HPLowTreshold
	IniRead, HPAvgTreshold, PoeUtils.ini, AutoPot, HPAvgTreshold
	IniRead, HPHighTreshold, PoeUtils.ini, AutoPot, HPHighTreshold
 	IniRead, MainAttackKey, PoeUtils.ini, AutoPot, MainAttackKey
	IniRead, SecondaryAttackKey, PoeUtils.ini, AutoPot, SecondaryAttackKey
	IniRead, TriggerHPLow, PoeUtils.ini, AutoPot, TriggerHPLow
	IniRead, TriggerHPAvg, PoeUtils.ini, AutoPot, TriggerHPAvg
	IniRead, TriggerHPHigh, PoeUtils.ini, AutoPot, TriggerHPHigh
	IniRead, TriggerMainAttack, PoeUtils.ini, AutoPot, TriggerMainAttack
	IniRead, TriggerSecondaryAttack, PoeUtils.ini, AutoPot, TriggerSecondaryAttack
	IniRead, CoolDownFlask1, PoeUtils.ini, AutoPot, CoolDownFlask1
	IniRead, CoolDownFlask2, PoeUtils.ini, AutoPot, CoolDownFlask2
	IniRead, CoolDownFlask3, PoeUtils.ini, AutoPot, CoolDownFlask3
	IniRead, CoolDownFlask4, PoeUtils.ini, AutoPot, CoolDownFlask4
	IniRead, CoolDownFlask5, PoeUtils.ini, AutoPot, CoolDownFlask5
 	
} else {
	
	IniWrite, %CtrlLoopCount%, PoeUtils.ini, General, CtrlLoopCount
	IniWrite, %ShiftLoopCount%, PoeUtils.ini, General, ShiftLoopCount
	IniWrite, %InventoryColumnsToMove%, PoeUtils.ini, General, InventoryColumnsToMove
	IniWrite, %InventoryRowsToMove%, PoeUtils.ini, General, InventoryRowsToMove	
	IniWrite, %KeyToKeepPress%, PoeUtils.ini, General, KeyToKeepPress
	IniWrite, %Speed%, PoeUtils.ini, General, Speed
	IniWrite, %Tick%, PoeUtils.ini, General, Tick
	
	IniWrite, %CellWith%, PoeUtils.ini, Coordinates, CellWith
	IniWrite, %InventoryX%, PoeUtils.ini, Coordinates, InventoryX
	IniWrite, %InventoryY%, PoeUtils.ini, Coordinates, InventoryY
	IniWrite, %StashX%, PoeUtils.ini, Coordinates, StashX
	IniWrite, %StashY%, PoeUtils.ini, Coordinates, StashY
	IniWrite, %PortalScrollX%, PoeUtils.ini, Coordinates, PortalScrollX
	IniWrite, %PortalScrollY%, PoeUtils.ini, Coordinates, PortalScrollY
	IniWrite, %WisdomScrollX%, PoeUtils.ini, Coordinates, WisdomScrollX
	IniWrite, %WisdomScrollY%, PoeUtils.ini, Coordinates, WisdomScrollY
	IniWrite, %TradeButtonX%, PoeUtils.ini, Coordinates, TradeButtonX
	IniWrite, %TradeButtonY%, PoeUtils.ini, Coordinates, TradeButtonY
	IniWrite, %TradedItemX%, PoeUtils.ini, Coordinates, TradedItemX
	IniWrite, %TradedItemY%, PoeUtils.ini, Coordinates, TradedItemY
	IniWrite, %GuiX%, PoeUtils.ini, Coordinates, GuiX
	IniWrite, %GuiY%, PoeUtils.ini, Coordinates, GuiY
	
	IniWrite, %CurrentGemX%, PoeUtils.ini, ItemSwap, CurrentGemX
	IniWrite, %CurrentGemY%, PoeUtils.ini, ItemSwap, CurrentGemY
	IniWrite, %AlternateGemX%, PoeUtils.ini, ItemSwap, AlternateGemX
	IniWrite, %AlternateGemY%, PoeUtils.ini, ItemSwap, AlternateGemY
	IniWrite, %AlternateGemOnSecondarySlot%, PoeUtils.ini, ItemSwap, AlternateGemOnSecondarySlot
	
	IniWrite, %ChatColor%, PoeUtils.ini, AutoPot, ChatColor
	IniWrite, %ChatX1%, PoeUtils.ini, AutoPot, ChatX1
 	IniWrite, %ChatY1%, PoeUtils.ini, AutoPot, ChatY1
 	IniWrite, %ChatX2%, PoeUtils.ini, AutoPot, ChatX2
 	IniWrite, %ChatY2%, PoeUtils.ini, AutoPot, ChatY2
 	IniWrite, %HPColor%, PoeUtils.ini, AutoPot, HPColor
	IniWrite, %HPX1%, PoeUtils.ini, AutoPot, HPX1
	IniWrite, %HPY1%, PoeUtils.ini, AutoPot, HPY1
	IniWrite, %HPX2%, PoeUtils.ini, AutoPot, HPX2
	IniWrite, %HPY2%, PoeUtils.ini, AutoPot, HPY2
	IniWrite, %HPQuitTreshold%, PoeUtils.ini, AutoPot, HPQuitTreshold
 	IniWrite, %HPLowTreshold%, PoeUtils.ini, AutoPot, HPLowTreshold
	IniWrite, %HPAvgTreshold%, PoeUtils.ini, AutoPot, HPAvgTreshold
	IniWrite, %HPHighTreshold%, PoeUtils.ini, AutoPot, HPHighTreshold
 	IniWrite, %MainAttackKey%, PoeUtils.ini, AutoPot, MainAttackKey
	IniWrite, %SecondaryAttackKey%, PoeUtils.ini, AutoPot, SecondaryAttackKey
	IniWrite, %TriggerHPLow%, PoeUtils.ini, AutoPot, TriggerHPLow
	IniWrite, %TriggerHPAvg%, PoeUtils.ini, AutoPot, TriggerHPAvg
	IniWrite, %TriggerHPHigh%, PoeUtils.ini, AutoPot, TriggerHPHigh
	IniWrite, %TriggerMainAttack%, PoeUtils.ini, AutoPot, TriggerMainAttack
	IniWrite, %TriggerSecondaryAttack%, PoeUtils.ini, AutoPot, TriggerSecondaryAttack
	IniWrite, %CoolDownFlask1%, PoeUtils.ini, AutoPot, CoolDownFlask1
	IniWrite, %CoolDownFlask2%, PoeUtils.ini, AutoPot, CoolDownFlask2
	IniWrite, %CoolDownFlask3%, PoeUtils.ini, AutoPot, CoolDownFlask3
	IniWrite, %CoolDownFlask4%, PoeUtils.ini, AutoPot, CoolDownFlask4
	IniWrite, %CoolDownFlask5%, PoeUtils.ini, AutoPot, CoolDownFlask5
}

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Gui 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui, Color, 0X130F13
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, 0X130F13
Gui -Caption
Gui, Font, bold cFFFF00 S9, Trebuchet MS
Gui, Add, Text, y+0.5 BackgroundTrans vT1, [F12] A-POTS: OFF
Gui, Add, Text, y+0.5 BackgroundTrans vT2, [F11] A-QUIT: OFF
Gui, Show, x%GuiX% y%GuiY%
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; KEY Binding
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!WheelDown::Send {Right} ; ALT+WheelDown: Stash scroll 
!WheelUp::Send {Left} ; ALT+WheelUp: Stash scroll
^WheelDown::AutoClicks() ; CTRL+WheelDown -> Spam CTRL+CLICK
+WheelDown::AutoClicks() ; SHIFT+WheelDown -> Spam SHIFT+CLICK    
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!G::Send {Enter} /global 820 {Enter} ; ALT+G
!T::Send {Enter} /trade 820 {Enter} ; ALT+T
!H::Send {Enter} /hideout {Enter} ; ALT+H
!R::Send {Enter} /remaining {Enter} ; ALT+R
!B::Send {Enter} /abandon_daily {Enter} ; ALT+B
!L::Send {Enter} /itemlevel {Enter} ; ALT+L
!P::Send {Enter} /passives {Enter} ; ALT+P
!E::Send {Enter} /exit {Enter} ; ALT+E: Exit to char selection
!Y::Send ^{Enter}{Home}{Delete}/invite {Enter} ;ALT+Y: Invite the last char who whispered you to party; works no matter the resolution or any item positioning
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!F1::ExitApp  ; Alt+F1: Exit the script
!Q::Logout() ; ALT+Q: Fast logout  
!O::CheckPos() ; ALT+O Get the cursor position. Use it to change the position setup for Identify, OpenPortal, SwitchGem etc
!S::POTSpam() ; Alt+S for 5 times will press 1,2,3,4,4 in fast seqvence 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; The following macros are NOT ALLOWED by GGG (EULA), as we send multiple server actions with one button pressed
; This can't be identified as we randomize all timmings, but dont use it if you want to stick with the EULA 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!Space::OpenPortal() ; ALT+Space: Open a portal using a portal scroll from the top right inv slot; use CheckPos to change portal scroll position if needed
`::POT12345() ; `: Pressing ` once will press 1,2,3,4,5 in fast seqvence 
!I::Identify(InventoryX,InventoryY,InventoryRowsToMove,InventoryColumnsToMove) ; ALT+I: Id all the items from Inventory 
+I::Identify(StashX,StashY,12,12) ; SHIFT:I: Id all Items from the opened stash tab
!C::CtrlClick(InventoryX,InventoryY,InventoryRowsToMove,InventoryColumnsToMove) ; ALT+C: CtrlClick full inventory excepting the last 2 columns
+C::CtrlClick(StashX,StashY,12,4) ; SHIFT+C: CtrlClick the opened stash tab to move 12 X 4 rows x columns to the Inventory
!X::CtrlClick(-1,-1,12,4) ; ALT+X: CtrClick the opened tab from the MousePointer (needs to be a top cell)
!Z::CtrlClickLoop(CtrlLoopCount) ; ALT + Z : 50 X CtrlClick at the current mouse location (ex: buys currency from vendors)
!F::ShiftClick(ShiftLoopCount) ; ShiftClick 50 times (Use it for Fusings/Jewler 6s/6l crafting) 
!M::SwitchGem() ;Alt+M to switch 2 gems (eg conc effect with area). Use CheckPos to change the positions in the function! 
!V::DivTrade() ;Alt+V trade all your divinations ; use CheckPos to change position if needed
!U::KeepKeyPressed()
F11::
   AutoQuit := !AutoQuit
   GuiUpdate()
   if ((!AutoPot) and (!AutoQuit)) {
        SetTimer, GameTick, Off
    } else {
        SetTimer, GameTick, %Tick%	
    }
return
F12::
    AutoPot := !AutoPot
	GuiUpdate()	
	if ((!AutoPot) and (!AutoQuit)) {
        SetTimer, GameTick, Off
    } else {
        SetTimer, GameTick, %Tick%	
    }
return
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return

; Functions
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RandomSleep(min,max){
	Random, r, %min%, %max%
	r:=floor(r/Speed)
	Sleep %r%
	return
}
AutoClicks(){
BlockInput On 
Send {blind}{Lbutton down}{Lbutton up} 
BlockInput Off
}
DivTrade() {
	BlockInput On
	RandomSleep(113,138)
		
	x := InventoryX
	y := InventoryY
	
	Loop 10 { ;not 12 as we dont ctrl-move the last 2 columns (we keep there the scrols and other permanent inv stuff)
		Loop 5 { 
			if GetKeyState("[") = 1 ; Keep[ [ pressed to quit in the middle of the loop
				break
			
			MouseMove , x, y
			RandomSleep(56,68)
			send ^{Click}
			RandomSleep(56,68)
			
			Mousemove, TradeButtonX, TradeButtonY
			RandomSleep(56,68)
			send ^{Click}
			RandomSleep(56,68)
			
			MouseMove, TradedItemX, TradedItemY
			RandomSleep(56,68)
			send ^{Click}
			RandomSleep(56,68)
			
			y += CellWith			
		}
		y := InventoryY
		x += CellWith
	}
	
	BlockInput Off
	return
}
SwitchGEM() {
	BlockInput On
	RandomSleep(151,163)

	Send {F2} 
	RandomSleep(56,68)
	
	Send {i} 
	RandomSleep(56,68)

	if (AlternateGemOnSecondarySlot==1) 
		Send {X} 
	RandomSleep(56,68)
	
	MouseMove %AlternateGemX%, %AlternateGemY%
	RandomSleep(56,68)
	Click, Right 
	RandomSleep(56,68)
	
	MouseMove %CurrentGemX%, %CurrentGemY%
	RandomSleep(56,68)
	Click  
	RandomSleep(56,68)
	
	MouseMove %AlternateGemX%, %AlternateGemY%
	RandomSleep(56,68)
	Click
	RandomSleep(56,68)
	
	if (AlternateGemOnSecondarySlot==1) 
		Send {X} 
	RandomSleep(56,68)
	
	Send {i} 
	BlockInput Off
	return
}
POT12345() {
	Send 1
	RandomSleep(103,128)
	Send 2
	RandomSleep(103,128)
	Send 3
	RandomSleep(103,128)
	Send 4
	RandomSleep(109,132)
	Send 5
	return
}
CtrlClick(iX,iY,iRow,IColumn){
	BlockInput On
	RandomSleep(113,138)
	; iX, iY -> Get Pos of top left inventory cell
	if iX = -1 
		MouseGetPos iX,iY
	
	delta := CellWith
	x := ix
	y := iy

	Loop %iColumn% { ;we dont ctrl-move the last 2 columns (we keep there the scrols and other permanent inv stuff)
		Loop %iRow% { 
			if GetKeyState("[") = 1 ; Keep [ pressed to quit in the middle of the loop
				break
			
			Mousemove ,%x%, %y%
			RandomSleep(56,68)
			send ^{Click}
			RandomSleep(56,68)
			
			y += delta			
		}
		y := iy
		x += delta
	}
		
	BlockInput Off
 }
CtrlClickLoop(iCount) {    
	BlockInput On
	RandomSleep(151,163)
	
	Send {CtrlDown} 
	RandomSleep(113,138)
	
	Loop %iCount% { ; change 50 to how many Ctrl-clicks you want to perform in a series
		if GetKeyState("[") = 1 ; Keep [ pressed to quit in the middle of the loop
				break
		Click
		RandomSleep(113,138)
		}
	
	Send {CTRLUp} 
	BlockInput Off
	return
}
ShiftClick(iCount) {    
	BlockInput On
	RandomSleep(151,163)
	
	Send {ShiftDown} 
	RandomSleep(113,138)
	
	Loop %iCount% { ; change 50 to how many shift-clicks you want to perform in a series
		if GetKeyState("[") = 1 ; Keep [ pressed to quit in the middle of the loop
				break
		Click
		RandomSleep(113,138)
		}
	
	Send {ShiftUp} 
	BlockInput Off
	return
}
Identify(iX,iY,iRow,IColumn) {
	BlockInput On
	RandomSleep(113,138)
	; iX, iY pos of top left inventory cell
		
	delta := 53
	x := ix
	y := iy
		
	MouseMove, 1820, 615 ; Get pos of the wisdom scrolls (default is the 11th from the first row on specified resolution) 
	RandomSleep(56,68)
	Click Right 
	RandomSleep(56,68)
	
	Send {ShiftDown} 
	RandomSleep(113,138)
	
	Loop %iColumn% {
		Loop %iRow% {
			if GetKeyState("[") = 1 ; Keep [ pressed to quit in the middle of the loop
				break
	
			MouseMove, %x%, %y%
			RandomSleep(56,68)
			Click
			RandomSleep(56,68)
			
			y += delta		
		}
		y := iy
		x += delta
	}
	Send {ShiftUp} 
	
	BlockInput Off
	return
}
OpenPortal(){
	BlockInput On
	RandomSleep(113,138)
	
	MouseGetPos xx, yy
	Send {i}
	RandomSleep(56,68)
	
	MouseMove, PortalScrollX, PortalScrollY, 0 ; portal scroll location, top right
	RandomSleep(56,68)
	
	Click Right
	RandomSleep(56,68)
	
	Send {i}
	MouseMove, xx, yy, 0
	BlockInput Off
	return
}
Logout(){
	BlockInput On
	Run cports.exe /close * * * * PathOfExileSteam.exe
	Run cports.exe /close * * * * PathOfExile_x64Steam.exe
	Run cports.exe /close * * * * PathOfExile.exe
	Run cports.exe /close * * * * PathOfExile_x64.exe

	Send {Esc}
	WinGetPos ,,,Width,Height
	X := Width / 2
	Y := Height * 0.48
	MouseMove, %X%, %Y%
	RandomSleep(21,33)
	Click 
	BlockInput Off
	return
}
POTSpam(){
	BlockInput On
	global Flask
	Send %Flask%
	Flask += 1
	BlockInput Off
	If Flask > 5
		Flask = 1
	return
}
KeepKeyPressed(){
If (KeyOn = False)
	{
		Send {%KeyToKeepPress% Down}
		} Else 
			Send {%KeyToKeepPress% Up}
	KeyOn := not(KeyOn)
	Return
}
CheckPos(){
    MouseGetPos, xpos, ypos
	PixelGetColor, xycolor , xpos, ypos
    msgbox, X=%xpos% Y=%ypos% XYColor=%xycolor%
	return
}
GuiUpdate(){
	if (AutoPot=1) {
	AutoPotToggle:="ON" 
	} else AutoPotToggle:="OFF" 

	if (AutoQuit=1) {
	AutoQuitToggle:="ON" 
	}else AutoQuitToggle:="OFF" 

	GuiControl ,, T1, [F12] A-POTS: %AutoPotToggle%
	GuiControl ,, T2, [F11] A-QUIT: %AutoQuitToggle%
	Return
}
GameTick(){
	;msgbox Ticking
	PixelSearch, ChMatchX, ChMatchY, %ChatX1%, %ChatY1%, %ChatX2%, %ChatY2%, %ChatColor%,15, Fast
	if (ErrorLevel=1){
		Exit
	}
	PixelSearch, HPMatchX, HPMatchY, %HPX1%, %HPY1%, %HPX2%, %HPY2%, %HPColor%, 60, Fast
	if (ErrorLevel=0) {
		CurrentHP:=Round((HPY2-HPMatchY)/HPY*100,0)
		GuiUpdate()
		;HPQuit event
		if  ((CurrentHP < HPQuitTreshold) and (Autoquit=1)) {
			Logout()
			AutoPot=0
			AutoQuit=0
			SetTimer, GameTick, Off
			GuiUpdate()
			Exit
		} 
		
		if (AutoPot=1) {
		Trigger:=00000
		GetKeyState, state, %MainAttackKey%
		if state = D
			Trigger:=Trigger+TriggerMainAttack
		
		GetKeyState, state, %SecondaryAttackKey%
		if state = D
			Trigger=:Trigger+TriggerSecondaryAttack
			
		;HPLow event	
		if (CurrentHP < HPLowTreshold) {
			Trigger:=Trigger+TriggerHPLow
		} else {
				;HPAvg event
				if (CurrentHP <HPAvgTreshold) {
					Trigger:=Trigger+TriggerHPAvg
	
				} else {
						;HPHigh event
						if (CurrentHP < HPHighTreshold) {
							Trigger:=Trigger+TriggerHPHigh
						}
		
				} 
		}	
		STrigger:= SubStr("00000" Trigger,-4)
		; Trigger the flasks
		FL=1
		loop 5 {
			FLVal:=SubStr(STrigger,FL,1)+0
			if (FLVal > 0){
				cd:=OnCoolDown[FL]
				if (cd=0) {
					;Fileappend,(HP: %CurrentHP% Flasks: %STrigger% Sends %FL%), PoeUtils.txt
					send %FL%
					OnCoolDown[FL]:=1 
					CoolDown:=CoolDownFlask%FL%
					;msgbox %FL% %CoolDown%
					settimer,TimmerFlask%FL%,%CoolDown%
					sleep=rand(103,128)			
					}
			}
			FL:=FL+1
		}
		;Fileappend,"`n", PoeUtils.txt		
		} 
		 
	} ;else {msgbox "NoHP"}
Return
}

; Timmers
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TimmerFlask1:
	OnCoolDown[1]:=0
	settimer,TimmerFlask1,delete
return

TimmerFlask2:
	OnCoolDown[2]:=0
	settimer,TimmerFlask2,delete
return

TimmerFlask3:
	OnCoolDown[3]:=0
	settimer,TimmerFlask3,delete
return

TimmerFlask4:
	OnCoolDown[4]:=0
	settimer,TimmerFlask4,delete
return

TimmerFlask5:
	OnCoolDown[5]:=0
	settimer,TimmerFlask5,delete
return