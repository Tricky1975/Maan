Rem
	Maan - Gadgets
	How to handle gadgets
	
	
	
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
Version: 17.02.16
End Rem
' This file MUST be called by "include" and not by "import" as it needs some backwards call which can not be made through import.

MKL_Version "Maan - gadgets.bmx","17.02.16"
MKL_Lic     "Maan - gadgets.bmx","GNU General Public License 3"


Global MaanClasses:TMap = New TMap

Function tbl$[](a$)
	Local ret$[] = New String[2]
	Local p=a.find("#")
	If p=0 
		GALE_Error "Invalid definition: "+a
	ElseIf p=-1 
		ret[0]=Trim(a)
		ret[1]=""
	Else
		ret[0]=Trim(a[..p])
		ret[1]=Trim(a[p+1..])
	EndIf
	Return ret
End Function	


Type TGadTemplate
	
	Method Action(id$)
		Local g:TMaangadget = ByName(id)
		g.call "Action",id
	End Method
	
	Method SelectG(id$)
		
	End Method
	
	Method Close(id$)
		byname(id).call "Close",id
	End Method
	
	Method CreateMe(g:tmaanGadget) Abstract
	
	Method ColorMe(G:tmaangadget)
		'Local r,g,b
		Local sr$=G.data.value("r")
		Local sg$=g.data.value("g")
		Local sb$=g.data.value("b")
		If (sr And sg And sb) SetGadgetColor g.gadget,sr.toint(),sg.toint(),sb.toint(),False; CSay "Foreground "+sr+","+sg+","+sb
		sr$=G.data.value("br")
		sg$=g.data.value("bg")
		sb$=g.data.value("bb")
		If (sr And sg And sb) SetGadgetColor g.gadget,sr.toint(),sg.toint(),sb.toint(),True; CSay "Background "+sr+","+sg+","+sb
	End Method
	
	Method PictureMe(G:TMaanGadget)
		Local aflags$[] = g.data.value("picflags").split(" ")
		Local pic$ = g.data.value("pic")
		Local source$ = g.data.value("picsource"); If Not source source="*ME*"
		Local pixmap:TPixmap
		If Not pic Return
		CSay " = Adding picture from source ~q"+source+"~q, file ~q"+pic+"~q to Gadget: "+G.id
		Select source.toupper()
			Case "*REAL*"
				pic = Dirry(pic)
				pixmap = LoadPixmap(pic)
				If Not pixmap CSay("WARNING! File "+pic+" has not been found in your file system")
			Case "","*ME*"
				pixmap = LoadPixmap(JCR_B(JCR,pic))
				If Not pixmap CSay("WARNING! File "+pic+" has not been found in the maan resource")
			Default
				source = Dirry(source)
				pixmap = LoadPixmap(JCR_B(source,pic))
				If Not pixmap CSay("WARNING! File "+pic+" could not be accessed from resouce:"+source)
		End Select
		If Not pixmap Return
		Local flags = -1
		For Local f$=EachIn aflags	
			If flags<0 flags=0
			If GadgetClass(g.gadget)=gadget_panel		
				Select Upper(f)
					Case "TILE","TILES","TILED"
						flags:|PANELPIXMAP_TILE
					Case "CENTER"	
						flags:|PANELPIXMAP_CENTER	
					Case "FIT"
						flags:|PANELPIXMAP_FIT	
					Case "FIT2"
						flags:|PANELPIXMAP_FIT2
					Case "STRECH"
						flags:|PANELPIXMAP_STRETCH		
					Default
						CSay "WARNING! Unknown picture flag for the use in a "+g.gc+" ("+f+")"
				End Select
			ElseIf GadgetClass(g.gadget)=gadget_button Or GadgetClass(g.gadget)=gadget_menuitem
				flags:|GADGETPIXMAP_ICON
				Select Upper(f)
					Case "NOTEXT"	flags	:|	GADGETPIXMAP_ICON	
					Default	CSay"WARNING! Unknown picture flag for the use in a "+g.gc+" ("+f+")"
				End Select
			Else
				flags=-1	
			EndIf			
		Next	
		If flags<0 CSay("WARNING! Unable to attach a picture to your "+Lower(g.gc)+":"+g.id+"~nEither this class doesn't support pictures or your flags are not properly set"); Return
		SetGadgetPixmap g.gadget,pixmap,flags								
	End Method	

End Type

Function GetTemplate:TGadTemplate(c$)
	Local ret:TGadTemplate = TGadTemplate(MapValueForKey(maanclasses,c))
	If Not ret 
		If MapContains(maanclasses,c)  
			GALE_Error "Illegal data on class "+c
		Else
			GALE_Error "Class "+c+" does not exist"
		EndIf
	EndIf	
	Return ret
End Function

Type gadwindow Extends tgadtemplate
	Method CreateMe(G:TMaanGadget)
		Local caption$ = g.data.value("caption") If Not caption caption="Maan:> "+g.form+"."+g.id
		Local parent:TGadget
		Local rflags$[] = g.data.value("flags").split(" ")
		Local flags
		For Local fl$=EachIn rflags
			Select Upper(fl)
				Case ""
				Case "CENTER" flags:| WINDOW_CENTER
				Case "CLIENT" flags:| WINDOW_CLIENTCOORDS
				Case "TITLE"  flags:| WINDOW_TITLEBAR
				Default       GALE_Error "Unknown window flag: "+fl
			End Select
		Next
		If g.parent<>"SYS_DESKTOP" parent=ByName(g.parent).gadget		
		g.gadget = CreateWindow(caption,g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent,flags)
		CSay "Window created "+G.id+" parent: "+g.parent+" "+Int(parent<>Null)+"    "+GadgetWidth(g.gadget)+"x"+GadgetHeight(g.gadget)
	End Method		
End Type
MapInsert maanclasses,"Window",New gadwindow
MapInsert maanclasses,"Win",MapValueForKey(maanclasses,"Window")	




Type tgadLabel Extends tgadtemplate
	Method Createme(G:TMaanGadget)
		'GALE_Error "Well this cannot be done yet, but I will be able to create labels later :)"
		Local caption$ = g.data.value("caption") If Not caption caption="Maan:> "+g.form+"."+g.id
		Local parent:TGadget = ByName(g.parent).gadget
		Local rflags$[] = g.data.value("flags").split(" ")
		Local flags
		For Local fl$=EachIn rflags
			Select Upper(fl)
				Case ""
				Case "FRAME"	flags:|LABEL_FRAME
				Case "SUNKEN"	flags:|LABEL_SUNKENFRAME
				Case "SEPARATOR","HLINE"
						flags:|LABEL_SEPARATOR
				Case "LEFT"	flags:|LABEL_LEFT
				Case "CENTER"	flags:|LABEL_CENTER
				Case "RIGHT"	flags:|LABEL_RIGHT
				Default		GALE_Error "Unknown label flag: "+fl
			End Select
		Next
		g.gadget = CreateLabel(caption,g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent,flags)	
	End Method
End Type	



MapInsert maanclasses,"Label",New tgadlabel



Type tgadbutton Extends tgadtemplate
	Method Createme(G:TMaanGadget)
		'GALE_Error "Well this cannot be done yet, but I will be able to create labels later :)"
		Local caption$ = g.data.value("caption") If Not caption caption="Maan:> "+g.form+"."+g.id
		Local parent:TGadget = ByName(g.parent).gadget
		'Local rflags$[] = g.data.value("flags").split(" ")
		Local flags
		Select g.gc
			Case "PushButton","Button"	flags = BUTTON_PUSH	
			Case "CheckBox","Checkbox"	flags = BUTTON_CHECKBOX	
			Case "Radio" 			flags = BUTTON_RADIO
			Case "OkButton"			flags = BUTTON_OK
			Case "CancelButton"		flags = BUTTON_CANCEL
		EndSelect			
		Rem	
		For Local fl$=EachIn rflags
			Select Upper(fl)
				Case ""
				Default		GALE_Error "Unknown button flag: "+fl
			End Select			
		Next
		End Rem
		g.gadget = CreateButton(caption,g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent,flags)	
		SetButtonState g.gadget,g.data.value("state").tolower()="checked"
	End Method
End Type	

MapInsert Maanclasses,"Button",New tgadbutton
MapInsert maanclasses,"PushButton",MapValueForKey(maanclasses,"Button")
MapInsert maanclasses,"CheckBox",MapValueForKey(maanclasses,"Button")
MapInsert maanclasses,"Checkbox",MapValueForKey(maanclasses,"Button")
MapInsert maanclasses,"Radio",MapValueForKey(maanclasses,"Button")
MapInsert maanclasses,"OkButton",MapValueForKey(maanclasses,"Button")
MapInsert maanclasses,"CancelButton",MapValueForKey(maanclasses,"Button")

Type tgadgetpanel Extends tgadtemplate
	Method createme(G:TMaanGadget)
		Local style
		Select G.GC
			Case "Frame"
				style = panel_group
			Case "RFrame"
				style = Panel_raised
			Case "SFrame"
				style = panel_sunken
			Default
				style = 0
		End Select
		Local parent:TGadget = ByName(g.parent).gadget
		G.gadget = CreatePanel(g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent,style,g.data.value("caption"))
	End Method
End Type

MapInsert MaanClasses,"Frame", New tgadgetpanel
MapInsert maanclasses,"RFrame",MapValueForKey(maanclasses,"Frame")
MapInsert maanclasses,"SFrame",MapValueForKey(maanclasses,"Frame")
MapInsert maanclasses,"Panel" ,MapValueForKey(maanclasses,"Frame")

Type tgadgettextfield Extends tgadtemplate
	Method createme(G:TMaanGadget)
		Local parent:TGadget = ByName(g.parent).gadget
		Local flag; If G.data.value("password") flag=textfield_password
		G.gadget = CreateTextField(g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent)
		If g.data.value("caption") SetGadgetText g.gadget,g.data.value("caption")
		If g.data.value("default") SetGadgetText g.gadget,g.data.value("default")
		If g.data.value("default") And g.data.value("caption") CSay "WARNING! Both caption and default set for textfield "+G.id+"! 'default' is dominant"
	End Method		
End Type
MapInsert maanclasses,"TextField",New tgadgettextfield


Type tgadlistbox Extends tgadtemplate
	Method action(id$)
		Local g:TMaangadget = ByName(id)
		g.call "SelectDouble",id,SelectedGadgetItem(g.gadget)
	End Method
	Method selectg(id$)	
		Local g:TMaangadget = ByName(id)
		g.call "SelectSingle",id,SelectedGadgetItem(g.gadget)
	End Method
	Method createme(G:TMaanGadget)
		Local parent:TGadget = ByName(g.parent).gadget
		'Local flag; If G.data.value("password") flag=textfield_passwor
		G.gadget = CreateListBox(g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent)
	EndMethod
End Type
MapInsert maanclasses,"ListBox",New tgadlistbox

Type tgadtabber Extends TGadTemplate
	Method action(id$)
		Local i
		Local g:TMaanGadget = ByName(ID)
		Local sg:TMaanGadget
		For i=0 Until CountGadgetItems(	g.gadget)
			sg = byname("TAB_"+id+"__TAB#"+i)
			If Not sg GALE_Error "No access to: "+"TAB_"+id+"__TAB#"+i
			sg.gadget.setshow i=SelectedGadgetItem(g.gadget)
			'CSay "Setshow: "+g.id+" "+Int(i=SelectedGadgetItem(g.gadget))
		Next
	End Method
	Method selectg(id$)
		action id 
	End Method	
	Method createme(G:TMaanGadget)
		Local parent:TGadget = ByName(g.parent).gadget
		'Local flag; If G.data.value("password") flag=textfield_passwor
		G.gadget = CreateTabber(g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent)
	End Method	
	
End Type
MapInsert maanclasses,"Tabber",New tgadtabber

Type tgadtab Extends TGadtemplate
	Method createme(G:TMaanGadget)
		Local P:TMaangadget = byname(G.parent)
		g.gadget = CreatePanel(0,0,ClientWidth(P.gadget),ClientHeight(P.gadget),P.gadget)
		AddGadgetItem P.Gadget,g.data.value("caption")
		CSay " = Added tab ~q"+g.data.value("caption")+" to tabber: "+P.id
		CSay " = Visibility update for : "+g.parent
		tgadtabber(MapValueForKey(maanclasses,"Tabber")).action g.parent
	End Method
End Type
MapInsert maanclasses,"Tab",New tgadtab
