

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
proc ensure *(
    code : PNode;
    args : varargs[TNodeKind];
    msg  : string = DefaultErrorMsg,
  ) :void=
  ## @descr Raises a {@link NodeAccessError} when none of the {@arg args} kinds match the {@link TNodeKind} of {@arg code}
  for kind in args:
    if code.kind == kind: return
  code.err msg&cfg_Sep&fmt"Node {code.kind} is not of type:  {args}."
#___________________
proc ensure *(
    code : PNode;
    list : set[TNodeKind];
    msg  : string = DefaultErrorMsg,
  ) :void=
  for kind in list:
    if code.kind == kind: return
  code.err msg&cfg_Sep&fmt"Node {code.kind} is not of type:  {list}."
#___________________
proc ensure *(
    code  : PNode;
    kinds : varargs[Kind];
    msg   : string = DefaultErrorMsg,
  ) :void=
  ## @descr Raises a {@link NodeAccessError} when none of the {@arg args} {@link Kind}s match the {@link TNodeKind} of {@arg code}.
  for kind in kinds:
    case kind
    of Proc    : ensure code, nkProcDef
    of Return  : ensure code, nkReturnStmt
    of Literal : ensure code, nim.Literals
    of Func    : ensure code, nkFuncDef
    # of "variable": ensure code, nkVarDef, nkLet  ???
    else: code.err &"Tried to access an unmapped Node kind:  {kind}"
#___________________
proc ensure *(code :PNode; field :string) :void=  ensure code, field.toKind



#_______________________________________
# @section Node Access: Statement List
#_____________________________
proc getStmt (code :PNode; id :SomeInteger) :PNode=  code[id]


#_______________________________________
# @section Node Access: Procs
#_____________________________
proc isPublic *(code :PNode) :bool=
  ## @descr Returns true if the name of the {@arg code} is marked as public
  const (Name, Publ, PublName) = (0, 0, 1)
  code[Name].kind != nkIdent and code[Name][Publ].strValue == "*"
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
  of "name":
    let name = code[Name]
    if   name.kind == nkIdent   : return code[Name]
    elif name.kind == nkPostFix : return code[Name][PublName]
    else: code.err "Something went wrong when accessing the Name of a nkProcDef. The name argument is:  " & $code[Name].kind
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
  # Terminal cases
  of nim.Literals       : result = mincLiteral(code, indent)
  else: code.err &"Translating {code.kind} to MinC is not supported yet."

