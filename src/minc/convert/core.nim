

#_______________________________________
# @section Slate Configuration
#_____________________________
# @deps ndk
import nstd/strings
# @deps *Slate
import slate/nimc as nim
import slate/format

#_______________________________________
# @section Slate Configuration
#_____________________________
const cfg_Sep    *{.strdefine.}= "  "
const cfg_Prefix *{.strdefine.}= "*Slate" & cfg_Sep # TODO: Change functions to take 2 formatting parameters


#_______________________________________
# @section Node Access: Error Management
#_____________________________
const echo = debugEcho
const DefaultErrorMsg = "Something went wrong."
#___________________
type NodeAccessError = object of CatchableError
func err *(msg :string; pfx :string= cfg_Prefix) :void= raise newException(NodeAccessError, pfx&msg)
  ## @descr Raises a {@link NodeAccessError} with a formatted {@arg msg}
proc err *(code :PNode; msg :string; pfx :string= cfg_Prefix) :void= err &"\n{code.treeRepr}\n{code.renderTree}\n{pfx}{msg}", pfx=""
  ## @descr Raises a {@link NodeAccessError} with a formatted {@arg msg}, with debugging information about the {@arg code}
#___________________
type Kind *{.pure.}= enum
  None, Empty,
  Proc, Func,
  Var, Let, Const,
  Literal,
  Return,
#___________________
func toKind (name :string) :Kind=
  ## @descr
  ##  Converts the given {@arg name} into a known slate.Kind
  ##  Raises a {@link NodeAccessError} when {@arg name} is not mapped to a kind
  case name
  of "empty"            : result = Kind.Empty
  of "proc","procedure" : result = Kind.Proc
  of "func","function"  : result = Kind.Func
  of "var"              : result = Kind.Var
  of "let"              : result = Kind.Let
  of "const"            : result = Kind.Const
  of "literal"          : result = Kind.Literal
  of "return"           : result = Kind.Return
  else: err "Tried to access and unmapped Node Kind:  " & name
#___________________
func check *(
    code : PNode;
    args : varargs[TNodeKind];
  ) :bool {.discardable.}=
  for kind in args:
    if code.kind == kind: return true
#___________________
func check *(
    code : PNode;
    list : set[TNodeKind];
  ) :bool {.discardable.}=
  for kind in list:
    if code.kind == kind: return true
#___________________
proc ensure *(
    code : PNode;
    args : varargs[TNodeKind];
    msg  : string = DefaultErrorMsg,
  ) :bool {.discardable.}=
  ## @descr Raises a {@link NodeAccessError} when none of the {@arg args} kinds match the {@link TNodeKind} of {@arg code}
  if check(code, args): return true
  code.err msg&cfg_Sep&fmt"Node {code.kind} is not of type:  {args}."
#___________________
proc ensure *(
    code : PNode;
    list : set[TNodeKind];
    msg  : string = DefaultErrorMsg,
  ) :bool {.discardable.}=
  if check(code, list): return true
  code.err msg&cfg_Sep&fmt"Node {code.kind} is not of type:  {list}."
#___________________
proc ensure *(
    code  : PNode;
    kinds : varargs[Kind];
    msg   : string = DefaultErrorMsg,
  ) :bool {.discardable.}=
  ## @descr Raises a {@link NodeAccessError} when none of the {@arg args} {@link Kind}s match the {@link TNodeKind} of {@arg code}.
  for kind in kinds:
    case kind
    of Proc:
      if check(code, nkProcDef): return true else: continue
    of Return:
      if check(code, nkReturnStmt): return true else: continue
    of Literal:
      if check(code, nim.Literals): return true else: continue
    of Func:
      if check(code, nkFuncDef): return true else: continue
    of Const:
      if check(code, nkConstSection, nkConstDef): return true else: continue
    of Let:
      if check(code, nkLetSection, nkIdentDefs): return true else: continue
    of Var:
      if check(code, nkVarSection, nkIdentDefs): return true else: continue
    # of "variable": ensure code, nkVarDef, nkLet  ???
    else: code.err &"Tried to access an unmapped Node kind:  {kind}"
  code.err msg&cfg_Sep&fmt"Node {code.kind} is not a valid kind:  {kinds}."
#___________________
proc ensure *(code :PNode; field :string) :void=  ensure code, field.toKind


#_______________________________________
# @section Node Access: General
#_____________________________
proc isPublic *(code :PNode) :bool=
  ## @descr Returns true if the name of the {@arg code} is marked as public
  const (Name, Publ, PublName) = (0, 0, 1)
  code[Name].kind != nkIdent and code[Name][Publ].strValue == "*"
#___________________
proc isMutable *(kind :Kind) :bool=
  assert kind in {Const, Let, Var}, "Tried to check for mutability of a kind that doesn't support it:  {kind}"
  result = kind == Kind.Var
proc isMutable *(code :PNode) :bool=
  ensure code, Const, Let, Var, msg="Tried to check for mutability of a node that doesn't support it:  {code.kind}"
  result = code.kind != nkConstDef
#___________________
proc getName *(code :PNode) :PNode=
  const (Name, Publ, PublName) = (0, 0, 1)
  let name = code[Name]
  if   name.kind == nkIdent   : return code[Name]
  elif name.kind == nkPostFix : return code[Name][PublName]
  else: code.err &"Something went wrong when accessing the Name of a {code.kind}. The name field is:  " & $code[Name].kind
#___________________
proc getType *(code :PNode) :PNode=
  const (Type,) = (1,)
  if code[Type].kind == nkIdent : return code[Type]
  else: code.err &"Something went wrong when accessing the Type of a {code.kind}. The type field is:  " & $code[Type].kind


#_______________________________________
# @section Node Access: Statement List
#_____________________________
proc getStmt (code :PNode; id :SomeInteger) :PNode=  code[id]


#_______________________________________
# @section Node Access: Procs
#_____________________________
const UnknownID :int= int.high
proc procs_get (code :PNode; field :string; id :SomeInteger= UnknownID) :PNode=
  # 0. Name
  const (Name, Publ, PublName) = (0, 0, 1)
  # 1. Term Rewriting (only for macros/templates)
  const TermRewrite = 1
  # 2. Generics
  const Generics = 2
  # 3. Args
  const Args = 3
  const RetT = 0
  # 4. Pragmas
  const Pragmas = 4
  # 5. Reserved
  const Reserved = 5 # Field reserved for the future
  # 6. Proc's Body  (aka Statement List)
  const Body = 6
  # Access the requested field
  case field
  of "name"     : return code.getName()
  of "generics" : return code[Generics]
  of "returnT"  : return code[Args][RetT]
  of "args"     : return code[Args]
  of "arg"      :
    if id == UnknownID: code.err "Tried to access an Argument of a nkProcDef, but its ID was not passed."
    return code[Args][id]
  of "pragmas"  : return code[Pragmas]
  of "pragma"   :
    if id == UnknownID: code.err "Tried to access a Pragma of a nkProcDef, but its ID was not passed."
    return code[Pragmas][id]
  of "body"     : return code[Body]
  else: code.err "Tried to access an unmapped field of nkProcDef: " & field

#_______________________________________
# @section Node Access: Variables
#_____________________________
proc vars_get (code :PNode; field :string; id :SomeInteger= UnknownID) :PNode=
  # 2. Variable's Body  (aka Statement List)
  const Body = 2
  case field
  of "name" : return code.getName()
  of "type" : return code.getType()
  of "body" : return code[Body]
  else: code.err &"Tried to access an unmapped field of {code.kind}: " & field

#_______________________________________
# @section Node Access
#_____________________________
template `.:`*(code :PNode; prop :untyped) :string=
  let field = astToStr(prop)
  case code.kind
  of nkStmtList :
    var id = int.high
    try : id = field.parseInt
    except NodeAccessError: code.err "Tried to access a Statement List, but the keyword passed was not a number:  "&field
    strValue( code.getStmt(id) )
  of nkProcDef:
    var id       = int.high
    var property = field
    if "arg" in field:
      property = field.split("_")[0]
      try : id = field.split("_")[1].parseInt
      except NodeAccessError: code.err "Tried to access an Argument ID for a nkProcDef, but the keyword passed has an incorrect format:  "&field
    strValue( procs_get(code, property, id) )
  of nkConstDef, nkIdentDefs:
    strValue( vars_get(code, field) )
  else: code.err "Tried to access a field for an unmapped Node kind: " & $code.kind & "." & field; ""



#____________________________________________________________________________________________________________
#____________________________________________________________________________________________________________
#____________________________________________________________________________________________________________
#____________________________________________________________________________________________________________
# @deps minc
import ../cfg
import ../errors
import ../types


#_______________________________________
# @section Forward Declares
#_____________________________
proc MinC *(code :PNode; indent :int= 0) :CFilePair


#_______________________________________
# @section Return
#_____________________________
const ReturnTempl = "{ind}return{body};"
proc mincReturnStmt (code :PNode; indent :int= 1) :CFilePair=
  ensure code, Return
  if indent < 1: code.err &"Found an incorrect indentation level for a Return statement:  {indent}"
  let ind = indent*Tab
  # Generate the Body
  var body :string
  if code.sons.len > 0: body.add " "
  for entry in code: body.add MinC(entry).c # TODO: Could Header stuff happen inside a body ??
  # Generate the result
  result.c = fmt ReturnTempl


#_______________________________________
# @section Procedures
#_____________________________
proc mincFuncDef (code :PNode; indent :int= 0) :CFilePair=
  # __attribute__ ((pure))
  # write-only memory idea from herose (like GPU write-only mem)
  ensure code, Func
  trigger ProcError, "proc and func are identical in C"  # TODO : Sideffects checks
#_____________________________
const ProcProtoTempl = "{qual}{T} {name} ({args});\n"
const ProcDefTempl   = "{qual}{T} {name} ({args}) {{\n{body}\n}}\n"
proc mincProcDef (code :PNode; indent :int= 0) :CFilePair=
  ensure code, Proc
  var qual = ""
  let name = code.:name
  if not code.isPublic: qual.add "static "
  let T    = code.:returnT
  let args = "void"
  let body = MinC(procs_get(code,"body"), indent+1).c # TODO: Could Header stuff happen inside a body ??
  # Generate the result
  result.h =
    if code.isPublic and name != "main" : fmt ProcProtoTempl
    else                                : ""
  result.c = fmt ProcDefTempl


#_______________________________________
# @section Variables
#_____________________________
const VarDeclTempl = "{indent*Tab}extern {qual}{T} {name};\n"
const VarDefTempl  = "{indent*Tab}{qual}{T} {name} = {value};\n"
proc mincVariable (code :PNode; indent :int; kind :Kind) :CFilePair=
  ensure code, Const, Let, Var, msg="Tried to generate code for a variable, but its kind is incorrect"
  let name  = code.:name
  var qual  = if not code.isPublic: "static " else: ""
  if kind == Const: qual.add " /*constexpr*/"
  var T     = code.:type
  if not kind.isMutable: T.add " const"
  let value = MinC(vars_get(code, "body"), indent+1).c
  # Generate the result
  result.h =
    if code.isPublic : fmt VarDeclTempl
    else             : ""
  result.c = fmt VarDefTempl

#___________________
proc mincConstSection (code :PNode; indent :int= 0) :CFilePair=
  ensure code, Const
  for entry in code.sons: result.add mincVariable(entry, indent, Kind.Const)
#___________________
proc mincLetSection (code :PNode; indent :int= 0) :CFilePair=
  ensure code, Let
  for entry in code.sons: result.add mincVariable(entry, indent, Kind.Let)
#___________________
proc mincVarSection (code :PNode; indent :int= 0) :CFilePair=
  ensure code, Var
  for entry in code.sons: result.add mincVariable(entry, indent, Kind.Var)


#_______________________________________
# @section Literals
#_____________________________
proc mincChar *(code :PNode; indent :int= 0) :CFilePair=
  ensure code, Char
  discard
#___________________
proc mincFloat *(code :PNode; indent :int= 0) :CFilePair=
  ensure code, Float
  result.c = $code.floatVal
#___________________
proc mincInt *(code :PNode; indent :int= 0) :CFilePair=
  ensure code, Int
  result.c = $code.intVal
#___________________
proc mincUInt *(code :PNode; indent :int= 0) :CFilePair=
  ensure code, UInt
  result.c = $code.intVal
#___________________
proc mincStr *(code :PNode; indent :int= 0) :CFilePair=
  ensure code, Str
  result.c = code.strVal
#___________________
proc mincNil *(code :PNode; indent :int= 0) :CFilePair=
  ensure code, Nil
  result.c = "NULL"
#___________________
proc mincLiteral *(code :PNode; indent :int= 0) :CFilePair=
  ensure code, Literal
  case code.kind
  of nim.Char  : result = mincChar(code, indent)
  of nim.Float : result = mincFloat(code, indent)
  of nim.Int   : result = mincInt(code, indent)
  of nim.UInt  : result = mincUInt(code, indent)
  of nim.Str   : result = mincStr(code, indent)
  of nim.Nil   : result = mincNil(code, indent)
  else: trigger LiteralError, "Found an unmapped Literal kind:  " & $code.kind

#______________________________________________________
# @section Source-to-Source Generator
#_____________________________
proc MinC *(code :PNode; indent :int= 0) :CFilePair=
  case code.kind
  # Recursive Cases
  of nkStmtList:
    for child in code   : result.add MinC( child, indent )
  # Intermediate cases
  # └─ Procedures
  of nkProcDef          : result = mincProcDef(code, indent)
  of nkFuncDef          : result = mincProcDef(code, indent)
  # └─ Control flow
  of nkReturnStmt       : result = mincReturnStmt(code, indent)
  # of nkBreakStmt        : result = mincBreakStmt(code, indent)
  # of nkContinueStmt     : result = mincContinueStmt(code, indent)
  #   Variables
  of nkConstSection     : result = mincConstSection(code, indent)
  # of nkLetSection       : result = mincLetSection(code, indent)
  # of nkVarSection       : result = mincVarSection(code, indent)
  # Terminal cases
  of nim.Literals       : result = mincLiteral(code, indent)
  else: code.err &"Translating {code.kind} to MinC is not supported yet."

