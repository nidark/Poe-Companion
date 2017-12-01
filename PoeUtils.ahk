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
WheelDown::Send {Right} ; works no matter the resolution or any item positioning
WheelUp::Send {Left} ; works no matter the resolution or any item positioning
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!G::Send {Enter} /global 820 {Enter} ; works no matter the resolution or any item positioning
!T::Send {Enter} /trade 820 {Enter} ; works no matter the resolution or any item positioning
!H::Send {Enter} /hideout {Enter} ; works no matter the resolution or any item positioning
!R::Send {Enter} /remaining {Enter} ; works no matter the resolution or any item positioning
!B::Send {Enter} /abandon_daily {Enter} ; works no matter the resolution or any item positioning
!L::Send {Enter} /itemlevel {Enter} ; works no matter the resolution or any item positioning
!P::Send {Enter} /passives {Enter} ; works no matter the resolution or any item positioning
!E::Send {Enter} /exit {Enter} ; works no matter the resolution or any item positioning
!Y::Send ^{Enter}{Home}{Delete}/invite {Enter} ; Invite the last char who whispered you to party; works no matter the resolution or any item positioning
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!F1::ExitApp ; Alt+F1 to exit the script
!Q::Logout() ; ALT+Q Fast logout  ; works no matter the resolution or any item positioning
!O::CheckPos() ; ALT+O Gett the cursor position. Use it to change the position setup for Identify, OpenPortal, SwitchGem etc
!S::POTSpam() ; Alt+S for 5 times will press 1,2,3,4,4 in fast seqvence  ; works no matter the resolution or any item positioning 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; The following macros are NOT ALLOWED by GGG (EULA), as we send multiple server actions with one button pressed
; This can't be identified as we randomize all timmings, but dont use it if you want to stick with the EULA 
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
!Space::OpenPortal() ; Open a portal using a portal scroll from the top right inv slot; use CheckPos to change portal scroll position if needed
`::POT12345() ; Pressing ` once will press 1,2,3,4,5 in fast seqvence 
!I::Identify() ; ID All Items in Inventory ; use CheckPos to change wisdom scroll position if needed
!C::CtrlClick() ; CtrlClick full inventory (move all to stash), excepting the last 2 columnns ; use CheckPos to change position if needed
!F::ShiftClick() ; ShiftClick 50 times (Use it for Fusings/Jewler 6s/6l crafting) ; works no matter the resolution or any item positioning
!M::SwitchGem() ;Alt+M to switch 2 gems (eg conc effect with area). Use CheckPos to change the positions in the function! 
!V::DivTrade() ;Alt+V trade all your divinations ; use CheckPos to change position if needed
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


; Functions----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
RandomSleep(min,max){
	Random, r, %min%, %max%
	Sleep %r%
}
DivTrade() {
	BlockInput On
	
	; Get Pos of top left inventory cell
	ix := 1297
	iy := 616
	
	; Get pos of the trade button
	ixTrade := 628
	iyTrade := 735	

	; Get pos of the resulted item
	ixTradedItem := 646
	iyTradedItem := 565	
	
	Send {CtrlDown} 
	RandomSleep(51,63)
	
	x := ix
	y := iy
	delta := 53
	
	Loop 10 { ;not 12 as we dont ctrl-move the last 2 columns (we keep there the scrols and other permanent inv stuff)
		Loop 5 { 
			if GetKeyState("[") = 1 
				break
			Click, %x%, %y%
			RandomSleep(51,63)
			Click, %ixTrade%, %iyTrade%
			RandomSleep(51,63)
			Click, %ixTradedItem%, %iyTradedItem%
			RandomSleep(51,63)
			y += delta			
		}
		y := iy
		x += delta
	}
	Send {CTRLUp} 
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
	RandomSleep(51,63)
	
	Send {i} 
	RandomSleep(51,63)
	
	Send {X} ; comment this one if you want to switch with a gem from Inventory and not from the secondary weapon slot
	RandomSleep(51,63)
	
	Click, Right, %ixFirstGem%, %iyFirstGem%
	RandomSleep(51,63)
	
	Click,  %ixSecondGem%, %iySecondGem%
	RandomSleep(51,63)
	
	Click,  %ixFirstGem%, %iyFirstGem%
	RandomSleep(51,63)
	
	Send {X} ; comment this one if you want to switch with a gem from Inventory and not from the secondary weapon slot
	RandomSleep(51,63)
	
	Send {i} 
	BlockInput Off
}
POT12345() {
	Send 1
	RandomSleep(93,136)
	
	Send 2
	RandomSleep(93,136)
	
	Send 3
	RandomSleep(93,136)
	
	Send 4
	RandomSleep(93,136)
	
	Send 5
}
CtrlClick(){
	BlockInput On
	RandomSleep(151,163)
	
	; Get Pos of top left inventory cell
	ix := 1297
	iy := 616
	
	delta := 53
	x := ix
	y := iy
		
	Send {CtrlDown} 
	RandomSleep(51,63)
	
	Loop 10 { ;we dont ctrl-move the last 2 columns (we keep there the scrols and other permanent inv stuff)
		Loop 5 { 
			if GetKeyState("[") = 1 
				break
			Click, %x%, %y%
			y += delta
			RandomSleep(51,63)
		}
		y := iy
		x += delta
	}
	Send {CTRLUp}		
	BlockInput Off
 }
ShiftClick() {    
	RandomSleep(151,163)
	
	Send {ShiftDown} 
	RandomSleep(51,63)
	
	Loop 50 { ; change 50 to how many shift-clicks you want to perform in a series
		if GetKeyState("[") = 1 
				break
		Click
		RandomSleep(51,63)
		}
	
	Send {ShiftUp} 
}
Identify() {
	BlockInput On
	RandomSleep(151,163)
	
	; Get Pos of top left inventory cell
	ix := 1297
	iy := 616
	
	delta := 53
	x := ix
	y := iy
		
	Click Right, 1820, 615 ; Get pos of the wisdom scrolls (default is the 11th from the first row on specified resolution) 
	RandomSleep(51,63)
	Send {ShiftDown} 
	RandomSleep(51,63)
	
	Loop 12 {
		Loop 5 {
			if GetKeyState("[") = 1 
				break
			Click, %x%, %y%
			y += delta
			RandomSleep(51,63)
		}
		y := iy
		x += delta
	}
	Send {ShiftUp} 
	
	BlockInput Off
}
OpenPortal(){
	BlockInput On
	RandomSleep(51,63)
	MouseGetPos xx, yy
	Send {i}
	MouseMove, 1859, 616, 0 
	RandomSleep(51,63)
	Click Right
	RandomSleep(51,63)
	Send {i}
	MouseMove, xx, yy, 0
	BlockInput Off
	return
}
Logout(){
	BlockInput On
	Send {f}{Shift}{e}{r}{c}
	RandomSleep(21,33)
	Send {f}
	RandomSleep(21,33)
	Send {f}
	RandomSleep(21,33)
	Run cports.exe /close * * * * PathOfExileSteam.exe
	Run cports.exe /close * * * * PathOfExile.exe
	Send {Esc}
	WinGetPos ,,,Width,Height
	X := Width / 2
	Y := Height * 0.38
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
}
CheckPos(){
    MouseGetPos, xpos, ypos
    msgbox, mx=%xpos% my=%ypos%
	return
}