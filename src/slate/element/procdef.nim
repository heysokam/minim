#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
# nimc dependencies
import ../nimc

# Elements
type Elem *{.pure.}= enum Symbol, Unused1, Generic, Params, Pragma, Reserved1, Statements
converter toInt *(d :Elem) :int= d.ord

# Validation
type ProcDefError = object of CatchableError

#_________________________________________________
# General
#_____________________________
func getName *(node :PNode) :string=
  assert node.kind == nkProcDef
  let sym = node[Elem.Symbol]
  assert sym.kind in {nkIdent,nkPostfix}
  case sym.kind
  of nkIdent   : result = sym.strValue
  of nkPostfix : result = sym[1].strValue
  else: raise newException(ProcDefError, &"Tried to get the name of a proc, but its symbol has an unknown format.\n  {sym.kind}\n")
#_____________________________
func getRetT *(node :PNode) :string=
  assert node.kind == nkProcDef
  let params = node[Elem.Params]
  assert params.kind == nkFormalParams and params[0].kind == nkIdent
  params[0].strValue  # First parameter is always its return type


#_________________________________________________
# Arguments
#_____________________________
func getArgCount *(node :PNode) :int=
  assert node.kind == nkProcDef
  let params = node[Elem.Params]
  assert params.kind == nkFormalParams
  for id,child in params.pairs:
    if id == 0: continue  # First parameter is always its return type
    result.inc
#_____________________________
iterator args *(node :PNode) :tuple[first:bool, last:bool, node:PNode]=
  ## Iterates over the Arguments of a ProcDef node, and yields them one by one
  assert node.kind == nkProcDef
  let params = node[Elem.Params]
  assert params.kind == nkFormalParams
  let argc = node.getArgCount()
  for id in 0..<argc:
    assert params[id+1].kind == nkIdentDefs
    yield (first : id == 0,
           last  : id == argc-1,
           node  : params[id+1] )
#_____________________________
func getArgT *(node :PNode) :string=
  assert node.kind == nkIdentDefs
  ""
#_____________________________
func getArgName *(node :PNode) :string=
  assert node.kind == nkIdentDefs
  ""
