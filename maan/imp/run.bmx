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
Version: 17.02.16
End Rem
Strict
Import "globals.bmx"

MKL_Version "Maan - run.bmx","17.02.16"
MKL_Lic     "Maan - run.bmx","GNU General Public License 3"



Private
	Global EID,ESource:TGadget


Public
	Function Run()
		Local srcgad:Tmaangadget
		Local srctmp:tgadtemplate
		Local check:Byte=1
		'PollEvent
		CSay "Init done... Everything will now be run"
		Repeat
			PollEvent
			eid = EventID()
			Local es:Object = EventSource()
			ESource = TGadget(es)
			If eid=event_windowclose And esource=GALE_ExitGadget 
				DebugLog "DEBUG WINDOW CLOSE!"
				End
			EndIf	
			'If Not esource 
			check=1
			'If eid DebugLog "Event: "+eid+" Start Check:"+check
			check=check And esource<>Null
			'If eid DebugLog "sourcecheck:"+check+" on event: "+eid
			If check srcgad = bygad(esource); check=check And srcgad 
			'If eid DebugLog "gadcheck:"+check
			If check srctmp = gettemplate(srcgad.gc); check = check And srctmp
			'If eid DebugLog "templatecheck:"+check
			If check
				Select eid
					Case event_gadgetaction
						DebugLog "Action Event"
						srctmp.action  bygad(esource).id
					Case event_gadgetselect
						DebugLog "Select Event"
						'If esource CSay "We got a source "+bygad(esource).id									 	
						Local g:tmaangadget = bygad(esource)
						If g	
							If Not MapContains(MaanClasses,g.gc)
								CSay "WARNING! Call to non-existent class "' +g.gc+" in select-event
							Else
								CSay "Existing so let's go!"
								GetTemplate(g.gc).selectg g.id
							EndIf	
						EndIf	
					Case event_windowclose	
						GetTemplate(bygad(esource).gc).close   bygad(esource).id
				End Select
			?debugshit 'If not in use just use an unknown tag as it'll always be false in the preprocessor of BlitzMax
			Else
				'Print "False event created"
				If esource Print "I do have a source"
				If eid=event_gadgetaction Print "I got an action"
				If srcgad Print "I have a gadget "+srcgad.id+" >>> "+srcgad.gc
				If srctmp Print "And I do have a template"
			?
			EndIf	
		Forever
	End Function
