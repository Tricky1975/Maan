Rem
	Maan - Lua API
	
	
	
	
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
Strict

Import "globals.bmx"

MKL_Version "Maan - lua.bmx","17.03.02"
MKL_Lic     "Maan - lua.bmx","GNU General Public License 3"


Rem
  This has been set up to allow Lua to communicate
  with the underlying Maan Gadgets.
   
  It's not recommended to call these gadgets directly
  but the use the functions calling them from the maan_prior.lua file
  in stead, to ensure as much compatibility with future maan versions.
End Rem

Type MaanLuaAPI
	Method gadget:tmaangadget(n$)
		Local ret:tmaangadget = byname(n)
		If Not ret GALE_Error "Gadget "+n+" not found!"
		Return ret
	End Method
	
	Method STEXT(n$,t$)
		SetGadgetText gadget(n).gadget,t
	End Method
	
	Method gData$(n$)
		Local g:tmaangadget = gadget(n)
		Local ret$
		For Local k$=EachIn MapKeys(g.data)
			If ret ret:+",~n"
			ret:+"['"+k+"'] = '"+g.data.value(k)+"'"
		Next
		Return "return {"+ret+"}"
	End Method	
	
	Method IText$(N$,i=-1) ',t$="",change=0)
		Local g:tmaangadget = gadget(n)
		Local item = i; If item<=-1 item=SelectedGadgetItem(g.gadget)
		If item<=-1 Return
		Return GadgetItemText(g.gadget,item)
	End Method
	
	Method State(n$) Return ButtonState(gadget(n).gadget) End Method
	
	Method JCRPatch(f$,path$,sig$)
		JCR_AddPatch JCR,f,sig,path
	End Method
	
	Field Temphidden:TList
	Method TempHide()
		If Temphidden GALE_Error "You may only use the hide function once. Unhide first before using it again!"
		Temphidden = New TList
		For Local MG:Tmaangadget = EachIn GadOrder
			If (Not MG.Hidden ) And MG.gc="Window"
				ListAddLast temphidden,MG
				MG.gadget.SetShow False
			EndIf
		Next
	End Method
	Method TempIsHidden()
		Return TempHidden<>Null
	End Method
	Method TempUnHide()
		If Not Temphidden GALE_Error "You can't unhide what was never hidden in the first place."
		For Local MG:Tmaangadget = EachIn TempHidden
			MG.gadget.SetShow True
		Next
		temphidden=Null
	End Method
	
	
	Method Input$(Question$,DefaultString$,AllowCancel,AllowCharacters$)
		TempHide
		CSay "Requesting input from user"
		Local ret$ = MaxGUI_Input(Question$,DefaultString$,AllowCancel,AllowCharacters$)
		TempUnHide
		Return ret
	End Method
	
	Method SaveForm(Form$)	
		If Form = "*ALL*"
			'Local G:tMaanGadget = ByName("SYS_DESKTOP")
			For Local G:tMaanGadget = EachIn gadorder 
				If Prefixed(G.ID,"FORM_") SaveForm G.ID 
			Next
			Return
		EndIf
		Local sd$ = Dirry(project.c("formsavedir")) If Not sd Return
		If Not CreateDir(sd,1) 
			CSay "WARNING! I cannot save any data, since I could not create output dir: "+sd
			Return
		EndIf
		Local S:TLua = GALE_GetScript(form)
		SaveString S.Save("SAVE"),sd+"/"+form+".lua"			
	End Method
	
	Method Bye()
		SaveForm "*ALL*"
		End
	End Method
	
 	Field UName$=StripDir(Dirry("$Home$"))

End Type


GALE_Register New MaanLuaAPI,"MAAN"
