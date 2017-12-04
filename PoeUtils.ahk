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

Flask=1

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
!I::Identify(1297,616,5,10) ; ALT+I: Id all the items from Inventory 
+I::Identify(41,188,12,12) ; SHIFT:I: Id all Items from the opened stash tab
!C::CtrlClick(1297,616,5,10) ; ALT+C: CtrlClick full inventory excepting the last 2 columnns
+C::CtrlClick(41,188,12,4) ; SHIFT+C: CtrlClick the opened stash tab to move 12 X 4 rows x columns to the Inventory
!X::CtrlClick(-1,-1,12,4) ; ALT+X: CtrClick the opened tab from the MousePointer (needs to be a top cell)
!F::ShiftClick() ; ShiftClick 50 times (Use it for Fusings/Jewler 6s/6l crafting) 
!M::SwitchGem() ;Alt+M to switch 2 gems (eg conc effect with area). Use CheckPos to change the positions in the function! 
!V::DivTrade() ;Alt+V trade all your divinations ; use CheckPos to change position if needed
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Functions----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
RandomSleep(min,max){
	Random, r, %min%, %max%
	Sleep %r%
	return
}
DivTrade() {
	BlockInput On
	RandomSleep(113,138)
	
	; Get Pos of top left inventory cell
	ix := 1297
	iy := 616
	
	; Get pos of the trade button
	ixTrade := 628
	iyTrade := 735	

	; Get pos of the resulted item
	ixTradedItem := 646
	iyTradedItem := 565	
		
	x := ix
	y := iy
	delta := 53
	
	Loop 10 { ;not 12 as we dont ctrl-move the last 2 columns (we keep there the scrols and other permanent inv stuff)
		Loop 5 { 
			if GetKeyState("[") = 1 ; Keep [ pressed to quit in the middle of the loop
				break
			
			MouseMove , %x%, %y%
			RandomSleep(113,138)
			send ^{Click}
			RandomSleep(113,138)
			
			Mousemove, %ixTrade%, %iyTrade%
			RandomSleep(113,138)
			send ^{Click}
			RandomSleep(113,138)
			
			MouseMove, %ixTradedItem%, %iyTradedItem%
			RandomSleep(113,138)
			send ^{Click}
			RandomSleep(113,138)
			
			y += delta			
		}
		y := iy
		x += delta
	}
	
	BlockInput Off
	return
}
SwitchGEM() {
	BlockInput On
	RandomSleep(151,163)
			
	;first gem position (in my case the first slot of a 1h weapon ... from the secondary inv II). You can put a gem from inv instead. 
	ixFirstGem := 1379
	iyFirstGem := 171
	
	; second gem position (gloves second gem spot in my case -> RF character here)
	ixSecondGem := 1483
	iySecondGem := 372
	
	Send {F2} 
	RandomSleep(113,138)
	
	Send {i} 
	RandomSleep(113,138)
	
	Send {X} ; comment this one if you want to switch with a gem from Inventory and not from the secondary weapon slot
	RandomSleep(113,138)
	
	Click, Right, %ixFirstGem%, %iyFirstGem%
	RandomSleep(113,138)
	
	Click,  %ixSecondGem%, %iySecondGem%
	RandomSleep(113,138)
	
	Click,  %ixFirstGem%, %iyFirstGem%
	RandomSleep(113,138)
	
	Send {X} ; comment this one if you want to switch with a gem from Inventory and not from the secondary weapon slot
	RandomSleep(113,138)
	
	Send {i} 
	BlockInput Off
	return
}
POT12345() {
	Send 1
	RandomSleep(113,138)
	
	Send 2
	RandomSleep(113,138)
	
	Send 3
	RandomSleep(113,138)
	
	Send 4
	RandomSleep(113,138)
	
	Send 5
	return
}
CtrlClick(iX,iY,iRow,IColumn){
	BlockInput On
	RandomSleep(113,138)
	
	; iX, iY -> Get Pos of top left inventory cell
	;ix := 1297
	;iy := 616
	if iX = -1 
		MouseGetPos iX,iY
	
	delta := 53
	x := ix
	y := iy

	Loop %iColumn% { ;we dont ctrl-move the last 2 columns (we keep there the scrols and other permanent inv stuff)
		Loop %iRow% { 
			if GetKeyState("[") = 1 ; Keep [ pressed to quit in the middle of the loop
				break
			
			Mousemove ,%x%, %y%
			RandomSleep(113,138)
			send ^{Click}
			RandomSleep(113,138)
			
			y += delta			
		}
		y := iy
		x += delta
	}
		
	BlockInput Off
 }
ShiftClick() {    
	BlockInput On
	RandomSleep(151,163)
	
	Send {ShiftDown} 
	RandomSleep(113,138)
	
	Loop 50 { ; change 50 to how many shift-clicks you want to perform in a series
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
	
	; Get Pos of top left inventory cell
	;ix := 1297
	;iy := 616
	
	delta := 53
	x := ix
	y := iy
		
	MouseMove, 1820, 615 ; Get pos of the wisdom scrolls (default is the 11th from the first row on specified resolution) 
	RandomSleep(113,138)
	Click Right 
	RandomSleep(113,138)
	Send {ShiftDown} 
	RandomSleep(113,138)
	
	Loop %iColumn% {
		Loop %iRow% {
			if GetKeyState("[") = 1 ; Keep [ pressed to quit in the middle of the loop
				break
			
			MouseMove, %x%, %y%
			RandomSleep(113,138)
			Click
			RandomSleep(113,138)
			
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
	
	MouseMove, 1859, 616, 0 ; portal scroll location, top right
	RandomSleep(113,138)
	Click Right
	RandomSleep(113,138)
	
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
CheckPos(){
    MouseGetPos, xpos, ypos
    msgbox, mx=%xpos% my=%ypos%
	return
}