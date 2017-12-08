;#IfWinActive Path of Exile
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

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; All the functions will work without any changes for windowed full-screen 1920x1080, having wisdom & portal scrolls respectively on the last 2 positions of the first row. 
; The SwichGem function will work only if you have the same setup like me (see details in the function). 
; .. but most probably you will need to adjust the positions as this is mostly character based.
; For different setups (resolution and/or scroll positions) you need to use the CheckPos function and change the coordonates in each of the respective functions
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Legend:
; ! = Alt
; ^ = Ctrl
; + = Shift 
; Global variables -> default setup for 1920x1080, having wisdom & portal scrolls respectively on the last 2 positions of the first row.  
global CellWith=53
global CtrlLoopCount=50
global ShiftLoopCount=50
global InventoryColumnsToMove=10
global InventoryRowsToMove=5
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
global CurrentGemX=1483
global CurrentGemY=372
global AlternateGemX=1379 
global AlternateGemY=171
global AlternateGemOnSecondarySlot=1
global KeyToKeepPress="Q"
global Speed=1

global KeyOn:=False
global Flask=1

If FileExist("PoeUtils.ini"){ 
	IniRead, CellWith, PoeUtils.ini, General, CellWith
	IniRead, CtrlLoopCount, PoeUtils.ini, General, CtrlLoopCount
	IniRead, ShiftLoopCount, PoeUtils.ini, General, ShiftLoopCount
	IniRead, InventoryColumnsToMove, PoeUtils.ini, General, InventoryColumnsToMove
	IniRead, InventoryRowsToMove, PoeUtils.ini, General, InventoryRowsToMove	
	IniRead, KeyToKeepPress, PoeUtils.ini, General, KeyToKeepPress
	IniRead, Speed, PoeUtils.ini, General, Speed
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
	IniRead, CurrentGemX, PoeUtils.ini, ItemSwap, CurrentGemX
	IniRead, CurrentGemY, PoeUtils.ini, ItemSwap, CurrentGemY
	IniRead, AlternateGemX, PoeUtils.ini, ItemSwap, AlternateGemX
	IniRead, AlternateGemY, PoeUtils.ini, ItemSwap, AlternateGemY
	IniRead, AlternateGemOnSecondarySlot, PoeUtils.ini, ItemSwap, AlternateGemOnSecondarySlot
} else {
	IniWrite, %CellWith%, PoeUtils.ini, General, CellWith
	IniWrite, %CtrlLoopCount%, PoeUtils.ini, General, CtrlLoopCount
	IniWrite, %ShiftLoopCount%, PoeUtils.ini, General, ShiftLoopCount
	IniWrite, %InventoryColumnsToMove%, PoeUtils.ini, General, InventoryColumnsToMove
	IniWrite, %InventoryRowsToMove%, PoeUtils.ini, General, InventoryRowsToMove	
	IniWrite, %KeyToKeepPress%, PoeUtils.ini, General, KeyToKeepPress
	IniWrite, %Speed%, PoeUtils.ini, General, Speed
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
	IniWrite, %CurrentGemX%, PoeUtils.ini, ItemSwap, CurrentGemX
	IniWrite, %CurrentGemY%, PoeUtils.ini, ItemSwap, CurrentGemY
	IniWrite, %AlternateGemX%, PoeUtils.ini, ItemSwap, AlternateGemX
	IniWrite, %AlternateGemY%, PoeUtils.ini, ItemSwap, AlternateGemY
	IniWrite, %AlternateGemOnSecondarySlot%, PoeUtils.ini, ItemSwap, AlternateGemOnSecondarySlot
}

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Scroll stash tabs using mouse-wheel
!WheelDown::Send {Right} ; ALT+WheelDown: Stash scroll 
!WheelUp::Send {Left} ; ALT+WheelUp: Stash scroll 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!F1::ExitApp ; Alt+F1: Exit the script
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
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Functions----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
RandomSleep(min,max){
	Random, r, %min%, %max%
	r:=floor(r/Speed)
	Sleep %r%
	return
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

	if (%AlternateGemOnSecondarySlot%=True) 
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
	
	if (%AlternateGemOnSecondarySlot%=True) 
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
	RandomSleep(103,128)
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
	
	MouseMove, PortalScrolX, PortalScrolY, 0 ; portal scroll location, top right
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
	Send {f}{Shift}{e}{r}{c}
	RandomSleep(23,36)
	
	Send {f}
	RandomSleep(23,36)
	
	Send {f}
	RandomSleep(23,36)
	
	Run cports.exe /close * * * * PathOfExileSteam.exe
	Run cports.exe /close * * * * PathOfExile.exe
	
	Send {Esc}
	WinGetPos ,,,Width,Height
	X := Width / 2
	Y := Height * 0.38
	
	MouseMove, %X%, %Y%
	RandomSleep(23,36)
	
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
    msgbox, mx=%xpos% my=%ypos%
	return
}