Rem
	Maan - Main Engine
	
	
	
	
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
Version: 17.02.04
End Rem
' empty script only set up to make sure the building script works

' (The maan.icns file is present here, because I use a modified version of bmk myself which will automatically put the icon in the map bundle)


Strict
Framework MaxGui.Drivers
Import    brl.pngloader
Import    jcr6.zlibdriver
Import    jcr6.quakepak
Import    jcr6.realdir
Import    jcr6.tar4jcr6
Import    jcr6.jcr6zipstream

Import    "imp/globals.bmx" ' Temp line

MKL_Version "Maan - maan.bmx","17.02.04"
MKL_Lic     "Maan - maan.bmx","GNU General Public License 3"

updateversion
