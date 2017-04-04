--[[
***********************************************************
button.lua
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
Version 17.02.13
]]
function GALE_OnLoad()
   CSay("You I'm here")
end

function KID_BUTTON_Button_Action(key)
   times = (times or 0) + 1
   MAAN_Text("FORM_Button","Button Test - Button hit: "..times)
   alert("Hey, you hit me!")
end

function FORM_Button_Close(key)
   alert("Oh, you wanna quit. See ya later")
   os.exit()
end
