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

Import "formcompiler.bmx"


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
	
	Method Item(N$,i=-1)	
		Local g:tmaangadget = gadget(n)
		If i>=0 SelectGadgetItem(g.gadget,i)
		Return SelectedGadgetItem(g.gadget)
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
	
	Method SysCall(a$)
		system_ a
	End Method
	
	Method Exec(a$)
		If Not a CSay("ERROR! Exec NEEDS input!")
		?win32
		If Not FileType(a+".exe") 
			CSay "ERROR! I could not find "+a+".exe"
			Return
		EndIf
		system_ "~q"+a+".exe~q"
		?MacOS
		If FileType(a+".app")
			system_ "open ~q"+a+".app~q"
			Return
		ElseIf FileType(macfile+"/Contents/Resources/"+a+".app")
			system_ "open ~q"+macfile+"/Contents/Resources/"+a+".app~q"	
		ElseIf FileType(macfile+"/Contents/Resources/"+a)
			system_ "~q"+macfile+"/Contents/Resources/"+a+"~q"
		EndIf		
		?Not win32
		' This approach is chosen, as this can apply to both Linux as Mac, but definitely NOT to Windows.
		If Not FileType(a)
			CSay "ERROR! I could not found executable "+a+"; please note that PATHs do not work here!"
			Return
		EndIf		
		If Not ExtractDir(a) And Left(a,1)<>"/" a="./"+a
		system_ "~q"+a+"~q"
		? 	
	End Method
	
	Method SaveStr(str$,fil$)
		Local gohome = True
		If Not fil Return CSay("ERROR! Save request to empty file name")
		fil = Replace(fil,"\","/")
		?win32
		If Len(fil)>1 And Chr(fil[1])=":" gohome=False
		?
		If Prefixed(fil,"./") Or Chr(fil[0])="/" gohome=False
		If gohome 
			fil=Dirry("$AppSupport$/$LinuxDot$Maan/")+PrjID+"/"+fil
			CreateDir ExtractDir(fil),1
		EndIf	
		SaveString str,fil
	End Method
	
	Method LoadStr$(fil$,fil2$,Crash=False)
		Local gohome = True
		If Not fil Return CSay("ERROR! Save request to empty file name")
		fil = Replace(fil,"\","/")
		?win32
		If Len(fil)>1 And Chr(fil[1])=":" gohome=False
		?
		If Prefixed(fil,"./") Or Chr(fil[0])="/" gohome=False
		If gohome 
			fil=Dirry("$AppSupport$/$LinuxDot$Maan/"+PrjID+"/"+fil)
		EndIf
		Local J:Object = fil
		If fil2 Then
			If fil="*ME*" J=JCR
			If crash Or JCR_Exists(	J,fil2) Return LoadString(JCR_B(J,fil2))
		Else
			If Not FileType(fil) 
				CSay "File "+fil+" not found"
				Return
			EndIf	
			Return LoadString(fil)
		EndIf
	End Method
	
	Method FLType(fil$)
		Return FileType(Fil)
	End Method
	
	Method GetDirry$(fil$)
		Return Dirry(fil)
	End Method
	
	Method MkDir(d$,recurse=0)
		DebugLog "MkDir(~q"+d+"~q,"+recurse+")"
		Return CreateDir(d,recurse)
	End Method
	
	Method ChDir(d$)
		ChangeDir(d)
	End Method
	
	Method LoadFormIfNeeded(Form$)
		If Not MapContains(gadbyname,Form) Then
			CompileForm form$[5..]
		EndIf	
	End Method	
	
	Method IAdd(GN$,T$)
		Local g:tmaangadget = gadget(gN$)
		AddGadgetItem g.gadget,t
	End Method
	
	Method IClear(GN$)
		Local g:tmaangadget = gadget(gN$)
		ClearGadgetItems g.gadget
	End method
	
	Method IndexedGadgets$(Gadget$)
		Local ret$,k$
		For K$=EachIn MapKeys(gadbyname)
			Local p,GDN$,IDX$
			p=k.find("#")
			If p>0
				GDN=k[..p]
				IDX=k[p+1..]
				If GDN=Gadget
					If ret ret:+",~n~t"
					ret:+"~q"+IDX+"~q"
				EndIf	
			EndIf
		Next	
		Return "return {~n~t"+ret+"}"
	End Method	
	
	Method Exist(gadget$)
		Return MapContains(Gadbyname,gadget)
	End Method

	Method JCR_Dirs$(JF$="")
		Local J:TJCRDir = JCR
		If JF J=JCR_Dir(JF)
		Local TL:TList = New TList
		Local D$
		For Local f:TJCREntry=EachIn MapValues(J.entries)
			D=ExtractDir(f.filename)
			If (Not ListContains(TL,d)) And d ListAddLast tl,d
		Next
		Local ret$
		For d=EachIn tl		
			If ret ret:+",~n~t"
			ret:+"~q"+d+"~q"
		Next
		Return "return {~n~t"+ret+"~n}"
	End Method
	
	Method JCR_IsFile(f1$,f2$)
		Local J:TJCRDir = JCR
		Local f$ = f1
		If f2 
			j = JCR_Dir(f1)
			f = f2
		End If
		Return JCR_Exists(J,f)
	End Method
	
	Method ExDir$(d$)	Return ExtractDir(d)	End Method
	Method ExExt$(d$)	Return ExtractExt(D)	End Method
	Method StrDir$(d$)	Return StripDir(d)		End Method
	Method StrExt$(d$)	Return StripExt(d)		End Method
	Method StrAll$(d$)	Return StripAll(d)		End Method
	
	Method RQF$(c$,f$,save=0,d$)
		Return RequestFile(c,f,save,d)
	End Method
	
	Method RQd$(c$)
		Return RequestDir(c)
	End Method
	
	Method AddText(N$,t$)
		Local g:tmaangadget = gadget(N$)
		AddTextAreaText g.gadget,t
	End Method	
	
	Method DirList$(d$,flag,hidden=0)
		Local lijst:TList=ListDir(d,flag,hidden)
		Local ret$
		For d=EachIn lijst		
			If ret ret:+",~n~t"
			ret:+"~q"+d+"~q"
		Next
		Return "return {~n~t"+ret+"~n}"		
	End Method
	
	Method Tree$(d$,hidden=0)
		Local lijst:TList=CreateTree(d,1,hidden)
		Local ret$
		For d=EachIn lijst		
			If ret ret:+",~n~t"
			ret:+"~q"+d+"~q"
		Next
		Return "return {~n~t"+ret+"~n}"		
	End Method
	
	Method Poll()
		PollEvent
	End Method
	
	
 	Field UName$=StripDir(Dirry("$Home$"))

End Type


GALE_Register New MaanLuaAPI,"MAAN"
