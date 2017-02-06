Rem
	Maan - Run
	Runs the process
	
	
	
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
Import "globals.bmx"

MKL_Version "Maan - run.bmx","17.02.07"
MKL_Lic     "Maan - run.bmx","GNU General Public License 3"



Private
	Global EID,ESource:TGadget


Public
	Function Run()
		Repeat
			PollEvent
			eid = EventID()
			ESource = TGadget(EventSource())
			If eid=event_windowclose And esource=GALE_ExitGadget End
			Select eid
				Case event_gadgetaction
					GetTemplate(bygad(esource).gc).action bygad(esource).id
				Case event_windowclose	
					GetTemplate(bygad(esource).gc).close bygad(esource).id
			End Select
		Forever
	End Function
