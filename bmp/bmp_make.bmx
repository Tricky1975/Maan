Strict
Import "bmp_template.bmx"

Private


Function Make()
End Function





' link it all to the main program

Type bmp_make Extends bmp_template
	Method Work()
		Make
		End
	End Method
End Type


bmp_register "make",New bmp_make,"Make the full Maan application and turn it into an functional program"	

