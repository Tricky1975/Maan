function GALE_OnLoad()
   CSay("You I'm here")
end

function KID_BUTTON_Button_Action(key)
   alert("Hey, you hit me!")
end

function FORM_Button_Close(key)
   alert("Oh, you wanna quit. See ya later")
   os.exit()
end
