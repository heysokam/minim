# std dependencies
import std/macros

# Elements
type ProcDef *{.pure.}= enum Symbol, Unused1, Generic, Params, Pragma, Reserved1, Statements
converter toInt *(d :ProcDef) :int= d.ord

# Generator
func getName *(node :NimNode) :string=
  assert node.kind == nnkProcDef and node[ProcDef.Symbol].kind == nnkSym
  node[ProcDef.Symbol].strVal

func getRetT *(node :NimNode) :string=
  assert node.kind == nnkProcDef and node[ProcDef.Params].kind == nnkFormalParams and node[ProcDef.Params][0].kind == nnkSym
  node[ProcDef.Params][0].strVal  # First parameter is always its return type

func getArgCount *(node :NimNode) :int=
  assert node.kind == nnkProcDef and node[ProcDef.Params].kind == nnkFormalParams
  for id,child in node[ProcDef.Params].pairs:
    if id == 0: continue  # First parameter is always its return type
    result.inc

iterator args *(node :NimNode) :tuple[first:bool, last:bool, node:NimNode]=
  ## Iterates over the Arguments of a ProcDef node, and yields them one by one
  assert node.kind == nnkProcDef and node[ProcDef.Params].kind == nnkFormalParams
  let argc = node.getArgCount()
  for id in 0..<argc:
    assert node[ProcDef.Params][id+1].kind == nnkIdentDefs
    yield (first : id == 0,
           last  : id == argc-1,
           node  : node[ProcDef.Params][id+1] )

func getArgT *(node :NimNode) :string=
  assert node.kind == nnkIdentDefs
  ""
func getArgName *(node :NimNode) :string=
  assert node.kind == nnkIdentDefs
  ""
