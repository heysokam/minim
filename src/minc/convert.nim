#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/paths
import nstd/strings
# @deps *Slate
import slate/nimc as nim
# @deps minc
import ./convert/core
import ./types

#_______________________________________
# @section Converter: Entry Point
#_____________________________
proc toMinC_singleFile *(code :string|Path) :string=
  ## @descr Converts a block of Nim code into the MinC lang
  var C :CFilePair
  when code is Path: C = core.MinC( nim.readAST(code) )
  else:              C = core.MinC( nim.getAST(code)  )
  if C.h != "":
    result.add C.h
    result.add "\n"
    result.add "//__________________________________________________________________________________________________\n"
    result.add "//__________________________________________________________________________________________________\n"
  result.add C.c
  result.add "\n"
#_____________________________
# TODO: Multi-File Output
#proc toMinC *(code :seq[string|Path]) :CFilePair=
#proc toMinC *(list :seq[string|Path]) :seq[CFilePair]=
#  for code in list: result.add code.toMinC()


const ProcDef = """
proc `thing` *[T :SomeInteger=1](x :int= 3; y :float32) :int {.pragma1, inline.}= discard
"""
# echo ProcDef.toMinC()

