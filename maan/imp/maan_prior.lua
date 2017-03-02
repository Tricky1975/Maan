--[[
  maan_prior.lua
  
  version: 17.03.02
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


ByName = MAAN.Gadget -- For use in this file only!

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
		MAAN.gadget(gadget).recaption()
	end
	return MAAN.gadget(gadget).Gadget.GetText()
end

function MAAN_Foreground(gadget,r,g,b)
	local gg=MAAN.Gadget(gadget)
	gg.set('r',r)
	gg.set('g',g)
	gg.set('b',b)
	gg.ColorMe()
end

function MAAN_Background(gadget,r,g,b)
	local gg=MAAN.Gadget(gadget)
	gg.set('br',r)
	gg.set('bg',g)
	gg.set('bb',b)
	gg.ColorMe()
end

function MAAN_ItemText(gadget,item)
	return MAAN.IText(gadget,item or -1)
end

function MAAN_Checked(gadget,value)
     local g = MAAN.Gadget(gadget)
     if value~=nil then g.Gadget.SetSelected(boolint(value)) end
     return hbool(MAAN.State(gadget))
end

function debugdata(gadget) -- Debugging purposes only for this version of MAAN
       local f = loadstring(MAAN.gData(gadget))
       return f()
end
