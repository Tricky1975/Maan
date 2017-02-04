Strict

Import brl.map

	Type bmp_template
		Method Work() Abstract
		Field Explain$		
	End Type


Private
	Global act:TMap = New TMap
	
Public


	Function bmp_register(name$,t:bmp_template)
		MapInsert act,name,t
	End Function
	
	Function bmp_get:bmp_template(name$)
		Return bmp_template(MapValueForKey(act,name))
	End Function
	
	Function bmp_work(n$)
		bmp_get(n).work
	End Function
	
	Function bmp_explain()
		Local k$
		For k=EachIn(MapKeys(act))
			Print Left("   "+k+"                  ",20)+" -- "+bmp_get(k).explain
		Next
	End Function

	
