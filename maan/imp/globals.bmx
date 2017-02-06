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
Version: 17.02.04
End Rem
Strict


Import "console.bmx"

Include "gadgets.bmx"

Incbin "maan_prior.lua"

MKL_Version "Maan - globals.bmx","17.02.04"
MKL_Lic     "Maan - globals.bmx","GNU General Public License 3"


Global tryext$[]=["",".maan",".jcr",".zip",".pak",".tar"]

?macos
DebugLog AppFile
Private
	Global MacFile$ = AppFile
	For Local i=1 To 3 macfile=ExtractDir(macfile) Next

Public
Global JCRMain$ = StripExt(macfile)+".app/Contents/Resources/"+StripAll(Macfile)
?windows
Global JCRMain$ = AppDir + StripAll(AppFile)
?linux
Global JCRMain$ = AppDir + StripDir(AppFile)
?

Global JCRExt$
Global JCRyes
AppTitle = "Maan"
For Local t$=EachIn(tryext) 
	Print "Looking for "+jcrmain+t
	If FileType(JCRMain+t) jcrext=t JCRYes=True
Next
If Not jcrYes Then Notify "No project attached!" End


CSay "Loading project: "+jcrmain+JCRext
Global JCR:TJCRDir = JCR_Dir(jcrmain+JCRext)
If Not JCR_Exists(jcr,"Project.prj") GALE_Error "Project.prj not present in resource file" End
Global Project:TIni = ReadIni(JCR_B(jcr,"Project.prj"))
If project.c("Title") AppTitle = project.c("Title")
GALEMSJCR = JCR


Global PriorScript$ = LoadString("incbin::maan_prior.lua")




Type TMaanGadget
	Field gadget:TGadget
	Field gc$
	Field changed = True
	Field parent$
	Field data:StringMap = New StringMap
	Field kids:TList = New TList
	Field NoUpdates
	Field ID$	
	Field form$
	Method Call(func$,id$,p$="")
		Local pp$[]=tbl(id)		
		Local para$=pp[1]
		Local k$=pp[0]
		If p para:+";"+p
		GALE_MS_Run "FORM_"+form,k+"_"+func,para.split(";")
	End Method
	Method CreateMe()
		Local a:TGadTemplate = GetTemplate(gc)
		a.createme Self
	End Method
	Method tx(a$)
		Local c$=Trim(data.value(a))
		Local r=c.toint()
		If Suffixed(c,"%")
			r = Floor( Double(ClientWidth(ByName(parent).Gadget)) * Double(Double(Left(c,Len(c)-1).todouble()/100)))
		EndIf
		Return r
	End Method		
	Method ty(a$)
		Local c$=Trim(data.value(a))
		Local r=c.toint()
		If Suffixed(c,"%")
			r = Floor(Double(ClientHeight(ByName(parent).Gadget)) * Double(Double(Left(c,Len(c)-1).todouble()/100)))
		EndIf
		Return r
	End Method		

End Type

Global GadByGad:TMap = New TMap
Global GadByName:TMap = New TMap
Global GadOrder:TList = New TList ' All gadgets in the order in which they are created

Function GadgetToMaan(Gadget:TGadget,ID$,parent$="")
	Local w:Tmaangadget = New tmaangadget
	w.gadget=gadget
	w.parent=parent
	MapInsert w.data,"x","$"+Hex(GadgetWidth(gadget))
	MapInsert w.data,"y","$"+Hex(GadgetWidth(gadget))
	w.NoUpdates = True ' This gadget will never be updated itself, but its kids still can be.
	MapInsert gadbygad,gadget,w
	MapInsert gadbyname,ID,w	
End Function

Function ByName:TMaangadget(id$)
	Return tmaangadget(MapValueForKey(gadbyname,id))
End Function

Function ByGad:TMaangadget(G:TGadget)
	Return tmaangadget(MapValueForKey(gadbygad,g))
End Function

