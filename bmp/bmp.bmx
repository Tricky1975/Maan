
Strict

Framework tricky_units.initfile2
Import    tricky_units.ListDir
Import    tricky_units.prefixsuffix
Import    jcr6.zlibdriver

Import "bmp_template.bmx" ' debug line. MUST BE on REM in actual version.

MKL_Version "",""
MKL_Lic     "",""

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
	Print "   version -- Show all version numbers of used source files"
	Print "   make    -- Create the full application"
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

