
**Path Of Exile - Companion (AHK)**
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Auto-flask, Auto-Quit, 1-key Fast-pot, Gem-Swap, Auto-Divination Trade, Auto ID Items, Ctrl-Click & Shift-Click automations (sell, buy, currency spamm), various QoL shortcuts

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**PREREQUISITES**

- Have the game in **Windowed FullScreen** (preferably 1920x1080)

- Have your **HP bar above character** enabled from game settings

- Make sure you have the **character max-zoom out**!

- **Replace** PoeCompanion.INI with the INI that suits your resolution and game type (STEAM/Standalone)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**SETUP**

- Most of the functions will work automaticaly on **Windowed FullScreen 1920x1080** with wisdom & portal scrolls on the last 2 positions of the first row.

- **GemSwap and Auto-Flask** will need changes in the INI based on your setup and prefferences.

- For **different resolutions** all you need to do is to use **ALT+O** in game to find your resolution coordinates and change them in the INI file (10 mins work).

- **Run as Administrator** if you want to **use Auto-Quit**! You **dont need to run as admin** if you just want to use the exit to character screen.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**SUPPORT:** https://discord.gg/qfDkyTs

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Last Version:** https://github.com/nidark/Poe-Companion

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**FEATURES:**
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**ALT+F12**: Start/Stop Auto-Pot. Setup in the INI file the flasks and cooldowns !!!

**ALT+F11**: Start/Stop Auto-Quit

**\`** Pressing \` once will press 1,2,3,4,5 in fast seqvence 

**ALT+Space** Open a portal using a portal scroll from the top right inv slot

**ALT+I** ID all items in Inventory

**SHIFT+I** ID all items in the opened stash tab 

**ALT+C** CtrlClick full inventory (move all to stash or sell all to vendor), excepting the last 2 columnns

**SHIFT+C** CtrlClick the opened stash tab to move 12 X 4 (rows x columns) to the Inventory

**ALT+X**: CtrClick the opened tab starting from the MousePointer (needs to be a top cell). Usefull to move the second part of a stash tab to inventory.

**ALT+V** Trade all your divinations

**ALT+F** Shift-Click 50 times (Use it for Fusings/Jewler 6s/6l crafting)

**ALT+M** Switch 2 gems (ex: conc effect with area). Use CheckPos to change the gem positions in the function! 

**ALT+U** ALT+U keeps a key pressed until ALT+U is pressed again. Default is Key **Q** - can be changed in config

..................................................................................................................................................................................................................................................

**ALT+Y** Invite the last char who whispered you to party

**CTRL+WheelDown**  Spam CTRL+CLICK (Spam-buy from vendor, quick move to stash etc )

**SHIFT+WheelDown**  Spam SHIFT+CLICK  (Spam-crafting currency eg jewles, fusings)

**ALT+Wheel** Navigate through stash tabs

**ALT+G** /global 820

**ALT+T** /trade 820 

**ALT+H** /hideout 

**ALT+R** /remaining

**ALT+B** /abandon_daily

**ALT+L** /itemlevel

**ALT+P** /passives

**ALT+E** /exit

**ALT+Q**  Fast logout

**ALT+O**  Get the cursor position. Use it to change the position setup for Identify, OpenPortal, SwitchGem etc

**ALT+S**  Pressing it for 5 times will press 1,2,3,4,5 in fast seqvence
..................................................................................................................................................................................................................................................

**ALT+F1** Exit the script

**[**  Keep [ pressed to exit the current macro loop/function (usefull to exit a CTRL-Click or similar loop when you dont have a full inv)

..................................................................................................................................................................................................................................................


The  macros from the first section are NOT ALLOWED by GGG (EULA), as we send multiple server actions with one button pressed

This can't be identified as we randomize all timmings, but dont use it if you want to stick to the EULA 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**SETUP**
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**GENERAL**

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
The script works by clicking and reading data from different static screen locations. 

The default setup is for Windowed FullScreen 1920x1080, so for other resolutions, you will need to make a few changes.

To change such a location you just put the mouse in the respective place, press ALT+O, read the coordinates from the pop-out window and modify them in the INI file. 

**PREREQUISITES**

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
- Have the game in Windowed FullScreen (preferably 1920x1080, STEAM edition)
- Have your HP bar above character enabled from game settings
- Make sure you have the character max-zoom out!
- Replace PoeCompanion.INI with the INI that suits your resolution and game type (STEAM/Standalone) if I provided one on GitHub.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Windowed FullScreen 1920x1080: GemSwap & Auto-Flask**
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

The default ini/config is for the Steam version. 

For Standalone version of 1920x1080, replace first the PoeCompanion.INI with the contents of PoeCompanion_1920x1080Standalone.ini.

**GemSwap:**
1. Put the mouse over the Gem you currently use, press ALT+O and replace the in the INI file the CurrentGemX and CurrentGemY values with the ones from the pop-up window.

2. Do the same for the Gem you want to swap for, and change AlternateGemX and AlternateGemY

3. Save the INI file and restart the script.

4. Close the Inventory and press ALT+M. The script should change the Gems between themselfs.

If your alternate gem is on the secondary weapons slot (II), leave AlternateGemOnSecondarySlot=1.

If you keep the alternate gem in the inventory, put AlternateGemOnSecondarySlot=0

**Auto-Flask:** 

The default flask setup/example is based on my usage on the current character, so you need to change it, to fit your flask setup.
You can use any flask and any trigger combinations, by changing the setup in the INI file for the Auto-Pot section:

**[AutoPot]**

HPQuitTreshold=25 - No need to change, unless you want 

HPLowTreshold=40  - No need to change, unless you want 

HPAvgTreshold=65  - No need to change, unless you want 

HPHighTreshold=90  - No need to change, unless you want 

MainAttackKey=Q  - Whatever you use as primary attack

SecondaryAttackKey=W - Secondary attack

TriggerHPLow=11111 

TriggerHPAvg=10110

TriggerHPHigh=10010

TriggerMainAttack=01000

TriggerSecondaryAttack=01100

CoolDownFlask1=7000 - Flask 1 cooldown (7 secs default)

CoolDownFlask2=5000

CoolDownFlask3=5000

CoolDownFlask4=5000

CoolDownFlask5=3500

For example:

TriggerHPAvg=10110 -> Means that when your HP reaches HPAvgTreshold you ask to fire the pot 1,3,4 ... (10110)

TriggerMainAttack=01000 -> Means that when you press the MainAttack button the script will fire the second flask (01000)

CoolDownFlask2=5000 -> Means that Flask 2 will be fired every 5 seconds if/when needed, but not faster 

**Windowed FullScreen - Other Resolutions**
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ONLY If you have a different screen resolution than the default one (Windowed FullScreen 1920x1080) you will need to change the following in INI, using ALT+O function while in game.
If you use Steam version start from the default Steam version of the INI ... if you use Standalone start from the Standalone one.
   
For example, for the inventory change: 
Put the mouse on the first cell in the inventory, press ALT+O, take the coordinates and modify them in the INI file (InventoryX and InventoryY in this case).

**[Coordinates]**

InventoryX=1297 - First cell from the Inventory 

InventoryY=616  - First cell from the Inventory 

StashX=41 - First cell from the STASH

StashY=188 - First cell from the STASH

PortalScrollX=1859  - Portal scroll position from Inventory

PortalScrollY=616  - Portal scroll position from Inventory

WisdomScrollX=1820 - Wisdom scroll position from Inventory

WisdomScrollY=616 - Wisdom scroll position from Inventory

TradeButtonX=628  - Divination Cards Trade Button position 

TradeButtonY=735  - Divination Cards Trade Button position 

TradedItemX=646 -  Divination Cards Item position 

TradedItemY=565   - Divination Cards Item position 

GuiX=215 -  GUI position 

GuiY=935 -  GUI position 


**[ItemSwap]**

CurrentGemX=1483 - Curent GEM position

CurrentGemY=372  - Curent GEM position

AlternateGemX=1379 - New Gem position

AlternateGemY=171 - New Gem position


**[AutoPot]**

ChatX1=13 - Chat Icon Position - top left of the icon(Chat Icon is the small round icon on the left, just above your HP pool)

ChatY1=875  - Chat Icon Position - top left of the icon

ChatX2=20 - Chat Icon Position - bottom right of the icon

ChatY2=890 - Chat Icon Position - bottom right of the icon

HPX1=908 - HP bar left position (the one above the character's head)

HPY1=325 - HP bar left position (the one above the character's head)

HPX2=1012 - HP bar right position (the one above the character's head)

HPY2=327- HP bar right position (the one above the character's head)
