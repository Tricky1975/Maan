' This file MUST be called by "include" and not by "import" as it needs some backwards call which can not be made through import.

MKL_Version "Maan - console.bmx","17.02.04"
MKL_Lic     "Maan - console.bmx","GNU General Public License 3"


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