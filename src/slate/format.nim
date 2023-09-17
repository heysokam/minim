#:______________________________________________________
#  *slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
import std/strutils
func firstUpper *(s :string) :string=  result = s; result[0] = result[0].toUpperAscii()
  ## Returns the string with its first character converted to Uppercase
