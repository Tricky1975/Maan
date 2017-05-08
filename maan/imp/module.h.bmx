Rem
	Maan - Modules
	All needed modules listed here
	
	
	
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
Version: 17.03.02
End Rem
SuperStrict



'General
Import maxgui.maxgui
Import tricky_units.StringMap
Import tricky_units.GINI
Import brl.pngloader
Import brl.oggloader
Import tricky_units.Listfile
Import tricky_units.ListDir
Import tricky_units.tree
Import tricky_units.Dirry
Import tricky_units.MaxGUI_Input



'JCR6
Import jcr6.zlibdriver
Import jcr6.quakepak
Import jcr6.realdir
Import jcr6.tar4jcr6
Import jcr6.jcr6zipstream
Import brl.eventqueue

'GALE
Import gale.mgui
Import gale.multiscript

'IncBin
Incbin "error.ogg"

GALE_GUI_ErrorSound = LoadSound("incbin::error.ogg")
Rem
  This sound file was made by Bertrof was was downloaded from https://www.freesound.org/people/Bertrof/sounds/351563/
End Rem



MKL_Version "Maan - module.h.bmx","17.03.02"
MKL_Lic     "Maan - module.h.bmx","GNU General Public License 3"


Rem

These are nothing more but all modules needed by this project put together in one file.
Only MaxGui.Driver is not here, as it called by "maan.bmx" in the FrameWork command, I couldn't do that elseway
because FrameWork is an essential command in this project (not only it makes the executables smaller, but
it also prevents conflicts with GALE and MaxLua) and FrameWork can only be called from the main file, which is
I guess not really thought well through by BlitzMax if you see all this :P


End Rem
