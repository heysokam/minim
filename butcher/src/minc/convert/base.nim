#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# Base module used by all of the minc elements  |
#_______________________________________________|
# @deps *Slate
import slate/nimc

#_______________________________________
# @section Helpers
#___________________
type TODO = object of CatchableError
template todo *(code :PNode) :void=
  raise newException(TODO, &"\nInterpreting {code.kind} is currently not supported for MinC.\n\nIts tree is:\n{code.treeRepr}\nIts code is:\n{code.renderTree}\n\n")

