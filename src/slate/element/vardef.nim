#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
# nimc dependencies
import ../nimc
import ./base
import ./error

# Elements
type Elem *{.pure.}= enum Name, Type, Value
converter toInt *(d :Elem) :int= d.ord

#_________________________________________________
# General
#_____________________________
func isPrivate *(code :PNode; indent :int) :bool=
  assert code.kind in [nkConstDef, nkIdentDefs]
  if indent > 0: return true
  let sym = code[Elem.Name]
  assert sym.kind in {nkIdent,nkPostfix}
  return base.isPrivate(sym, indent, VarDefError)
#_____________________________
func getName *(code :PNode) :string=
  assert code.kind in [nkConstDef, nkIdentDefs]
  let sym = code[Elem.Name]
  assert sym.kind in {nkIdent,nkPostfix}
  case sym.kind
  of nkIdent   : result = sym.strValue
  of nkPostfix : result = sym[1].strValue
  else: raise newException(VarDefError, &"Tried to get the name of a variable, but its symbol has an unknown format.\n  {sym.kind}\n")
#_____________________________
func getType *(code :PNode) :string=
  assert code.kind in [nkConstDef, nkIdentDefs]
  code[Elem.Type].strValue
#_____________________________
func getValue *(code :PNode) :string=
  assert code.kind in [nkConstDef, nkIdentDefs]
  code[Elem.Value].strValue

