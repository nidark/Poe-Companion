; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Copyright (c) 2017, Nidark
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
;   * Partial or integral redistributions of source code in any form (code/binary) cannot be sold, but only provided free of any charge.
;   * Partial or integral redistributions of source code in any form (code/binary) must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
;   * The name of the contributors may not be used to endorse or promote products derived from this software without specific prior written permission.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; The most updated version is always here: https://github.com/nidark/Poe-Companion
; Support: https://discord.gg/qfDkyTs
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; If you need to make changes, DONT change the variables from the script! 
; Change them in the PoeCompanion.INI file!
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Most of the functions will work without any INI changes for windowed full-screen 1920x1080 Steam Edition DX11, having the wisdom & portal scrolls respectively on the last 2 positions of the first row. 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; The SwichGem function & Auto-flask will work only if you have the same setup like me.   
; But most probably you will need to adjust those positions & flask logic in INI using "ALT+O", as this is mostly character & skill-key based.
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; For different setups (resolutions and/or scroll positions) you need to use the "ALT+O" function and change the coordonates in the INI file.
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

I_Icon = PoeC.ico
IfExist, %I_Icon%
  Menu, Tray, Icon, %I_Icon%

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Global variables
; Default setup for 1920x1080, having wisdom & portal scrolls respectively on the last 2 positions of the first row.  
; DON'T CHANGE them here. If you need to make changes, do change the INI file!
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;General
global CtrlLoopCount=50
global ShiftLoopCount=50
global InventoryColumnsToMove=10
global InventoryRowsToMove=5
global KeyToKeepPress="Q"
global ForceLogoutOrExitOnQuit=0
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
global GuiX=-5
global GuiY=1005

;ItemSwap
global CurrentGemX=1483
global CurrentGemY=372
global AlternateGemX=1379 
global AlternateGemY=171
global AlternateGemOnSecondarySlot=1

;AutoPot Setup
global ChatColor=0x0E6DBF
global ChatX1=10
global ChatY1=875
global ChatX2=24
global ChatY2=890

global HPColor=0x080C18
global HPX1=908
global HPY1=325
global HPX2=1012
global HPY2=329

global HPQuitTreshold=25
global HPLowTreshold=40
global HPAvgTreshold=65
global HPHighTreshold=90
global MainAttackKey="Q"
global SecondaryAttackKey="W"

;The default flask setup/example is based on my setup, but you can use any flask and any trigger combinations by changing the setup in the INI file
global TriggerHPLow=11111
global TriggerHPAvg=10011
global TriggerHPHigh=10001
global TriggerMainAttack=01100
global TriggerSecondaryAttack=01110

; Cooldowns for each of the 5 Flasks
global CoolDownFlask1:=7000
global CoolDownFlask2:=4800
global CoolDownFlask3:=3500
global CoolDownFlask4:=5000
global CoolDownFlask5:=3500

; Trade Spam
global TradeDelay:=30000
global TradeChannelDelay:=2500
global TradeChannelStart:=1
global TradeChannelStop:=20
global TradeMessage:="WTB Ex 1:85c, Alch 4:1c, Jew 13:1c, Alt 15:1c, Chrom 15:1c"

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Extra vars - Not in INI
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
global HPX=HPX2-HPX1
global Trigger=00000
global AutoQuit=0 
global AutoPot=0 
global TradeSpam=0 
global CurrentHP=100
global KeyOn:=False
global Flask=1
global OnCoolDown:=[0,0,0,0,0]
global debug=0
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
If FileExist("PoeCompanion.ini"){ 
	IniRead, CtrlLoopCount, PoeCompanion.ini, General, CtrlLoopCount
	IniRead, ShiftLoopCount, PoeCompanion.ini, General, ShiftLoopCount
	IniRead, InventoryColumnsToMove, PoeCompanion.ini, General, InventoryColumnsToMove
	IniRead, InventoryRowsToMove, PoeCompanion.ini, General, InventoryRowsToMove	
	IniRead, KeyToKeepPress, PoeCompanion.ini, General, KeyToKeepPress
	IniRead, ForceLogoutOrExitOnQuit, PoeCompanion.ini, General, ForceLogoutOrExitOnQuit
	IniRead, Speed, PoeCompanion.ini, General, Speed
	IniRead, Tick, PoeCompanion.ini, General, Tick
	
	IniRead, CellWith, PoeCompanion.ini, Coordinates, CellWith
	IniRead, InventoryX, PoeCompanion.ini, Coordinates, InventoryX
	IniRead, InventoryY, PoeCompanion.ini, Coordinates, InventoryY
	IniRead, StashX, PoeCompanion.ini, Coordinates, StashX
	IniRead, StashY, PoeCompanion.ini, Coordinates, StashY
	IniRead, PortalScrollX, PoeCompanion.ini, Coordinates, PortalScrollX
	IniRead, PortalScrollY, PoeCompanion.ini, Coordinates, PortalScrollY
	IniRead, WisdomScrollX, PoeCompanion.ini, Coordinates, WisdomScrollX
	IniRead, WisdomScrollY, PoeCompanion.ini, Coordinates, WisdomScrollY
	IniRead, TradeButtonX, PoeCompanion.ini, Coordinates, TradeButtonX
	IniRead, TradeButtonY, PoeCompanion.ini, Coordinates, TradeButtonY
	IniRead, TradedItemX, PoeCompanion.ini, Coordinates, TradedItemX
	IniRead, TradedItemY, PoeCompanion.ini, Coordinates, TradedItemY
	IniRead, GuiX, PoeCompanion.ini, Coordinates, GuiX
	IniRead, GuiY, PoeCompanion.ini, Coordinates, GuiY
		
	IniRead, CurrentGemX, PoeCompanion.ini, ItemSwap, CurrentGemX
	IniRead, CurrentGemY, PoeCompanion.ini, ItemSwap, CurrentGemY
	IniRead, AlternateGemX, PoeCompanion.ini, ItemSwap, AlternateGemX
	IniRead, AlternateGemY, PoeCompanion.ini, ItemSwap, AlternateGemY
	IniRead, AlternateGemOnSecondarySlot, PoeCompanion.ini, ItemSwap, AlternateGemOnSecondarySlot
		
	IniRead, ChatColor, PoeCompanion.ini, AutoPot, ChatColor
	IniRead, ChatX1, PoeCompanion.ini, AutoPot, ChatX1
 	IniRead, ChatY1, PoeCompanion.ini, AutoPot, ChatY1
 	IniRead, ChatX2, PoeCompanion.ini, AutoPot, ChatX2
 	IniRead, ChatY2, PoeCompanion.ini, AutoPot, ChatY2
 	IniRead, HPColor, PoeCompanion.ini, AutoPot, HPColor
	IniRead, HPX1, PoeCompanion.ini, AutoPot, HPX1
	IniRead, HPY1, PoeCompanion.ini, AutoPot, HPY1
	IniRead, HPX2, PoeCompanion.ini, AutoPot, HPX2
	IniRead, HPY2, PoeCompanion.ini, AutoPot, HPY2
	IniRead, HPQuitTreshold, PoeCompanion.ini, AutoPot, HPQuitTreshold
 	IniRead, HPLowTreshold, PoeCompanion.ini, AutoPot, HPLowTreshold
	IniRead, HPAvgTreshold, PoeCompanion.ini, AutoPot, HPAvgTreshold
	IniRead, HPHighTreshold, PoeCompanion.ini, AutoPot, HPHighTreshold
 	IniRead, MainAttackKey, PoeCompanion.ini, AutoPot, MainAttackKey
	IniRead, SecondaryAttackKey, PoeCompanion.ini, AutoPot, SecondaryAttackKey
	IniRead, TriggerHPLow, PoeCompanion.ini, AutoPot, TriggerHPLow
	IniRead, TriggerHPAvg, PoeCompanion.ini, AutoPot, TriggerHPAvg
	IniRead, TriggerHPHigh, PoeCompanion.ini, AutoPot, TriggerHPHigh
	IniRead, TriggerMainAttack, PoeCompanion.ini, AutoPot, TriggerMainAttack
	IniRead, TriggerSecondaryAttack, PoeCompanion.ini, AutoPot, TriggerSecondaryAttack
	IniRead, CoolDownFlask1, PoeCompanion.ini, AutoPot, CoolDownFlask1
	IniRead, CoolDownFlask2, PoeCompanion.ini, AutoPot, CoolDownFlask2
	IniRead, CoolDownFlask3, PoeCompanion.ini, AutoPot, CoolDownFlask3
	IniRead, CoolDownFlask4, PoeCompanion.ini, AutoPot, CoolDownFlask4
	IniRead, CoolDownFlask5, PoeCompanion.ini, AutoPot, CoolDownFlask5
	
	IniRead, TradeDelay, PoeCompanion.ini, Trade, TradeDelay
	IniRead, TradeChannelDelay, PoeCompanion.ini, Trade, TradeChannelDelay
	IniRead, TradeChannelStart, PoeCompanion.ini, Trade, TradeChannelStart
	IniRead, TradeChannelStop, PoeCompanion.ini, Trade, TradeChannelStop
	IniRead, TradeMessage, PoeCompanion.ini, Trade, TradeMessage
 	
} else {
	
	IniWrite, %CtrlLoopCount%, PoeCompanion.ini, General, CtrlLoopCount
	IniWrite, %ShiftLoopCount%, PoeCompanion.ini, General, ShiftLoopCount
	IniWrite, %InventoryColumnsToMove%, PoeCompanion.ini, General, InventoryColumnsToMove
	IniWrite, %InventoryRowsToMove%, PoeCompanion.ini, General, InventoryRowsToMove	
	IniWrite, %KeyToKeepPress%, PoeCompanion.ini, General, KeyToKeepPress
	IniWrite, %ForceLogoutOrExitOnQuit%, PoeCompanion.ini, General, ForceLogoutOrExitOnQuit
	IniWrite, %Speed%, PoeCompanion.ini, General, Speed
	IniWrite, %Tick%, PoeCompanion.ini, General, Tick
	
	IniWrite, %CellWith%, PoeCompanion.ini, Coordinates, CellWith
	IniWrite, %InventoryX%, PoeCompanion.ini, Coordinates, InventoryX
	IniWrite, %InventoryY%, PoeCompanion.ini, Coordinates, InventoryY
	IniWrite, %StashX%, PoeCompanion.ini, Coordinates, StashX
	IniWrite, %StashY%, PoeCompanion.ini, Coordinates, StashY
	IniWrite, %PortalScrollX%, PoeCompanion.ini, Coordinates, PortalScrollX
	IniWrite, %PortalScrollY%, PoeCompanion.ini, Coordinates, PortalScrollY
	IniWrite, %WisdomScrollX%, PoeCompanion.ini, Coordinates, WisdomScrollX
	IniWrite, %WisdomScrollY%, PoeCompanion.ini, Coordinates, WisdomScrollY
	IniWrite, %TradeButtonX%, PoeCompanion.ini, Coordinates, TradeButtonX
	IniWrite, %TradeButtonY%, PoeCompanion.ini, Coordinates, TradeButtonY
	IniWrite, %TradedItemX%, PoeCompanion.ini, Coordinates, TradedItemX
	IniWrite, %TradedItemY%, PoeCompanion.ini, Coordinates, TradedItemY
	IniWrite, %GuiX%, PoeCompanion.ini, Coordinates, GuiX
	IniWrite, %GuiY%, PoeCompanion.ini, Coordinates, GuiY
		
	IniWrite, %CurrentGemX%, PoeCompanion.ini, ItemSwap, CurrentGemX
	IniWrite, %CurrentGemY%, PoeCompanion.ini, ItemSwap, CurrentGemY
	IniWrite, %AlternateGemX%, PoeCompanion.ini, ItemSwap, AlternateGemX
	IniWrite, %AlternateGemY%, PoeCompanion.ini, ItemSwap, AlternateGemY
	IniWrite, %AlternateGemOnSecondarySlot%, PoeCompanion.ini, ItemSwap, AlternateGemOnSecondarySlot
	
	IniWrite, %ChatColor%, PoeCompanion.ini, AutoPot, ChatColor
	IniWrite, %ChatX1%, PoeCompanion.ini, AutoPot, ChatX1
 	IniWrite, %ChatY1%, PoeCompanion.ini, AutoPot, ChatY1
 	IniWrite, %ChatX2%, PoeCompanion.ini, AutoPot, ChatX2
 	IniWrite, %ChatY2%, PoeCompanion.ini, AutoPot, ChatY2
 	IniWrite, %HPColor%, PoeCompanion.ini, AutoPot, HPColor
	IniWrite, %HPX1%, PoeCompanion.ini, AutoPot, HPX1
	IniWrite, %HPY1%, PoeCompanion.ini, AutoPot, HPY1
	IniWrite, %HPX2%, PoeCompanion.ini, AutoPot, HPX2
	IniWrite, %HPY2%, PoeCompanion.ini, AutoPot, HPY2
	IniWrite, %HPQuitTreshold%, PoeCompanion.ini, AutoPot, HPQuitTreshold
 	IniWrite, %HPLowTreshold%, PoeCompanion.ini, AutoPot, HPLowTreshold
	IniWrite, %HPAvgTreshold%, PoeCompanion.ini, AutoPot, HPAvgTreshold
	IniWrite, %HPHighTreshold%, PoeCompanion.ini, AutoPot, HPHighTreshold
 	IniWrite, %MainAttackKey%, PoeCompanion.ini, AutoPot, MainAttackKey
	IniWrite, %SecondaryAttackKey%, PoeCompanion.ini, AutoPot, SecondaryAttackKey
	IniWrite, %TriggerHPLow%, PoeCompanion.ini, AutoPot, TriggerHPLow
	IniWrite, %TriggerHPAvg%, PoeCompanion.ini, AutoPot, TriggerHPAvg
	IniWrite, %TriggerHPHigh%, PoeCompanion.ini, AutoPot, TriggerHPHigh
	IniWrite, %TriggerMainAttack%, PoeCompanion.ini, AutoPot, TriggerMainAttack
	IniWrite, %TriggerSecondaryAttack%, PoeCompanion.ini, AutoPot, TriggerSecondaryAttack
	IniWrite, %CoolDownFlask1%, PoeCompanion.ini, AutoPot, CoolDownFlask1
	IniWrite, %CoolDownFlask2%, PoeCompanion.ini, AutoPot, CoolDownFlask2
	IniWrite, %CoolDownFlask3%, PoeCompanion.ini, AutoPot, CoolDownFlask3
	IniWrite, %CoolDownFlask4%, PoeCompanion.ini, AutoPot, CoolDownFlask4
	IniWrite, %CoolDownFlask5%, PoeCompanion.ini, AutoPot, CoolDownFlask5
	
	IniWrite, %TradeDelay%, PoeCompanion.ini, Trade, TradeDelay
	IniWrite, %TradeChannelDelay%, PoeCompanion.ini, Trade, TradeChannelDelay
	IniWrite, %TradeChannelStart%, PoeCompanion.ini, Trade, TradeChannelStart
	IniWrite, %TradeChannelStop%, PoeCompanion.ini, Trade, TradeChannelStop
	IniWrite, %TradeMessage%, PoeCompanion.ini, Trade, TradeMessage

}
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Gui 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Gui (default bottom left)
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui, Color, 0X130F13
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, 0X130F13
Gui -Caption
Gui, Font, bold cFFFFFF S10, Trebuchet MS
Gui, Add, Text, y+0.5 BackgroundTrans vT1, HP 100
Gui, Add, Text, y+0.5 BackgroundTrans vT2, Auto-Quit: OFF
Gui, Add, Text, y+0.5 BackgroundTrans vT3, Auto-Flask: OFF
Gui, Add, Text, y+0.5 BackgroundTrans vT4, Trade-Spam: OFF
Gui, Show, x%GuiX% y%GuiY%
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; KEY Binding
; Legend:   ! = Alt      ^ = Ctrl     + = Shift 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!WheelDown::Send {Right} ; ALT+WheelDown: Stash scroll 
!WheelUp::Send {Left} ; ALT+WheelUp: Stash scroll
^WheelDown::AutoClicks() ; CTRL+WheelDown -> Spam CTRL+CLICK
+WheelDown::AutoClicks() ; SHIFT+WheelDown -> Spam SHIFT+CLICK    
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$!G::Send {Enter} /global 820 {Enter} ; ALT+G
$!T::Send {Enter} /trade 820 {Enter} ; ALT+T
$!H::Send {Enter} /hideout {Enter} ; ALT+H
$!R::Send {Enter} /remaining {Enter} ; ALT+R
$!B::Send {Enter} /abandon_daily {Enter} ; ALT+B
$!L::Send {Enter} /itemlevel {Enter} ; ALT+L
$!P::Send {Enter} /passives {Enter} ; ALT+P
$!E::Send {Enter} /exit {Enter} ; ALT+E: Exit to char selection
$!Y::Send ^{Enter}{Home}{Delete}/invite {Enter} ;ALT+Y: Invite the last char who whispered you to party
$+Y::Send ^{Enter}{Home}{Delete}/tradewith {Enter} ; Invite the last char who whispered you to trade
^!Y:: ; Link the current item to the last person that whispered you
    Send ^{Enter}
    Sleep 111
    Send ^!{Click}{Space}
Return
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$!F1::ExitApp  ; Alt+F1: Exit the script
$!Q::Logout() ; ALT+Q: Fast logout  
$!O::CheckPos() ; ALT+O Get the cursor position. Use it to change the position setup for Identify, OpenPortal, SwitchGem etc
$!S::POTSpam() ; Alt+S for 5 times will press 1,2,3,4,4 in fast seqvence 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; The following macros are NOT ALLOWED by GGG (EULA), as we send multiple server actions with one button pressed
; This can't be identified as we randomize all timmings, but dont use it if you want to stick with the EULA 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
$!Space::OpenPortal() ; ALT+Space: Open a portal using a portal scroll from the top right inv slot; use CheckPos to change portal scroll position if needed
$`::POT12345() ; `: Pressing ` once will press 1,2,3,4,5 in fast seqvence 
$!I::Identify(InventoryX,InventoryY,InventoryRowsToMove,InventoryColumnsToMove) ; ALT+I: Id all the items from Inventory 
$+I::Identify(StashX,StashY,12,12) ; SHIFT:I: Id all Items from the opened stash tab
$!C::CtrlClick(InventoryX,InventoryY,InventoryRowsToMove,InventoryColumnsToMove) ; ALT+C: CtrlClick full inventory excepting the last 2 columns
$+C::CtrlClick(StashX,StashY,12,4) ; SHIFT+C: CtrlClick the opened stash tab to move 12 X 4 rows x columns to the Inventory
$!X::CtrlClick(-1,-1,12,4) ; ALT+X: CtrClick the opened tab from the MousePointer (needs to be a top cell)
$!Z::CtrlClickLoop(CtrlLoopCount) ; ALT + Z : 50 X CtrlClick at the current mouse location (ex: buys currency from vendors)
$!F::ShiftClick(ShiftLoopCount) ; ShiftClick 50 times (Use it for Fusings/Jewler 6s/6l crafting) 
$!M::SwitchGem() ;Alt+M to switch 2 gems (eg conc effect with area). Use CheckPos to change the positions in the function! 
$!V::DivTrade() ;Alt+V trade all your divinations ; use CheckPos to change position if needed
$!U::KeepKeyPressed()
$!D::SwitchDebug()

SwitchDebug(){
debug=!debug
if Debug {
	msgbox "Debug mode enabled!"
} else
	msgbox "Debug mode disabled!"
}

$!F10::
	TradeSpam := !TradeSpam
	GuiUpdate()
    if (!TradeSpam) {
        SetTimer TTradeSpam, Off
    } else {
        SetTimer TTradeSpam, %TradeDelay%		
    }
return
	
$!F11::
   AutoQuit := !AutoQuit
   GuiUpdate()
   if ((!AutoPot) and (!AutoQuit)) {
        SetTimer TGameTick, Off
    } else {
        SetTimer TGameTick, %Tick%	
    }
return

$!F12::
    AutoPot := !AutoPot
	GuiUpdate()	
	if ((!AutoPot) and (!AutoQuit)) {
        SetTimer TGameTick, Off
    } else {
        SetTimer TGameTick, %Tick%	
    }
return
return

; Functions
LeaveParty(){

}
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
	Critical
	BlockInput On
	if (ForceLogoutOrExitOnQuit=1) {
		Run cports.exe /close * * * * PathOfExile_x64Steam.exe
		Run cports.exe /close * * * * PathOfExileSteam.exe
		Run cports.exe /close * * * * PathOfExile.exe
		Run cports.exe /close * * * * PathOfExile_x64.exe
		Send {Enter} /exit {Enter}		
	} else {
		Send {Enter} /exit {Enter}		
	}
	RandomSleep(56,68)
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
	
	if (TradeSpam=1) {
	TradeSpamToggle:="ON" 
	}else TradeSpamToggle:="OFF" 
	
	GuiControl ,, T1, HP %CurrentHP%
	GuiControl ,, T2, Auto-Quit: %AutoQuitToggle%
	GuiControl ,, T3, Auto-Flask: %AutoPotToggle%
	GuiControl ,, T4, Trade-Spam: %TradeSpamToggle%
	Return
}
TGameTick(){
	;if Debug {FileAppend, FormatTime, T, %A_Now%, M/dd/yy h:mmtt Testing Chat Icon Existence `n, PoeCompanion.log}
	PixelSearch, ChMatchX, ChMatchY, %ChatX1%, %ChatY1%, %ChatX2%, %ChatY2%, %ChatColor%,10, Fast
	if (ErrorLevel=1){
		CurrentHP:=100
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
	}	
		
	PixelSearch, HPMatchX, HPMatchY, %HPX1%, %HPY1%, %HPX2%, %HPY2%, %HPColor%, 2, Fast
	if (ErrorLevel=0) {
		CurrentHP:=Round((HPMatchX-HPX1)/HPX*100,0)
		GuiUpdate()
		if  ((Autoquit=1) and (CurrentHP < HPQuitTreshold) ) {
			Logout()			
			GuiUpdate()
			Exit
		} 		
		if (AutoPot=1) {	
		if (CurrentHP < HPLowTreshold) {
			Trigger:=Trigger+TriggerHPLow
		} else {
				if (CurrentHP <HPAvgTreshold) {
					Trigger:=Trigger+TriggerHPAvg
				} else {
						if (CurrentHP < HPHighTreshold) {
							Trigger:=Trigger+TriggerHPHigh
						}
		
				} 
		}	
		;if Debug {Fileappend,"`n", PoeUtils.txt}		
		} 
		 
	} else {
	CurrentHP:=100
	GuiUpdate()
	}
	; Trigger the flasks
	if (AutoPot=1) {
		STrigger:= SubStr("00000" Trigger,-4)
		FL=1
		loop 5 {
			FLVal:=SubStr(STrigger,FL,1)+0
			if (FLVal > 0){
				cd:=OnCoolDown[FL]
				if (cd=0) {
					;if debug {Fileappend,(HP: %CurrentHP% Flasks: %STrigger% Sends %FL%), PoeUtils.txt}
					send %FL%
					OnCoolDown[FL]:=1 
					CoolDown:=CoolDownFlask%FL%
					settimer, TimmerFlask%FL%, %CoolDown%
					sleep=rand(103,128)			
					}
			}
			FL:=FL+1
		}
	}	
Return
}
TTradeSpam(){
BlockInput On
l:= TradeChannelStop-TradeChannelStart+1
TradeChannel:= TradeChannelStart
Loop %l%{
	if GetKeyState("[") = 1 { ; Keep [ pressed to quit in the middle of the loop
		TradeSpam := 0
		GuiUpdate()
		SetTimer, TTradeSpam, Off	
		break
	}
	Send {Enter} /trade %TradeChannel% {Enter}
	RandomSleep(113,138)
	Send {Enter} $ %TradeMessage% {Enter}	
	RandomSleep(113,138)
	TradeChannel++	
	sleep %TradeChannelDelay%
}
BlockInput Off
} 

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