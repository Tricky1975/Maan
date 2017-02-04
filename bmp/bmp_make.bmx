Rem
	bmp - Make
	This will actually build the entire maan application.
	
	
	
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
Import "bmp_template.bmx"
MKL_Version "Maan - bmp_make.bmx","17.02.04"
MKL_Lic     "Maan - bmp_make.bmx","GNU General Public License 3"

Private


Function Make()
End Function





' link it all to the main program

Type bmp_make Extends bmp_template
	Method Work()
		Make
		End
	End Method
End Type


bmp_register "make",New bmp_make,"Make the full Maan application and turn it into an functional program"	

