#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# Base module used by all of the *Slate elements  |
#_________________________________________________|
import ../nimc

func isPrivate *(sym :PNode; indent :int; err :typedesc[CatchableError]) :bool=
  if indent > 0: return false
  assert sym.kind in {nkIdent,nkPostfix}
  case sym.kind
  of nkIdent   : result = true
  of nkPostfix : result = sym[0].strValue != "*"
  else: raise newException(err, &"Tried to get find if symbol is private, but it has an unknown format.\n  {sym.kind}\n")

