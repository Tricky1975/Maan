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


function MAAN_Item(gad,i)
	return MAAN.Item(gad,i or -1)
end

-- This one does not support icons. Another function may be able to do that.
function MAAN_Add(gadget,item)
	local g = MAAN.Gadget(gadget)
	if g.gc~="ListBox" and g.gc~="ComboBox" then
	   CSay("Adding to a "..g.gc.." is not allowed, man!")
	   return 
	end -- Safety
	--g.gadget.InsertItem(g.gadget.ItemCount(),item)
	MAAN.IAdd(gadget,item)
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

function MAAN_Patch(file,path,requiresignature)
	MAAN.JCRPatch(file,path,requiresignature)
end

function MAAN_SetPic(gadget,picfile,flags,source)
	local g = MAAN.Gadget(gadget)
	g.Set("pic",picfile)
	g.Set("picsource",source or "*ME*")
	g.Set("picflags",flags)
	g.PictureMe()
end	

MAAN_Input = MAAN.Input

function MAAN_SYS_UserName() return MAAN.UName end

Bye=MAAN.Bye

MAAN_System = MAAN.SysCall; MAAN_SysCall=MAAN.SysCall
MAAN_Exec = MAAN.Exec

MAAN_SaveString = MAAN.SaveStr
MAAN_LoadString = MAAN.LoadStr

function JCR_LoadString(j1,j2,crash)
	local f1,f2
	if j2 then f1=j1 f2=j2
	else f1="*ME*" f2=j2 end
	return MAAN_LoadString(f1,f2,crash)
end

function MAAN_SaveVar(variable,file)
	MAAN_SaveString(serialize('local ret',variable).."\n\nreturn ret",file)
end

function MAAN_LoadVar(file,f2,crash)
	local r = MAAN_LoadString(file,f2,crash) --.."\n\nreturn ret"
	if (not r) or r=='' then 
		CSay("LoadVar("..file..") returned nothing")
		return 
	end
	--[[
	local f,e = pcall(loadstring,r)
	if not f then
		if crash==true or crash==1 then SYS.Error("Compile[MAAN_LoadVar]: "..e) else CSay("ERROR! "..e) end
		return
	end]]
	local success,e = pcall(loadstring(r))
	if not success then
		if crash==true or crash==1 then SYS.Error("Execute[MAAN_LoadVar]: "..e) else CSay("ERROR! "..e) end
		return
	end
	return e
end 

function JCR_LoadVar(f1,f2,crash)
	return MAAN_LoadVar(f1,f2,crash)
end


function MAAN_Enabled(gadget,value)
	local g = MAAN.Gadget(gadget)
	g.gadget.SetEnabled( ( { [true]=1, [false]=0} )[value~=false and value~=nil and value~=0 and value~=""])
end


function IsDir(file)
	return MAAN.FLType(file)==2
end 

function IsFile(file)
	return MAAN.FLType(file)==1
end

function Dirry(file)
	return MAAN.GetDirry(file)
end	

function Confirm(q)
	return Sys.Sure(q)==1
end

--[[ Return true on Yes, false on No and nil on Cancel ]]
function Proceed(q)
	return ({[0]=false,[1]=true})[Sys.Sure(q,1)]
end

function NProceed(q)
	return Sys.Sure(q,1)
end

-- This way you can just safely use os.exit to quit Maan, but the origianl exit still IS available in case you need it.
originalexit = os.exit
os.exit = MAAN.Bye

-- Directory control
function MkDir(dir,recurse)
	return MAAN.MkDir(dir,boolint(recurse))==1
end

function ChDir(dir)
	return MAAN.ChDir(dir)
end

function MAAN_SetVisible(gadget,value)
	local g = MAAN.Gadget(gadget)
	g.gadget.SetShow(boolint(value))
end

function MAAN_Indexes(gadget)
	local succ,fnc = pcall(loadstring(MAAN.IndexedGadgets(gadget)))
	if not succ then 
		CSay("ERROR IN INDEXES GET REQUEST: "..fnc)
		CSay(MAAN.IndexedGadgets(gadget)) -- Debug line
	else
		return fnc
	end
end

function JCR_Dirs(gadget)
	local succ,fnc = pcall(loadstring(MAAN.JCR_Dirs(gadget)))
	if not succ then 
		CSay("ERROR IN DIRLIST GET REQUEST: "..fnc)
		CSay(MAAN.IndexedGadgets(gadget)) -- Debug line
	else
		return fnc
	end
end

function DirList(dir,ftype,unixhidden)
	local uh = boolint(unixhidden)
	local t = ({[1]=1,[2]=2,['file']=1,['dir']=2,f=1,d=2})[ftype] or (function() Say('ERROR! DirList unknonw type -- '..sval(ftype)) return nil end)()
	local succ,res = pcall(loadstring(MAAN.DirList(dir,t,uh)))
	if not succ then
	   CSay("ERROR! Listdir -- Couldn't read: "..dir)
	   return nil
    end
    return res
end

function DirTree(dir,unixhidden)
	local uh = boolint(unixhidden)
	local succ,res = pcall(loadstring(MAAN.Tree(dir,t,uh)))
	if not succ then
	   CSay("ERROR! DirTree -- Couldn't read: "..dir)
	   return nil
    end
    return res
end

function Poll()
   -- Calling this will just poll an event and all the events it gets will be returned into nothingness.
   -- This function can however be used in time consuming operations to make the program still respond to stuff
   -- So the underlying OS won't deem the program crashed or anything.
   -- Changed screen operations can also be updated accordingly this way.
   MAAN.Poll()
end    


function MAAN_Hide(gadget,value) MAAN_SetVisible(gadget,false) end

function MAAN_Show(gadget,value)
	if gadget:sub(1,5)=="FORM_" then
		MAAN.LoadFormIfNeeded(gadget)
	end
	MAAN_SetVisible(gadget,true)
end	

function MAAN_Exist(gadget)
	return MAAN.Exist(gadget)~=0
end

MAAN_AddText = MAAN.AddText

ExtractDir = MAAN.ExDir
ExtractExt = MAAN.ExExt
StripDir   = MAAN.StrDir
StripExt   = MAAN.StrExt
StripAll   = MAAN.StrAll


function JCR_IsFile(f)
	return MAAN.JCR_IsFile(f)>0
end

function RequestFile(caption,filter,default)
    return MAAN.RQF(caption,filter,0,default)
end

function RequestSaveFile(caption,filter,default)
    return MAAN.RQF(caption,filter,0,default)
end

RequestDir = MAAN.RQD
