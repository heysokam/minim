#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
# nimc dependencies
import ../nimc
# Element dependencies
import ./base
import ./error

# Elements
type Elem *{.pure.}= enum Symbol, Unused1, Generic, Args #[nkFormalParams]#, Pragma, Reserved1, Body #[nkStatements]#
converter toInt *(d :Elem) :int= d.ord

#_________________________________________________
# General
#_____________________________
func getName *(code :PNode) :string=
  assert code.kind == nkProcDef
  let sym = code[Elem.Symbol]
  assert sym.kind in {nkIdent,nkPostfix}
  case sym.kind
  of nkIdent   : result = sym.strValue
  of nkPostfix : result = sym[1].strValue
  else: raise newException(ProcDefError, &"Tried to get the name of a proc, but its symbol has an unknown format.\n  {sym.kind}\n")
#_____________________________
func getRetT *(code :PNode) :string=
  assert code.kind == nkProcDef
  let params = code[Elem.Args]
  assert params.kind == nkFormalParams and params[0].kind == nkIdent
  params[0].strValue  # First parameter is always its return type
#_____________________________
func isPrivate *(code :PNode; indent :int= 0) :bool=
  assert code.kind == nkProcDef
  if indent > 0: return true # All inner procs are private
  result = base.isPrivate(code[Elem.Symbol], indent, ProcDefError)

#_________________________________________________
# Arguments
#_____________________________
func getArgCount *(code :PNode) :int=
  assert code.kind == nkProcDef
  let params = code[Elem.Args]
  assert params.kind == nkFormalParams
  for id,child in params.pairs:
    if id == 0: continue  # First parameter is always its return type
    result.inc
#_____________________________
iterator args *(code :PNode) :tuple[first:bool, last:bool, node:PNode]=
  ## Iterates over the Arguments of a ProcDef node, and yields them one by one
  assert code.kind == nkProcDef
  let params = code[Elem.Args]
  assert params.kind == nkFormalParams
  let argc = code.getArgCount()
  for id in 0..<argc:
    assert params[id+1].kind == nkIdentDefs
    if params[id+1].sons.len > 3: raise newException(ProcDefError, &"Declaring ProcDef arguments grouped by type is currently not supported. The argument's code is:\n{params[id+1].renderTree}\n")
    yield (first : id == 0,
           last  : id == argc-1,
           node  : params[id+1] )
#_____________________________
proc getArgT *(code :PNode) :string=
  assert code.kind == nkIdentDefs
  if code[1].kind == nkEmpty: raise newException(ProcDefError, &"Declaring ProcDef arguments without type is currently not supported. The argument's code is:\n{code.renderTree}\n")
  assert code[1].kind == nkIdent
  code[1].strValue() # Second entry is always the argument type
#_____________________________
func getArgName *(code :PNode) :string=
  assert code.kind == nkIdentDefs and code[0].kind == nkIdent
  code[0].strValue() # First entry is always the argument name

