strict
Import maxgui.maxgui
Import gale.mgui

Private
	Global consolewindow:TGadget = CreateWindow("Maan - Debug Console",0,0,ClientWidth(Desktop())*.75,ClientHeight(Desktop())*.75,Null,window_titlebar|window_center|Window_hidden)
	Global consolecontent:TGadget = CreateTextArea(0,0,ClientWidth(consolewindow),ClientHeight(consolewindow),consolewindow)
	
	SetGadgetColor consolecontent,255,180,0,0
	SetGadgetColor consolecontent, 25, 18,0,1
	
	
	GALE_ExitGadget = consolewindow
	GALE_ConsoleGadget = consolecontent
	
	

