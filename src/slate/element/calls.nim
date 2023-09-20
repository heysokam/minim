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
type Elem *{.pure.}= enum Symbol, Arg1
converter toInt *(d :Elem) :int= d.ord

#_________________________________________________
# Function Calls
#_____________________________
func getName *(code :PNode; indent :int= 0) :string=
  assert code.kind in [nkCall, nkCommand]
  code[Elem.Symbol].strValue

func getArgCount *(code :PNode) :int=
  assert code.kind in [nkCall, nkCommand]
  if code.sons.len < 2: return 0
  assert code[Elem.Arg1].kind in nkCharLit..nkNilLit
  for id,child in code.pairs:
    if id == 0: continue  # First parameter is always the function name
    result.inc

iterator args *(code :PNode) :tuple[first:bool, last:bool, node:PNode]=
  assert code.kind in [nkCall, nkCommand]
  let argc = code.getArgCount()
  for id in 0..argc:
    if id == Elem.Symbol: continue # First entry is always the function name
    if code[id].kind notin nkCharLit..nkNilLit: raise newException(CallsError, &"Declaring non-literal arguments for function calls is currently not supported. The argument's code is:\n{code[id+1].renderTree}\n")
    yield (first : id == Elem.Arg1,
           last  : id == argc,
           node  : code[id] )

