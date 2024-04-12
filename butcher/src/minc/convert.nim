#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/paths
# @deps *Slate
import slate/nimc
# @deps minc
import ./convert/core

proc toMinC *(code :string|Path) :string=
  ## @descr Converts a block of Nim code into the Min C Language
  when code is Path: MinC( nimc.readAST(code) ) & "\n"
  else:              MinC( nimc.getAST(code)  ) & "\n"
