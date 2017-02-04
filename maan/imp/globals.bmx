Strict
Import tricky_units.initfile2

Import "console.bmx"

MKL_Version "",""
MKL_Lic     "",""


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


CSay "Loading project: "+jcrmain+JCRext
Global JCR:TJCRDir = JCR_Dir(jcrmain+JCRext)
If Not JCR_Exists(jcr,"Project.prj") GALE_Error "Project.prj not present in resource file" End
Global Project:TIni = readini(JCR_B(jcr,"Project.prj"))
If project.c("Title") AppTitle = project.c("Title")

