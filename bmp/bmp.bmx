Rem
	Build Maan Project
	
	
	
	
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

Strict

Framework tricky_units.initfile2
Import    tricky_units.ListDir
Import    tricky_units.prefixsuffix
Import    jcr6.zlibdriver

'Import "bmp_template.bmx" ' debug line. MUST BE on REM in actual version.
Import "bmp_versions.bmx"
Import "bmp_make.bmx"

MKL_Version "Maan - bmp.bmx","17.02.04"
MKL_Lic     "Maan - bmp.bmx","GNU General Public License 3"

Global me$=StripAll(AppFile)
?macos
Const platform$="Mac"
?win32
Const platform$="Windows"
?Linux
Const platform$="Linux"
?

Print "Build Maan Project v"+MKL_NewestVersion()
Print "Coded by: Tricky"
Print "(c) Jeroen P. Broks 2017"
Print "Licensed under the GNU General Public License v3"

If (Len AppArgs)<2
	Print "Usage: "+me+" <action> <source folder> [<output folder>] [options]"
	Print 
	Print "Actions:"
	'Print "   version -- Show all version numbers of used source files"
	'Print "   make    -- Create the full application"
	bmp_explain
	Print
	Print "Options"
	For Local p$ = EachIn(ListDir(AppDir))
		If ExtractExt(p) And Prefixed(p,"maan_")
			Local pp$=StripExt(Right(p,Len(p)-5))
			Print Left("- p:"+pp+"             ",20)+" -- Build for Mac"
		EndIf
	Next	
	Print
	Print "If not platform has been defined, the system will only build for "+platform
	End
EndIf		

bmp_work AppArgs[1]
