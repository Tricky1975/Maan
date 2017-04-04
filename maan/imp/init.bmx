Rem
	Maan - Init
	Core init stuff
	
	
	
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
Version: 17.02.07
End Rem
Strict
Import "formcompiler.bmx"

MKL_Version "Maan - init.bmx","17.02.07"
MKL_Lic     "Maan - init.bmx","GNU General Public License 3"


Function init()
        CSay "~n~n"+MKL_GetAllversions()+"~n~n"
	GALE_ExitGadget.setshow Project.c("Console").tolower()="show"
	GadgetToMaan Desktop(),"SYS_DESKTOP"
	ByName("SYS_DESKTOP").gc="SYS_DESKTOP"
	For Local f$ = EachIn project.c("StartForm").split(",")
		compileform f
	Next
End Function
