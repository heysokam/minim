#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/paths
# *Slate dependencies
import slate/nimc
# minc dependencies
import ./convert/core

proc toMinC *(code :string|Path) :string=
  ## Converts a block of Nim code into the Min C Language
  when code is Path: MinC( nimc.readAST(code) ) & "\n"
  else:              MinC( nimc.getAST(code)  ) & "\n"
