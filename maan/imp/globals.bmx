Rem
	Maan - Globals
	
	
	
	
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
'Import jcr6.jcr6main

Import "console.bmx"

MKL_Version "Maan - globals.bmx","17.02.03"
MKL_Lic     "Maan - globals.bmx","GNU General Public License 3"


Global tryext$[]=["",".maan",".jcr",".zip",".pak",".tar"]

?macos
DebugLog AppFile
Private
	Global MacFile$ = AppFile
	For Local i=1 To 3 macfile=ExtractDir(macfile) Next
Public
Global JCRMain$ = StripExt(macfile)+"/Contents/Resources/"+StripAll(Macfile)
?windows
Global JCRMain$ = AppDir + StripAll(AppFile)
?linux
Global JCRMain$ = AppDir + StripDir(AppFile)
?

Global JCRExt$
Global JCRyes
AppTitle = "Maan"
For Local t$=EachIn(tryext) 
	DebugLog "Looking for "+jcrmain+t
	If FileType(JCRMain+t) jcrext=t JCRYes=True
Next
If Not jcrYes Then Notify "No project attached!" End


Global JCR:TJCRDir = JCR_Dir(jcrmain+JCRext)
