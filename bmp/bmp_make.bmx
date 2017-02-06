Rem
	bmp - Make
	This will actually build the entire maan application.
	
	
	
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
Version: 17.02.07
End Rem
Strict
Import "bmp_template.bmx"
MKL_Version "Maan - bmp_make.bmx","17.02.07"
MKL_Lic     "Maan - bmp_make.bmx","GNU General Public License 3"

Private

Global SwapDir$ = Dirry("$AppSupport$/$LinuxDot$bmpswap/")
Global SwapJCR$ = Swapdir+"Swap.jcr"
Global project$ 
Global ProjectJCR:TJCRDir
Global OutJCR:TJCRCreate
Global ProjectIni:TIni

Global OutputPlatforms:TList = New TList
Global outputdir$

Function CheckSwitches()
	Local i
	Local S$
	outputdir = ExtractDir(Project); If Not outputdir outputdir = "."
	For i=3 Until (Len AppArgs) 
		s=AppArgs[i]
		If Prefixed(s,"-p:")
			ListAddLast outputplatforms,Trim(Right(s,(Len s)-3))
		ElseIf Prefixed(s,"-d:")
			outputdir = Trim(Right(s,(Len s)-3))
		Else
			Print "I do not understand "+s End
		EndIf
	Next
	If ListIsEmpty(outputplatforms)
		?macos
		ListAddLast outputplatforms,"mac"
		?win32
		ListAddLast outputplatforms,"windows"
		?linux
		ListAddLast outputplatforms,"linux"
		?
	EndIf
	If Not outputdir outputdir="."
	outputdir = Replace(outputdir,"\","/")
	?win32
	If (Not (Len(outputdir)=2 And Right(outputdir))=":") And Right(outputdir,1)<>"/" outputdir:+"/"
	?Not windows
	If Right(outputdir,1)<>"/" outputdir:+"/"
	?
	SortList outputplatforms
	'For Local p$=EachIn outputplatforms Print "Result will be outputted to platform: "+p next
End Function

Function Analyse()
	Print "Analysing directory" 
	projectjcr = JCR_Dir(project)
	If Not projectjcr Print "Failed to read the project" End
	Print "   = Project type: "+projectJCR.DirDrvName
	Print "Reading Project Data"
	projectini = ReadIni(JCR_B(Projectjcr,"Project.Prj"))
	If Not projectini Print "Illegal project.prj file, or the requested file is not present at all"
	Print "   = Title: "+projectini.C("Title")
	Print "   = Author: "+ProjectIni.C("Author")	
	For Local k$=EachIn projectIni.EachVar()
		D_Add "%"+Lower(k)+"%",projectini.c(k); DebugLog "%"+Lower(k)+"% added to dirry ("+projectini.c(k)+")"
	Next
End Function

Function CheckForms()
	Local l$
	For Local f$=EachIn MapKeys(projectjcr.entries)
		l = StripExt(F)+".LUA"
		'DebugLog Prefixed(f,"/FORMS")+";"+ExtractExt(f)+";"+JCR_Exists(ProjectJCR,l)
		If Prefixed(f,"FORMS/") And ExtractExt(f)="FORM" And (Not JCR_Exists(ProjectJCR,l))
			Print "Warning! No Lua script for form: "+F+"; Creating: "+l
			outjcr.AddString "--[[ ~n~tThere was no script present for form file: "+F+"~nThat's why this script file ("+L+") was created.~n~tConsider this specific script file as public domain~n]]",l,"zlib","Jeroen P. Broks","Passed in because no script file was present, and now at least needless crashes have been prevented~nConsider this specific 'script' file as Public Domain"
		EndIf	
	Next
End Function

Function PackResources()
	Local k$,e:TJCREntry
	For Local f$=EachIn MapKeys(projectjcr.entries)
		e = TJCREntry(MapValueForKey(projectjcr.entries,f))
		Print "   = Packing: "+e.filename
		outjcr.AddEntry JCR_B(projectjcr,f),e.filename,"zlib"
	Next
End Function

Function Output(platform$)
	Print "Exporting project to "+platform
	DebugLog "Reading: "+AppDir+"/maan_"+platform+".jcr"
	If Not FileType(AppDir+"/maan_"+platform+".jcr") Then Print "= No data for that platform available" Return
	Local J:TJCRDir = JCR_Dir(AppDir+"/maan_"+platform+".jcr")
	If Not J Then Print "= Sorry, I could not read the data for that platform properly." Return
	Local e:TJCREntry 
	Local i:TIni = ReadIni(JCR_B(J,"ini/maan.ini"))
	If Not i Print "= No data for platform "+platform+" in the platform settings file" Return
	Local o$=i.c("exeori")
	Local t$=i.c("exeout")
	Local f$
	For e=EachIn MapValues(J.entries)
		'Print e.filename+Prefixed(e.filename,"ext/")
		If Prefixed(e.filename,"ext/")
			f = Right(e.filename,(Len(e.filename))-4)
			f = Replace(f,o,t)
			WriteStdout "= Extracting "+e.filename+" to "+outputdir+Dirry(f)+" ... "
			CreateDir outputdir+ExtractDir(Dirry(f)),1
			JCR_Extract j,e.filename,outputdir+Dirry(f),True
			If FileType(outputdir+Dirry(f)) Print "Ok" Else Print "Failed"
		End If
	CreateDir outputdir+ExtractDir(outputdir+Dirry(i.c("resout")))
	If Not CopyFile(swapjcr,outputdir+Dirry(i.c("resout"))) Print "= Resource could not be properly copied to: "+outputdir+Dirry(i.c("resout")) Return
	Next
End Function

Function iOutput()
	For Local p$=EachIn outputplatforms
		output p
	Next
End Function


Function Make()
	ChangeDir LaunchDir
	If Len(AppArgs)<3 Print "No project"; End Else project=AppArgs[2]
	If (Len AppArgs)>2 CheckSwitches
	Print "Processing project: "+Project; Analyse
	Print "Creating swap dir"; If Not CreateDir(swapdir,1) Print "Unable to create swap dir"; End
	Print "Creating resource" outjcr = JCR_Create(SwapJCR); If Not outjcr Then Print "I could not create: "+SwapJCR End
	Print "Checking forms"; CheckForms
	Print "Packing resources"; PackResources
	outjcr.close "zlib"
	iOutput
	Print "Operation completed"
End Function





' link it all to the main program

Type bmp_make Extends bmp_template
	Method Work()
		Make
		End
	End Method
End Type


bmp_register "make",New bmp_make,"Make the full Maan application and turn it into an functional program"	

