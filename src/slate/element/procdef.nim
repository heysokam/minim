# nimc dependencies
import ../nimc

# Elements
type ProcDef *{.pure.}= enum Symbol, Unused1, Generic, Params, Pragma, Reserved1, Statements
converter toInt *(d :ProcDef) :int= d.ord

# Generator
func getName *(node :PNode) :string=
  assert node.kind == nkProcDef and node[ProcDef.Symbol].kind == nkSym
  node[ProcDef.Symbol].strVal

func getRetT *(node :PNode) :string=
  assert node.kind == nkProcDef and node[ProcDef.Params].kind == nkFormalParams and node[ProcDef.Params][0].kind == nkSym
  node[ProcDef.Params][0].strVal  # First parameter is always its return type

func getArgCount *(node :PNode) :int=
  assert node.kind == nkProcDef and node[ProcDef.Params].kind == nkFormalParams
  for id,child in node[ProcDef.Params].pairs:
    if id == 0: continue  # First parameter is always its return type
    result.inc

iterator args *(node :PNode) :tuple[first:bool, last:bool, node:PNode]=
  ## Iterates over the Arguments of a ProcDef node, and yields them one by one
  assert node.kind == nkProcDef and node[ProcDef.Params].kind == nkFormalParams
  let argc = node.getArgCount()
  for id in 0..<argc:
    assert node[ProcDef.Params][id+1].kind == nkIdentDefs
    yield (first : id == 0,
           last  : id == argc-1,
           node  : node[ProcDef.Params][id+1] )

func getArgT *(node :PNode) :string=
  assert node.kind == nkIdentDefs
  ""
func getArgName *(node :PNode) :string=
  assert node.kind == nkIdentDefs
  ""
