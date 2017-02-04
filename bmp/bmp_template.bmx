Rem
	Bmp - Template
	
	
	
	
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

Import brl.map
MKL_Version "Maan - bmp_template.bmx","17.02.04"
MKL_Lic     "Maan - bmp_template.bmx","GNU General Public License 3"

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

	
