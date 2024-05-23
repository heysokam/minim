

#_______________________________________
# @section Slate Configuration
#_____________________________
# @deps ndk
import nstd/strings
import nstd/errors
# @deps *Slate
import slate/nimc as nim
import slate/format

#_______________________________________
# @section Slate Configuration
#_____________________________
const slate_cfg_Sep    *{.strdefine.}= "  "
const slate_cfg_Prefix *{.strdefine.}= "*Slate" & slate_cfg_Sep # TODO: Change functions to take 2 formatting parameters



#_______________________________________
# @section Node Access: Error Management
#_____________________________
const echo = debugEcho
const DefaultErrorMsg = "Something went wrong."
#___________________
type NodeAccessError = object of CatchableError
func err *(msg :string; pfx :string= slate_cfg_Prefix) :void= raise newException(NodeAccessError, pfx&msg)
  ## @descr Raises a {@link NodeAccessError} with a formatted {@arg msg}
proc err *(code :PNode; msg :string; pfx :string= slate_cfg_Prefix) :void= err &"\n{code.treeRepr}\n{code.renderTree}\n{pfx}{msg}", pfx=""
  ## @descr Raises a {@link NodeAccessError} with a formatted {@arg msg}, with debugging information about the {@arg code}
proc err *(
    code : PNode;
    excp : typedesc[CatchableError];
    msg  : string;
    pfx  : string = slate_cfg_Prefix;
  ) :void= trigger excp, &"\n{code.treeRepr}\n{code.renderTree}\n{pfx}{msg}", pfx
  ## @descr Raises the {@arg excp} with a formatted {@arg msg} and debugging information about the {@arg code}
#___________________
type Kind *{.pure.}= enum
  None, Empty,
  Proc, Func, Call,
  Var, Let, Const, Asgn
  Literal, RawStr,
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
  of "assign"           : result = Kind.Asgn
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
  code.err msg&slate_cfg_Sep&fmt"Node {code.kind} is not of type:  {args}."
#___________________
proc ensure *(
    code : PNode;
    list : set[TNodeKind];
    msg  : string = DefaultErrorMsg,
  ) :bool {.discardable.}=
  if check(code, list): return true
  code.err msg&slate_cfg_Sep&fmt"Node {code.kind} is not of type:  {list}."
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
    of Func:
      if check(code, nkFuncDef): return true else: continue
    of Return:
      if check(code, nkReturnStmt): return true else: continue
    of Call:
      if check(code, nim.SomeCall): return true else: continue
    of Const:
      if check(code, nkConstSection, nkConstDef): return true else: continue
    of Let:
      if check(code, nkLetSection, nkIdentDefs): return true else: continue
    of Var:
      if check(code, nkVarSection, nkIdentDefs): return true else: continue
    of Asgn:
      if check(code, nkAsgn): return true else: continue
    of Literal:
      if check(code, nim.SomeLit): return true else: continue
    of RawStr:
      if check(code, nkCallStrLit): return true else: continue
    else: code.err &"Tried to access an unmapped Node kind:  {kind}"
  code.err msg&slate_cfg_Sep&fmt"Node {code.kind} is not a valid kind:  {kinds}."
#___________________
proc ensure *(code :PNode; field :string) :void=  ensure code, field.toKind


#_______________________________________
# @section Node Access: General Fields
#_____________________________
proc getName *(code :PNode) :PNode=
  const (Name, Publ, PublName, Pragma) = (0, 0, 1, 0)
  let name = code[Name]
  if   name.kind == nkIdent      : return code[Name]
  elif name.kind == nkPostFix    : return code[Name][PublName]
  elif name.kind == nkPragmaExpr : return code[Pragma].getName()
  else: code.err &"Something went wrong when accessing the Name of a {code.kind}. The name field is:  " & $code[Name].kind
#___________________
proc getType *(code :PNode) :PNode=
  const TypeSlotKinds = {nkIdent, nkEmpty, nkCommand, nkPtrTy}  # Kinds that contain a valid type at slot [Type]
  const (Type,ArrayType) = (1,2)
  if   code.kind in {nkIdent,nkEmpty}   : return code
  elif code[Type].kind in TypeSlotKinds : return code[Type]
  elif code[Type].kind == nkBracketExpr : return code[Type][ArrayType].getType()
  else: code.err &"Something went wrong when accessing the Type of a {code.kind}. The type field is:  " & $code[Type].kind


#_______________________________________
# @section Node Access: General Kinds
#_____________________________
proc isPublic *(code :PNode) :bool=
  ## @descr Returns true if the name of the {@arg code} is marked as public
  const (Name, Publ, PublName) = (0, 0, 1)
  code[Name].kind != nkIdent and code[Name][Publ].strValue == "*"
#___________________
proc isPersist *(
    code   : PNode;
    indent : SomeInteger;
    crash  : bool = true;
  ) :bool=
  ## @descr
  ##  Returns true if the {@arg code} is marked with the persist pragma.
  ##  Crashes the compiler on unexpected behavior when {@arg crash} is active or is omitted  (default: true)
  const (Name,Pragma) = (0,1)
  if code.kind notin {nkConstDef, nkIdentDefs, nkPragmaExpr}:  # TODO: Do other things need the {.persist.} pragma?
    if crash: code.err "Tried to get the persist pragma for an unmapped kind."
    return false
  if indent < 1: return false
  let name = code[Name]
  if name.kind notin {nkIdent, nkPostfix, nkPragmaExpr}:
    if crash: name.err "Tried to get the persist pragma from an unmapped name node kind."
    return false
  return name.kind == nkPragmaExpr and
         name[Pragma][Name].kind != nkEmpty and
         name[Pragma][Name].strValue == "persist"
#___________________
proc isMutable *(code :PNode; kind :Kind) :bool=
  ## @descr Returns true if the {@arg code} defines a mutable kind
  ensure code, Const, Let, Var, msg= &"Tried to check for mutability of a kind that doesn't support it:  {kind}"
  result = kind == Kind.Var
#___________________
proc isPtr *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} defines a ptr type
  result = code.kind == nkPtrTy
#___________________
proc isArr *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} defines an array type
  const TypeSlotKinds = {nkIdentDefs, nkConstDef}  # Kinds that contain a valid type at slot [Type]
  const NameSlotKinds = {nkBracketExpr, nkPtrTy}   # Kinds that contain a valid type at slot [Name]
  const (Name,Type) = (0,1)
  if   code.kind == nkIdent       : result = code.strValue == "array"
  elif code.kind in nim.SomeLit   : result = false
  elif code.kind == nkCommand     : result = false  # Commands are considered literals (multi-word types)
  elif code.kind in TypeSlotKinds : result = code[Type].isArr()
  elif code.kind in NameSlotKinds : result = code[Name].isArr()
  else: code.err &"Tried to check if a node is an array, but found an unmapped kind:  {code.kind}"


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
proc vars_get (code :PNode; field :string) :PNode=
  const Body = 2  # 2. Variable's Body  (aka Statement List)
  case field
  of "name" : return code.getName()
  of "type" : return code.getType()
  of "body" : return code[Body]
  else: code.err &"Tried to access an unmapped field of {code.kind}: " & field



#____________________________________________________________________________________________________________
#____________________________________________________________________________________________________________
#____________________________________________________________________________________________________________
#____________________________________________________________________________________________________________
# @deps minc
import ../cfg
import ../errors
import ../types


#_______________________________________
# @section MinC+Slate Node Access
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
    let typ = vars_get(code, field)
    case typ.kind
    of nkCommand,nkPtrTy:
      var tmp :string
      for field in typ: tmp.add strValue( field ) & " "
      if typ.isPtr: tmp = tmp.strip & "*"
      tmp
    else: strValue( typ )
  else: code.err "Tried to access a field for an unmapped Node kind: " & $code.kind & "." & field; ""



#_______________________________________
# @section Forward Declares
#_____________________________
proc MinC *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair
proc mincLiteral *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair


#_______________________________________
# @section Array tools
#_____________________________
proc mincArrSize *(code :PNode; indent :int= 0) :CFilePair=
  ## @descr Returns the array size defined by {@arg code}
  const (Type,ArraySize) = (1,1)
  let typ =
    if   code.kind == nkIdent     : code
    elif code.kind == nkIdentDefs : code[Type]
    else                          : code.getType()
  if   typ.kind in {nkIdent}+nim.Literals : result.c = typ.strValue
  elif typ.kind == nkBracketExpr          : result.c = typ[ArraySize].strValue
  elif typ.kind == nkInfix                : result = MinC(typ, indent)
  else: code.err &"Tried to access the array size of an unmapped kind:  {typ.kind}" # TODO: Better infix resolution
  # Correct the `_` empty array size case
  if result.c == "_": result.c = ""


#_______________________________________
# @section Return
#_____________________________
const ReturnTempl = "{ind}return{body};"
proc mincReturnStmt (code :PNode; indent :int= 1; special :SpecialContext= None) :CFilePair=
  ensure code, Return
  if indent < 1: code.err &"Found an incorrect indentation level for a Return statement:  {indent}"
  let ind = indent*Tab
  # Generate the Body
  var body :string
  if code.sons.len > 0: body.add " "
  for entry in code: body.add MinC(entry, indent+1, special).c # TODO: Could Header stuff happen inside a body ??
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
#___________________
proc mincCall *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Call
  if code.kind == nkCallStrLit: return mincLiteral(code, indent, special)
  NodeAccessError.trigger "Calls are not supported yet"



#_______________________________________
# @section Variables
#_____________________________
const VarDeclTempl = "{indent*Tab}extern {qual}{T} {name};\n"
const VarDefTempl  = "{indent*Tab}{qual}{T} {name}{eq}{value};\n"
proc mincVariable (code :PNode; indent :int; kind :Kind) :CFilePair=
  const Type = 2
  # Error check
  ensure code, Const, Let, Var, msg="Tried to generate code for a variable, but its kind is incorrect"
  let typ  = vars_get(code, "type")
  let body = vars_get(code, "body")
  if typ.kind == nkEmpty: trigger VariableError,
    &"Declaring a variable without a type is forbidden. The illegal code is:\n{code.renderTree}\n"
  if kind == Const and body.kind == nkEmpty: trigger VariableError,
    &"Declaring a variable without a value is forbidden for `const`. The illegal code is:\n{code.renderTree}\n"
  # Get the qualifier
  var qual :string
  if code.isPersist(indent) or (indent < 1 and not code.isPublic) : qual.add "static "
  if kind == Const: qual.add "/*constexpr*/ "  # TODO: clang.19
  # Get the type
  var T = code.:type
  if T == "pointer": T = PtrValue # Rename `pointer` to `void*`  ## TODO: configurable based on c23 option
  if not code.isMutable(kind): T.add " const"
  # TODO: {.readonly.} variable without explicit typedef
  # Get the Name
  var name = code.:name
  # Name: Array special case extras
  let isArr = code.isArr
  let arrSz = if isArr: mincArrSize(code, indent).c else: ""
  let arr   = if isArr: &"[{arrSz}]" else: ""
  if isArr and arr == "": code.trigger VariableError,
    "Found an array type, but its code has not been correctly generated."
  name.add arr
  # Get the body (aka variable value)
  let value = MinC(body, indent+1, SpecialContext.Variable).c
  let eq    = if value != "": " = " else: ""
  # Generate the result
  result.h =
    if code.isPublic and indent == 0 : fmt VarDeclTempl
    else:""
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
#___________________
const AsgnTempl = "{indent*Tab}{left} = {right};"
proc mincAsgn *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Asgn
  const (Left, Right) = (0,1)
  let left  = MinC(code[Left], indent).c
  let right = MinC(code[Right], indent).c
  result.c = fmt AsgnTempl
  case special
  of None: result.c.add "\n"
  else: discard


#_______________________________________
# @section Literals
#_____________________________
proc mincNil *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Nil
  result.c = NilValue
#___________________
proc mincChar *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Char
  result.c = &"'{code.strValue}'"
#___________________
proc mincFloat *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Float
  result.c = $code.floatVal
  case code.kind
  of nkFloat32Lit  : result.c.add "f"
  of nkFloat128Lit : result.c.add "L"
  else: discard
#___________________
proc mincInt *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Int
  result.c = $code.intVal
#___________________
proc mincUInt *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, UInt
  result.c = $code.intVal
#___________________
const StrKinds = nim.Str+{nkCallStrLit}
const ValidRawStrPrefixes = ["raw"]
proc isCustomTripleStrLitRaw (code :PNode) :bool= (code.kind in {nkCallStrLit} and code[0].strValue in ValidRawStrPrefixes and code[1].kind == nkTripleStrLit)
proc isTripleStrLit (code :PNode) :bool=  code.kind == nkTripleStrLit or code.isCustomTripleStrLitRaw
proc getTripleStrLit (code :PNode; indent :int= 0; special :SpecialContext= None) :string=
  ensure code, StrKinds, "Called getTripleStrLit with an incorrect node kind."
  let tab  = indent*Tab
  let val  = if code.kind == nkTripleStrLit: code else: code[1]
  var body = val.strValue
  let multiline = "\n" in body
  if code.isCustomTripleStrLitRaw : body = body.replace( "\n" , &"\"\n{tab}\""  )   # turn every \n character into  \n"\nTAB"  to use C's "" concatenation
  else                            : body = body.replace( "\n" , &"\\n\"\n{tab}\"" ) # turn every \n character into \\n"\nTAB"  to use C's "" concatenation
  if multiline: result.add &"\n{tab}"
  result.add &"\"{body}\""
  result = result.replace( &"\n{tab}\"\"", "" ) # Remove empty lines  (eg: the last empty line)
#___________________
proc mincStr *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, StrKinds, "Called mincStr with an incorrect node kind."
  if code.isTripleStrLit : result.c = code.getTripleStrLit(indent, special)
  else                   : result.c = &"\"{code.strVal}\""
#___________________
proc mincLiteral *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Literal, RawStr, "Called mincLiteral with an incorrect node kind."
  case code.kind
  of nim.Nil      : result = mincNil(code, indent, special)
  of nim.Char     : result = mincChar(code, indent, special)
  of nim.Float    : result = mincFloat(code, indent, special)
  of nim.Int      : result = mincInt(code, indent, special)
  of nim.UInt     : result = mincUInt(code, indent, special)
  of StrKinds     : result = mincStr(code, indent, special)
  else: code.trigger LiteralError, &"Found an unmapped Literal kind:  {code.kind}"
#___________________
proc mincBracket *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  case special
  of Variable:
    result.c.add "{ "
    for id,value in code.sons.pairs:
      result.c.add &"\n{indent*Tab}[{id}]= "
      result.c.add MinC(value, indent+1, special).c
      result.c.add if id != code.sons.high: "," else: "\n"
    result.c.add &"{indent*Tab}}}"
  else: code.trigger BracketError, &"Found an unmapped kind for interpreting Bracket code:  {special}"
#___________________
proc mincIdent *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  let val = code.strValue
  case special
  of Object:
    if val == "_": result.c = "{0}" # This is definitely incorrect for the Object SpecialContext
  of None: result.c = val
  else: code.trigger IdentError, &"Found an unmapped kind for interpreting Indent code:  {special}"


#______________________________________________________
# @section Source-to-Source Generator
#_____________________________
proc MinC *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  case code.kind
  # Recursive Cases
  of nkStmtList:
    for child in code   : result.add MinC( child, indent, special )
  # Intermediate cases
  # └─ Procedures
  of nkProcDef          : result = mincProcDef(code, indent)
  of nkFuncDef          : result = mincProcDef(code, indent)
  # └─ Control flow
  of nkReturnStmt       : result = mincReturnStmt(code, indent, special)
  # of nkBreakStmt        : result = mincBreakStmt(code, indent, special)
  # of nkContinueStmt     : result = mincContinueStmt(code, indent, special)
  # └─ Variables
  of nkConstSection     : result = mincConstSection(code, indent)
  of nkLetSection       : result = mincLetSection(code, indent)
  of nkVarSection       : result = mincVarSection(code, indent)
  of nkAsgn             : result = mincAsgn(code, indent, special)
  # Terminal cases
  of nim.SomeLit        : result = mincLiteral(code, indent, special)
  of nim.SomeCall       : result = mincCall(code, indent, special)
  of nkBracket          : result = mincBracket(code, indent, special)
  of nkIdent            : result = mincIdent(code, indent, special)
  of nkEmpty            : result = CFilePair()
  else: code.err &"Translating {code.kind} to MinC is not supported yet."

