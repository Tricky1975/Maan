Rem
	Maan - Debug Console
	
	
	
	
	(c) Jeroen P. Broks, 2017, All rights reserved
	
		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		You should have received a copy of the GNU General Public License
		along with this program.  If not, see <http://www.gnu.org/licenses/>.
		
	Exceptions to the standard GNU license are available with Jeroen's written permission given prior 
	to the project the exceptions are needed for.
Version: 17.02.03
End Rem
Strict
Import maxgui.maxgui
Import gale.mgui


MKL_Version "Maan - console.bmx","17.02.03"
MKL_Lic     "Maan - console.bmx","GNU General Public License 3"


Private
	Global consolewindow:TGadget = CreateWindow("Maan - Debug Console",0,0,ClientWidth(Desktop())*.75,ClientHeight(Desktop())*.75,Null,window_titlebar|window_center|Window_hidden)
	Global consolecontent:TGadget = CreateTextArea(0,0,ClientWidth(consolewindow),ClientHeight(consolewindow),consolewindow)
	
	SetGadgetColor consolecontent,255,180,0,0
	SetGadgetColor consolecontent, 25, 18,0,1
	
	
	GALE_ExitGadget = consolewindow
	GALE_ConsoleGadget = consolecontent
	
	
Public
	Function UpdateVersion() SetGadgetText consolewindow,"Maan v"+mkl.getnewestversion() " - Debug Console"

	Function CSay(M$)
		GaleCon.GaleConsoleWrite(M,255,180,0)
	End Function
	
	CSay("Maan - coded by: Jeroen Broks")
	CSay()
