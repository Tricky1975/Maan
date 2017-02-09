--[[
  maan_prior.lua
  
  version: 17.02.07
  Copyright (C) 2017 Jeroen P. Broks
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
]]
alert = Sys.Alert


function CSay(msg)
    Console.Write(msg,255,255,255)
end

function boolint(a)
    if a then return 1 else return 0 end
end

function hvalue(a)
    if a==nil or a==false or a==0 or a=="" then return false else return a end
end

function hbool(a)
	if hvalue(a) then return true else return false end
end

function MAAN_Text(gadget,txt)
	if txt then
		MAAN.STEXT(gadget,txt)
	end
	return MAAN.gadget(gadget).Gadget.GetText()
end