--[[
***********************************************************
main.lua
This particular file has been released in the public domain
and is therefore free of any restriction. You are allowed
to credit me as the original author, but this is not 
required.
This file was setup/modified in: 
2017
If the law of your country does not support the concept
of a product being released in the public domain, while
the original author is still alive, or if his death was
not longer than 70 years ago, you can deem this file
"(c) Jeroen Broks - licensed under the CC0 License",
with basically comes down to the same lack of
restriction the public domain offers. (YAY!)
*********************************************************** 
Version 17.02.14
]]
colors = { red = { r=255,g=0,b=0}, blue={0,0,255}, green={0,255,0}, yellow={255,255,0}, magenta={255,0,255}, cyan={0,255,255}, white={255,255,255}, black={0,0,0} }

clab=""
for k,_ in pairs(colors) do
    if #clab>0 then clab=clab.."\n" end
    clab=clab..k
end
MAAN_Text("KID_LABEL_Colors",clab)

function d(t,r,g,b)
   CSay(t.." >> "..(r or 'nil')..","..(g or 'nil')..","..(b or 'nil'))
end

function col(f,tag)
   local t = MAAN_Text(tag)
   local c=colors[t]
   if c then
      d('KID_LABEL_Colors',c.r or c[1],c.g or c[2],c.b or c[3])
      f('KID_LABEL_Colors',c.r or c[1],c.g or c[2],c.b or c[3])
      f('KID_PANEL_Main',c.r or c[1],c.g or c[2],c.b or c[3])
      CSay("Color: "..t)
      -- CSay(serialize("colors.data",debugdata("KID_LABEL_Colors"))) -- Debug in BlitzMax Maan
   end
end

function KID_TEXTFIELD_Voor_Action(idx)
   local f = MAAN_Foreground
   col(f,'KID_TEXTFIELD_Voor')
end

function KID_TEXTFIELD_Achter_Action(idx)
   local f = MAAN_Background
   col(f,'KID_TEXTFIELD_Achter')
end


