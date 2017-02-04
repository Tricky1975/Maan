Strict
Import "bmp_template.bmx"


Private

Type bmp_version Extends bmp_Template
	Method Work()
		Print MKL_GetAllversions()
		End
	End Method
End Type


bmp_register "versions",New bmp_version,"Show the versions of all used source codes"	
