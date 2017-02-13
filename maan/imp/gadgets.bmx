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
Version: 17.02.13
End Rem
' This file MUST be called by "include" and not by "import" as it needs some backwards call which can not be made through import.

MKL_Version "Maan - gadgets.bmx","17.02.13"
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
	
	Method Close(id$)
		byname(id).call "Close",id
	End Method
	
	Method CreateMe(g:tmaanGadget) Abstract
	
	Method ColorMe(G:tmaangadget)
		'Local r,g,b
		Local sr$=G.data.value("r")
		Local sg$=g.data.value("g")
		Local sb$=g.data.value("b")
		If (sr And sg And sb) SetGadgetColor g.gadget,sr.toint(),sg.toint(),sb.toint(),False
		sr$=G.data.value("br")
		sg$=g.data.value("bg")
		sb$=g.data.value("bb")
		If (sr And sg And sb) SetGadgetColor g.gadget,sr.toint(),sg.toint(),sb.toint(),True
	End Method
		

End Type

Function GetTemplate:TGadTemplate(c$)
	Local ret:TGadTemplate = TGadTemplate(MapValueForKey(maanclasses,c))
	If Not ret GALE_Error "Class "+c+" does not exist"
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
		Local rflags$[] = g.data.value("flags").split(" ")
		Local flags
		For Local fl$=EachIn rflags
			Select Upper(fl)
				Case ""
				Default		GALE_Error "Unknown button flag: "+fl
			End Select
		Next
		g.gadget = CreateButton(caption,g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent,flags)	
	End Method
End Type	

MapInsert Maanclasses,"Button",New tgadbutton


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
		G.gadget = CreatePanel(g.tx("x"),g.ty("y"),g.tx("width"),g.ty("height"),parent)
		If g.data.data.value("caption") SetGadgetText g.gadget,g.data.data.value("caption")
		If g.data.data.value("default") SetGadgetText g.gadget,g.data.data.value("default")
		If g.data.data.value("default") And g.data.data.value("caption") CSay "WARNING! Both caption and default set for textfield "+G.id+"! 'default' is dominant"
	End Method		
End Type
MapInsert maanclasses,"TextField",New tgadgettextfield
