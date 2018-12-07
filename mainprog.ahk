#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, Tooltip, Screen 
SetBatchLines, -1

;define all image variables
offerPath = %A_ScriptDir%\trendingplaylist.png

nextPagePath = %A_ScriptDir%\nextpag.png
nextPageLoopSleep = 250
nextPageLoopMax = 480

nowDiscPath = %A_ScriptDir%\nowdiscoveringbutton.png
startEarnPath = %A_ScriptDir%\startearning1.png
ncraveLogoPath = %A_ScriptDir%\ncravelogo.png
bookmarkPath = %A_ScriptDir%\encravebookmark.png
pageBottomPath = %A_ScriptDir%\bottomofpageindicator.png
endpicturePath = %A_ScriptDir%\continueengaging.png
discmodePath = %A_ScriptDir%\discoverymodeon.png
discbuttonPath = %A_ScriptDir%\discoverymodebutton.png

offerInitSleep = 250
offerInitLoopMax = 880



;MainLoop
;screenshot()
Loop
{
	;search and wait for bookmark
	;once found click
Loop
{
	ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %bookmarkPath%
	if ErrorLevel = 2
		MsgBox Could not conduct the search.
	else if ErrorLevel = 1 ; did not find 
	{

	}
	else ;found bookmark
	{
		sleep 2500
		MouseClick, L, OutputVarX, OutputVarY
		sleep 1500
		break
	}
}
;search and wait for ncrave loaded logo, click on it
Loop
{
	ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ncraveLogoPath%
	if ErrorLevel = 2
		MsgBox Could not conduct the search.
	else if ErrorLevel = 1 ; did not find ncraveLogo
	{

	}
	else ;found 
	{
		MouseClick, L, OutputVarX, OutputVarY
		sleep 2500
		break
	}
}
;search for searched offer, if not found, scroll down 3 times, if bottom of page indicator, error
Loop
{
	ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %offerPath%
	if ErrorLevel = 2
		MsgBox Could not conduct the search.
	else if ErrorLevel = 1 ; did not find 
	{
		ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %pageBottomPath% ;bottom of page indicator
		if ErrorLevel = 2
			MsgBox Could not conduct the search.
		else if ErrorLevel = 1 ; did not find 
		{
			SendInput, {DOWN}
			sleep 500
			SendInput, {DOWN}
			sleep 500
			SendInput, {DOWN}
			sleep 500
		}
		else ;found 
		{
			msgbox Bottom of page not found offer
			break
		}
	}
	else ;found 
	{
		MouseClick, L, OutputVarX, OutputVarY
		StartTime := A_TickCount
		sleep 1500
		offerInit()
		sleep 500
		disableDiscMode()
		sleep 1500
		nextPageLoop()
		sleep 1000
		screenshot()
		sleep 500
		writeSaveData()
		sleep 500
		SendInput, ^w
		break
	}
}
}
;once offer found click, start timer

;run offerinit
;run screenshot function
;run writesavedata functon
		
;offerinit
	;for five seconds search for either start earning, next page or now discovering button
	;if none found in 5 seconds tab back function and try again
	;if ncrave loaded logo found error out
	;if start earning found click, run tab back function, break the loop
	;if next page or now discovering found, break the loop
	;time out after 2 minute
offerinit()
{
	global
	count = 0
	loop 
	{
		;check nextpage
		ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextPagePath%
		if ErrorLevel = 2
			MsgBox Could not conduct the search. nextPP
		else if ErrorLevel = 1 ; did not find nextpage
		{
			;check now discoverying
			ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nowDiscPath%
			if ErrorLevel = 2
				MsgBox Could not conduct the search.
			else if ErrorLevel = 1 ; did not find now discovering
			{
				;check start earning
				ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %startEarnPath%
				if ErrorLevel = 2
					MsgBox Could not conduct the search.
				else if ErrorLevel = 1 ; did not find start earning
				{
					;check ncrave logo
					ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %ncraveLogoPath%
					if ErrorLevel = 2
						MsgBox Could not conduct the search.
					else if ErrorLevel = 1 ; did not find ncraveLogo, or anything
					{
						counter++
						if (counter > offerInitLoopMax)
						{
							MsgBox offerInit timed out
						}
						tabBack()
						sleep 1500
					}
					else ;found ncraveLogo
					{
						msgbox Error offerinit ncrave logo
					}
				}
				else ;found the start earning
				{
					MouseClick, L, OutputVarX, OutputVarY
					tabBack()
					break
				}
			}
			else ;found the now discovering
			{
				break
			}
		}
		else ;found the nextPage
		{
			break
		}
		sleep, %offerInitSleep%
	}
}
		
;imagesearchiterativefunction
	;loop through multiple possible sets of images until error2 or finish
	;return first found
		
;discoveryloop
	;search for now discovering, 
	
;disableDiscoveryMode
	;look for discovery mode
	;look for the button
	;click
disableDiscMode()
{
	global
	ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %discModePath%
	if ErrorLevel = 2
		MsgBox Could not conduct the search.
	else if ErrorLevel = 1 ; did not find disc mode
	{

	}
	else ;found 
	{
		ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %discbuttonPath%
		if ErrorLevel = 2
			MsgBox Could not conduct the search.
		else if ErrorLevel = 1 ; did not find 
		{

		}
		else ;found 
		{
			MouseClick, L, OutputVarX, OutputVarY
			sleep 1500
		}
	}
}
		
;nextpageloop
	;search for next page
		;if found, hit next page, run tab back function
	;time out after 2 minutes
nextPageLoop()
{
	global
	counter = 0
	Loop 
	{
		ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nextPagePath%
		if ErrorLevel = 2
			MsgBox Could not conduct the search.next pp2
		else if ErrorLevel = 1
		{
			;check if offer complete
			ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %endpicturePath%
			if ErrorLevel = 2
				MsgBox Could not conduct the search.
			else if ErrorLevel = 1
			{
				;check if offer complete
				ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %nowDiscPath%
				if ErrorLevel = 2
					MsgBox Could not conduct the search.
				else if ErrorLevel = 1
				{
					tabBack()
					sleep 1500
				}
				else
				{
					counter++
					if (counter > nextPageLoopMax)
					{
						MsgBox NextPageLoop timed out
					}
				}
			}
			else
			{
				break
			}
		}
		else
		{
			MouseClick, L, OutputVarX, OutputVarY
			sleep 2000
			tabBack()
			counter = 0
		}
		
		sleep %nextPageLoopSleep%
	}
}

;tab back function
	;tab back keys control shift tab
tabBack()
{
	SendInput, ^+{Tab}
}
	
;screenshot function
;print screen
;control a
;control s
screenshot()
{
	SendInput, {PrintScreen}
	sleep 1000
	SendInput, ^a
	sleep 500
	SendInput, ^s
	sleep 500
}

;write savedata function
writeSaveData()
{
	global
	endTime := A_TickCount - StartTime
	;msgbox %startTime%, %endTime%, %A_TickCount%
	FileAppend,
	(
	`n
	%offerPath%
	%endTime%
	`n
	), Test.txt
}
;make sure most time is spent on now discovering page
	;check if currently on doing offer page
		;can you see the gray "now discovering" button
		;can you see discovery mode
		;can you see other elements that indicate that the offer is currently going on
	;if on the page, keep checking to see if a button gets ready, or payment is sent, or offer is completed

;check if doing offer tab is up
	;move to such tab, continue
	
;if not can it see the "start earning" button?

;if cannot see such tab, can it see encrave page with offers on it
	;or the tab for this page
	
;if not can it see the launch encrave in new window button

;if it an't then can it see the bookmark

;if it can't then can it see browser is open
	;if not open browser and start going down process
