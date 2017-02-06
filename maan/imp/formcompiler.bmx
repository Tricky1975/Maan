Strict
Import "globals.bmx"

MKL_Version "Maan - console.bmx","17.02.04"
MKL_Lic     "Maan - console.bmx","GNU General Public License 3"







Function CreateAllGadgets()
	' Creates all gadgets but only if they do not exist yet.
	For Local MG:TmaanGadget = EachIn gadorder
		If Not MG.Gadget mg.createme; CSay " = Created gadget: "+mg.id; MapInsert gadbygad,mg.gadget,mg
	Next
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
			If pis>-1 Then
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
				If MapContains(gadbyname,currentgadid) GALE_Error "Duplicate naming in line #"+cl
				MapInsert gadbyname,currentgadid,w
				CSay " = Created data record "+Lower(c)+" "+v+" as "+currentgadid
			Else
				Select line
					Case "kids","children"
						curparent=currentgadid
					Case "end","endkids","endchildren"
						If curparent="SYS_DESKTOP" GALE_Error "No kids group to end in line #"+cl
						Local p$ = curparent
						curparent = byname(p).parent
					Default
						GALE_Error "I don't understand line #"+cl
				End Select
			EndIf
		EndIf
	Next
	' And now put this all into "reality"
	CreateAllGadgets
	Local savedvar$
	Local s:TLua = GALE_LoadScript(jcr,"Forms/"+form+".lua",savedvar,priorscript)
	If Not s GALE_Error "Sorry, compilation failed!"
	GALE_AddScript "FORM_"+form,s
End Function
