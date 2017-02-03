Strict
Import jcr6.jcr6main

Import "console.bmx"

Global tryext$[]=["",".jcr",".zip",".pak",".tar"]

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


