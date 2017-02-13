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
Version: 17.02.13
End Rem
Strict

Import "globals.bmx"

MKL_Version "Maan - lua.bmx","17.02.13"
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
		Return byname(n)
	End Method
	
	Method STEXT(n$,t$)
		SetGadgetText byname(n).gadget,t
	End Method

End Type


GALE_Register New MaanLuaAPI,"MAAN"
