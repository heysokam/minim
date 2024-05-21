#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# TODO : Auto translate C to MinC/Nim
#      : https://github.com/PMunch/futhark/blob/master/src/opir.nim#L425
# idea : Convert clang.CXCursor to PNodes directly
#      : clang bindings
# remember: Alternative to libclang
# https://github.com/RealNeGate/Cuik/tree/master/libCuik
#:______________________________________________________
# @deps std
import std/json as Json
from std/osproc import nil
from std/sets import incl, HashSet, items
# @deps ndk
import nstd/strings
import nstd/types

#_______________________________________
# @section Types
#_____________________________
type NodeKind {.pure.}= enum
  None, Implicit,
  TranslationUnitDecl, TypedefDecl, FunctionDecl,
  CompoundStmt, ReturnStmt, IfStmt,
  IntegerLiteral,
  BinaryOperator,
  CallExpr, ImplicitCastExpr, DeclRefExpr,
  FullComment, ParagraphComment, TextComment,
  BuiltinType, RecordType, PointerType, ConstantArrayType, QualType
#___________________
type Base {.inheritable.}= object
  name :str
  qual :str
#___________________
type Func = object of Base
#___________________
type TypeKind = enum Char, Int, Uint, Float, Double, Size
type Type = object of Base
  kind   :TypeKind
  isPtr  :bool
#___________________
type Node {.acyclic.}= object
  case kind :NodeKind
  of Implicit:
    implicitName :str
  of TranslationUnitDecl: discard
  #___________________
  of TypedefDecl:
    # TODO: Original type and target type?
    # TODO: Struct/Union/Enum fields?
    name_t  :str
    typ_t   :Type
  #___________________
  of FunctionDecl:
    qual_f  :str
    name_f  :str
    typ_f   :Type
    isDecl  :bool
  #___________________
  of IntegerLiteral:
    value   :str
    qual_i  :str
  #___________________
  of IfStmt: discard  # TODO
  #___________________
  of CallExpr: discard  # TODO
  #___________________
  of ImplicitCastExpr:  # TODO
    castKind  :Type
  #___________________
  of DeclRefExpr: discard  # TODO
  #___________________
  of BinaryOperator:  # TODO
    name_op  :str
  #___________________
  of FullComment:  # TODO
    comment  :str
  #___________________
  else: discard
  #___________________
  depth  :u32
  inner  :seq[Node]


#_______________________________________
# @section Helpers
#_____________________________
proc sh (cmd :str) :str {.discardable.}= osproc.execProcess(cmd)
const echo = debugEcho

#_______________________________________
# @section Error Management
#_____________________________
type CodegenError = object of CatchableError
proc err (msg :str) :void= raise newException(CodegenError, msg)
func wrn (msg :varargs[str, `$`]) :void= echo "WARNING: ", msg.join(" ")
#_______________________________________
proc report (json :JsonNode)= echo json.pretty
#_____________________________
const KnownKeys = [
  # Used
  "kind",            # AST node kind
  "inner",           # Node leaves/children
  "type",            # Type Information for the node
  "name",            # Name of the symbol/node
  "value",           # Value of the variable/literal
  "referencedDecl",  # Given when accessing symbols that were previously declared
  "castKind",        # Kind that an ImplicitCastExpr is casting to
  "opcode",          # Operator that a BinaryOperator is using as its symbol
  "text",            # Text contents of a doc-comment
  # Filtered
  "loc",             # loc == location in the file : Position(offs,file,line,col,tokLen)
  "range",           # range == range( begin:Position, end:Position ) in the file : Position(offs,file,line,col,tokLen)
  "id",              # HEX id of the node
  "isUsed",          # For symbols that are used elsewhere in the file
  "previousDecl",    # For tracking symbols that were previously declared
  "mangledName",     # Only relevant for C++
  # Unknown purpose
  "valueCategory",  # prvalue
  ] # << KnownKeys = [ ... ]
#_____________________________
func check (json :JsonNode; known :openArray[str]) :void=
  for key,val in json.pairs:
    if key notin KnownKeys:
      report json
      echo key, " : ", val
      err "Found an unmapped Node key:  "&key
    elif key == "kind":
      block KindCheck:
        for kind in NodeKind:
          if $kind == val.getStr: break KindCheck
        err "Found an unmapped NodeKind value:  "&val.getStr


#_______________________________________
# @section Types: Field Access ergonomics
#_____________________________
func `name=` *(node :var Node; val :str) :void=
  case node.kind
  of TypedefDecl    : node.name_t = val
  of FunctionDecl   : node.name_f = val
  of BinaryOperator : node.name_op = val
  else: discard
  # of TranslationUnitDecl, IntegerLiteral, IfStmt, ImplicitCastExpr, FullComment: ""
  # of CallExpr       : "call-TODO"
  # else: "other-TODO"
#_______________________________________
func name *(node :Node) :str=
  case node.kind
  of TypedefDecl    : node.name_t
  of FunctionDecl   : node.name_f
  of BinaryOperator : $node.kind & "-TODO" # node.name_op
  of CallExpr       : $node.kind & "-TODO" # ????
  of Implicit       : node.implicitName
  else: $node.kind & "-TODO"
#_____________________________
func `typ=` *(node :var Node; val :Type) :void=
  case node.kind
  of TypedefDecl  : node.typ_t = val
  of FunctionDecl : node.typ_f  = val
  else: err &"Tried to assign the type of a Node that doesn't have one:  {node.kind}"
#_______________________________________
func typ *(node :Node) :Type=
  case node.kind
  of TypedefDecl  : result = node.typ_t
  of FunctionDecl : result = node.typ_f
  else: err &"Tried to get the type of a Node that doesn't have one:  {node.kind}"
#_____________________________
func `qual=` *(node :var Node; val :str) :void=
  case node.kind
  of FunctionDecl : node.qual_f = val
  else: err &"Tried to assign the qualifier of a Node that doesn't have one:  {node.kind}"
#_______________________________________
func qual *(node :Node) :str=
  case node.kind
  of FunctionDecl : result = node.qual_f
  else: err &"Tried to get the qualifier of a Node that doesn't have one:  {node.kind}"


#_______________________________________
# @section Generic Json AST tools
#_____________________________
proc getJson (file :str) :str=
  let tmp = sh "clang -Xclang -ast-dump=json -c " & file
  for line in tmp.splitLines:
    if line.startsWith("}"): result.add "}\n"; break
    result.add line&"\n"


#_______________________________________
# @section Object Fields
#_____________________________
func hasInner *(json :JsonNode) :bool= json.hasKey("inner")
#___________________
func get (val :str; _:typedesc[NodeKind]) :NodeKind=
  for kind in NodeKind:
    if $kind == val: return kind
  err "Found an unmapped NodeKind value:  "&val
#___________________
func get (json :JsonNode; _:typedesc[NodeKind]) :NodeKind=
  if json.isImplicit: return Implicit
  json["kind"].getStr.get(NodeKind)
#___________________
func isImplicit (json :JsonNode) :bool= json.hasKey("isImplicit") and json["isImplicit"].getBool == true
func isPtr      (json :JsonNode) :bool= json.get(NodeKind) == TypedefDecl and json.hasInner() and json["inner"][0].get(NodeKind) == PointerType
func isDecl     (json :JsonNode) :bool= json.get(NodeKind) == FunctionDecl and not json.hasInner()
#___________________
func getQual  (json :JsonNode) :str= json["type"]["qualType"].getStr
func getValue (json :JsonNode) :str= json["value"].getStr
func getName  (json :JsonNode) :str= json["name"].getStr
#___________________
const KnownTypes_u32 = ["uint", "uint32_t", "u32"]
const KnownTypes_i32 = ["int", "int *", "int*", "int32_t", "int32_t *", "i32"]
const KnownTypes_f32 = ["float", "f32"]
#___________________
func getTypeKind (typ :str) :TypeKind=
  case typ
  of KnownTypes_i32 : result = TypeKind.Int
  of KnownTypes_u32 : result = TypeKind.Uint
  of KnownTypes_f32 : result = TypeKind.Float
  else:
    let splt = typ.split(" ")
    if splt.len < 1: err &"Found an unmapped TypeKind qualifier:  {typ}"
    result = splt[0].getTypeKind()  # TODO: Proper function signature pattern matching
#___________________
func getType  (json :JsonNode) :Type=
  result = Type(
    name  : json.getName(),
    qual  : json.getQual(),
    kind  : json.getQual.getTypeKind(),
    isPtr : json.isPtr(),
    ) # << Type( ... )



#_______________________________________
# @section Simplified AST tools
#_____________________________
func getFunction (node :var Node; json :JsonNode) :void=
  node.name   = json.getName
  node.qual   = json.getQual
  node.typ    = json.getType
  node.isDecl = json.isDecl
#___________________
func getInteger (node :var Node; json :JsonNode) :void=
  node.value = json.getValue
#___________________
func getTypedef (node :var Node; json :JsonNode) :void=
  node.name = json.getName
  node.typ  = json.getType
#___________________
func addInfo (node :var Node; json :JsonNode) :void=
  case node.kind
  of FunctionDecl   : node.getFunction(json)
  of IntegerLiteral : node.getInteger(json)
  of TypedefDecl    : node.getTypedef(json)
  # of CompoundStmt:
  #   echo json.pretty
  else: discard
#___________________
proc simplify (json :JsonNode; depth :SomeInteger= 0) :Node=
  result = Node(kind: json.get(NodeKind))
  if json.isImplicit:
    result.implicitName = json.getName
    return
  result.depth = depth.u32
  result.addInfo(json)
  if json.hasInner:
    for entry in json["inner"]:
      result.inner.add entry.simplify(result.depth+1)
  json.check(KnownKeys)
#___________________
func `*` *(val :str; N :SomeInteger) :str=
  for id in 0..<N: result.add val
#___________________
const Sep {.strdefine.}= " ."
func `$` *(node :Node) :str=
  let sep = Sep*node.depth
  if node.depth > 0: result.add sep & " "
  if node.kind notin {TranslationUnitDecl, Implicit}: result.add node.name & "\n"
  case node.kind
  of FunctionDecl:
    result.add &"{sep}   qual : {node.qual}\n"
    result.add &"{sep}   name : {node.name}\n"
    result.add &"{sep}   type : {node.typ}\n"
    result.add &"{sep}   decl : {node.isDecl}\n"
  of TypedefDecl:
    result.add &"{sep}   name : {node.name}\n"
    result.add &"{sep}   type : {node.typ}\n"
  #___________________
  else:discard
  for child in node.inner: result.add $child

#_______________________________________
# @section Entry Point
#_____________________________
const testFile = "./test.c"
when isMainModule:
  let json = testFile.getJson.parseJson
  echo "_______________________________________"
  # echo json.pretty
  echo json.simplify()

