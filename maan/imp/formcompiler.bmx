Rem
	Maan - Form Compiler
	Compiles .form files into the actual windows and its contents
	
	
	
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

MKL_Version "Maan - formcompiler.bmx","17.03.02"
MKL_Lic     "Maan - formcompiler.bmx","GNU General Public License 3"







Function CreateAllGadgets()
	' Creates all gadgets but only if they do not exist yet.
	CSay "Creating Gadgets"
	For Local MG:TmaanGadget = EachIn gadorder
		If Not MG.Gadget 
			mg.recaption
			mg.createme; CSay " = Created gadget: "+mg.id; MapInsert gadbygad,mg.gadget,mg
			mg.colorme
			mg.pictureme
			If mg.data.value("block").toupper()="YES" mg.gadget.setenabled False
			For Local item$=EachIn mg.startitems AddGadgetItem mg.gadget,item Next
		EndIf
	Next
	csay "Creation complete"
End Function

Function CompileForm(form$)
	CSay "Compiling form: "+form
	Local cl=0
	Local line$
	Local currentgadid$="FORM_"+Form
	Local w:TmaanGadget = New tmaanGadget
	Local pis,sis
	Local curparent$ = "SYS_DESKTOP"
	MapInsert gadbyname,currentgadid,w
	ListAddLast gadorder,w
	ListAddLast byname("SYS_DESKTOP").kids,w
	w.parent="SYS_DESKTOP"
	w.gc="Window"
	w.id = Currentgadid
	w.form = form
	' Parse all data
	For Local serialline$=EachIn Listfile(JCR_B(jcr,"Forms/"+form+".form"))
		cl:+1
		line = Trim(serialline)
		If line And Chr(line[0])<>"#" And (Not Prefixed(line,"--"))
			pis = line.find("=")
			sis = line.find(" ")
			If Prefixed(line,"item ")
				ListAddLast w.startitems,line[5..]
			ElseIf Prefixed(Lower(line),"tab ")
				Local pg:Tmaangadget = byname(curparent)
				CSay "Tab ~q"+line[4..]+"~q for "+curparent
				If pg.gc<>"Tabber" GALE_Error "Tabs may only be kids to a tabber and not a "+pg.gc
				w = New TMaanGadget
				Local i=-1
				Local cid$
				Repeat
					i:+1
					cid = "TAB_"+curparent+"__TAB#"+i
				Until Not MapContains(gadbyname,cid)
				w.id = cid
				w.parent=curparent
				MapInsert w.data,"caption", line[4..]
				w.gc="Tab"
				currentgadid=cid
				ListAddLast gadorder,w
				MapInsert gadbyname,cid,w
				CSay "Tab created as: "+w.id
			ElseIf pis>-1 Then
				Local k$=line[..pis]
				Local v$=line[pis+1..]
				If Not k GALE_Error "No variable in line #"+cl
				MapInsert w.data,k,v
			ElseIf sis>=0
				Local c$=line[..sis]
				Local v$=line[sis+1..]
				If (Not MapContains(maanclasses,c)) Or Prefixed(c,"SYS_") GALE_Error "I cannot create a "+c+" -- line #"+cl
				If curparent="SYS_DESKTOP" GALE_Error "No kids/children block set up in line #"+cl
				w = New TMaanGadget
				ListAddLast gadorder,w
				w.parent = curparent
				currentgadid = "KID_"+Upper(c)+"_"+v
				w.id = currentgadid
				w.form = form
				w.gc = c
				'w.myclass=c
				If MapContains(gadbyname,currentgadid) GALE_Error "Duplicate naming in line #"+cl
				MapInsert gadbyname,currentgadid,w
				CSay " = Created data record "+Lower(c)+" "+v+" as "+currentgadid+" on parent "+w.parent
			Else
				Select line
					Case "kids","children"
						curparent=currentgadid
						CSay " = Kids for: "+currentgadid+" ("+curparent+")"
					Case "end","endkids","endchildren"
						If curparent="SYS_DESKTOP" GALE_Error "No kids group to end in line #"+cl
						Local p$ = curparent
						curparent = byname(p).parent
						CSay " = Kids sequence ended, back to parent: "+curparent
						If Left(curparent,1)="/"
							CSay("Internal error!")
							For Local k$=EachIn(MapKeys(gadbyname))
								CSay K+" has parent: "+byname(k).parent
							Next
						GALE_Error "Internal error"	
						EndIf
							
					Default
						GALE_Error "I don't understand line #"+cl
				End Select
			EndIf
		EndIf
	Next
	' And now put this all into "reality"
	CreateAllGadgets
	Local savedvar$
	Local savedvarfile$ = Dirry(project.c("formsavedir"))+"/FORM_"+form+".lua"
	CSay "Saved variables: "+savedvarfile
	If FileType(savedvarfile) savedvar=LoadString(savedvarfile)
	Local s:TLua = GALE_LoadScript(jcr,"Forms/"+form+".lua",savedvar,priorscript)
	If Not s GALE_Error "Sorry, compilation failed!"
	GALE_AddScript "FORM_"+form,s
End Function
