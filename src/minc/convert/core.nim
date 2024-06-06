#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/strings
import nstd/paths
from nstd/sets import anyIn, with, without
# @deps *Slate
import slate/nimc as nim
import slate/format
import slate/elements
import slate/errors as slateErr
import slate/types as slate
# @deps minc
import ../cfg
import ../errors
import ../types as minc
import ../tools


#_______________________________________
# @section MinC+Slate Node Access
#_____________________________
const Renames_Calls :RenameList= @[
  ("addr", "&")
  ] # << Renames_Calls [ ... ]
#___________________
const Renames_ConditionPrefix :RenameList= @[
  ("not", "!"),
  ] # << Renames_ConditionPrefix [ ... ]
#___________________
const Renames_ConditionAffix :RenameList= @[
  ("shl", "<<"),  ("shr", ">>"),
  ("and", "&&"),  ("or" , "||"),  ("xor", "^"),
  ("mod", "%" ),  ("div", "/" ),
  ] # << Renames_ConditionAffix [ ... ]
const Renames_AssignmentAffix :RenameList= @[
  ("shl", "<<"),  ("shr", ">>"),
  ("and", "&" ),  ("or" , "|" ),  ("xor", "^" ),
  ("mod", "%" ),  ("div", "/" ),
  ] # << Renames_AssignmentAffix [ ... ]
#___________________
func renamed (name :string; kind :TNodeKind; special :SpecialContext= Context.None) :string=
  let list =
    case kind
    of nkCommand, nkCall        : Renames_Calls
    of nkPrefix                 : Renames_ConditionPrefix
    of nkInfix                  :
      if   Condition in special : Renames_ConditionAffix
      elif Variable  in special : Renames_AssignmentAffix
      else                      : @[]
    else                        : @[]
  for rename in list:
    if name == rename.og: return rename.to
  result = name
#___________________
template `.:`*(code :PNode; prop :untyped) :string=
  let field = astToStr(prop)
  case code.kind
  of nkStmtList:
    var id = int.high
    try : id = field.parseInt
    except NodeAccessError: code.err "MinC: Tried to access a Statement List, but the keyword passed was not a number:  "&field
    strValue( statement.get(code, id) )
  of nkProcDef:
    var id       = int.high
    var property = field
    if "arg_" in field:
      property = field.split("_")[0]
      try : id = field.split("_")[1].parseInt
      except NodeAccessError: code.err "MinC: Tried to access an Argument ID for a nkProcDef, but the keyword passed has an incorrect format:  "&field
    strValue( procs.get(code, property, id) )
  of nkConstDef, nkIdentDefs:
    let typ = vars.get(code, field)
    case typ.kind
    of nkCommand,nkPtrTy:
      var tmp :string
      for field in typ: tmp.add strValue( field ) & " "
      if typ.isPtr: tmp = tmp.strip & "*"
      tmp
    else: strValue( typ )
  of nkPragma:
    strValue( pragmas.get(code, field) )
  of nkCommand, nkCall:
    var id       = int.high
    var property = field
    if "arg_" in field:
      property = field.split("_")[0]
      try : id = field.split("_")[1].parseInt
      except NodeAccessError: code.err "MinC: Tried to access an Argument ID for a Call, but the keyword passed has an incorrect format:  "&field
    strValue( calls.get(code, property, id) ).renamed(code.kind)
  of nkTypeDef:
    strValue( types.get(code, field) )
  of nkPrefix:
    strValue( affixes.getPrefix(code, field) )
  of nkInfix:
    strValue( affixes.getInfix(code, field) )
  else: code.err "MinC: Tried to access a field for an unmapped Node kind: " & $code.kind & "." & field; ""



#_______________________________________
# @section Forward Declares
#_____________________________
proc MinC *(code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair
proc mincLiteral (code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair


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
# @section Control Flow: Keywords
#_____________________________
const ReturnTempl = "{indent*Tab}return{body};"
proc mincReturnStmt (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Return
  if indent < 1: code.trigger FlowCtrlError, "Return statements cannot exist at the top level in C."
  # Generate the Body
  var body :string
  if code.sons.len > 0: body.add " "  # Separate `return` and `body` with a space when there is a value
  for entry in code: body.add MinC(entry, indent+1, special).c # TODO: Could Header stuff happen inside a body ??
  # Generate the result
  result.c = fmt ReturnTempl
#___________________
proc mincContinueStmt (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Continue
  if indent < 1: code.trigger FlowCtrlError, "Continue statements cannot exist at the top level in C."
  result.c = &"{indent*Tab}continue;\n"
#___________________
proc mincBreakStmt (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Break
  if indent < 1: code.trigger FlowCtrlError, "Break statements cannot exist at the top level in C."
  result.c = &"{indent*Tab}break;\n"


#_______________________________________
# @section Control Flow: Loops
#_____________________________
const WhileTempl = "{indent*Tab}while ({cond}) {{\n{body}{indent*Tab}}}\n"
proc mincWhile (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, nkWhileStmt
  const (Condition,Body) = (0,1)
  let cond = MinC(code[Condition], indent, Context.Condition).c
  let body = MinC(code[Body], indent+1, special).c
  result.c = fmt WhileTempl


#_______________________________________
# @section Control Flow: Conditionals
#_____________________________
const IfTempl = "{elseStr}{ifStr}({cond}) {{\n{body}{indent*Tab}}}"
const TernaryRawTempl = "({cond}) ? {case1} : {case2}"
proc mincIf (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, nkIfStmt
  if special == Variable:
    const (Condition,Case1,Case2) = (0,1,^1)
    let cond  = MinC(code[Condition], indent, Context.Condition).c
    let case1 = MinC(code[Case1], indent, Context.Condition).c
    let case2 = MinC(code[Case2], indent, Context.Condition).c
    result.c = fmt TernaryRawTempl
    return
  for id,branch in code.pairs:
    const (Condition,Body) = (0,1)
    let first   = id == 0
    let isElse  = branch.kind == nkElse
    let last    = id == code.sons.high
    let cond    = MinC(branch[Condition], indent, Context.Condition).c
    let body    = MinC(branch[Body], indent+1, special).c
    let elseStr = if first: indent*Tab else: " else "  # elif or else
    let ifStr   = if not isElse: " if "  else: ""      # if or elif
    result.c.add fmt IfTempl
    if last: result.c.add "\n"


#_______________________________________
# @section Modules
#_____________________________
proc getModule *(code :PNode) :Module=
  ensure code, Kind.Module # TODO: Support for Import
  const Module = 0
  let module = code[Module]
  ensure module, nkStrLit, nkInfix, nkDotExpr, nkIdent, &"Tried to get the module of a {code.kind} from an unsupported field kind:  {module.kind}"
  var line :string
  if   code.kind == nkIncludeStmt : line = "include "
  elif code.kind == nkImportStmt  : line = "import "
  else: code.err "Only include/import statements are supported for getModule."
  line.add module.renderTree.splitLines.join(" ").replace(" / ", "/")
  result = tools.getModule( line )
#___________________
const IncludeTempl = "#include {module}\n"
proc mincInclude (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Kind.Module, Kind.Ident, &"Tried to get the include of an unsupported kind:  {code.kind}"
  if indent > 0: code.err "include statements are only allowed at the top level."
  let M = code.getModule()
  let module =
    if M.local : M.path.string.wrapped
    else       : "<" & M.path.string & ">"
  result.c = fmt IncludeTempl


#_______________________________________
# @section Procedures
#_____________________________
const KnownMainNames = ["main", "WinMain"]
proc mincProcPragmas (code :PNode; indent :int= 0) :string=
  let pragmas = procs.get(code, "pragmas")
  for prag in pragmas:
    let name = MinC(prag, 0).c
    if   name == "noreturn"     : result.add "[[noreturn]] "
    elif name == "noreturn_C11" : result.add "_Noreturn"
    elif name == "noreturn_GNU" : result.add "__attribute__((noreturn))"
    else: code.trigger PragmaError, "proc pragmas error: Only {.noreturn.}, {.noreturn_C11.}, {.noreturn_GNU.} are currently supported."
#___________________
proc mincProcQualifiers (code :PNode; indent :int= 0) :string=
  let name = code.:name
  result = mincProcPragmas(code, indent)
  if not code.isPublic and name notin KnownMainNames: result.add "static "
#___________________
const ArgTempl = "{typ} {name}"
proc mincProcArgs (code :PNode; indent :int= 0) :string=
  # TODO: const by default
  # TODO: {.readonly.} pragma
  # ref :  fmt "{ronly}{typ}{mut} {arg.name}{arr}{sep}"
  ensure code, nkFormalParams
  if code.sons.len == 0: return "void"  # Explicit fill with void for no arguments
  # Add all arguments to the result
  var args :seq[tuple[name:string, typ:string, val:string]]
  for group in code:
    const (Type,Value,LastArg) = (^2,^1,^3)
    let typ = MinC(group[Type], indent+1, {Argument, Readonly}).c
    let val = MinC(group[Value], indent+1, {Argument, Readonly}).c
    for arg in group.sons[0..LastArg]:
      args.add (
        name : MinC(arg, indent+1, Argument).c,
        typ  : typ,
        val  : val,  # TODO: Default values
        ) # << args.add ( ... )
  for id,arg in args.pairs:
    let typ  = arg.typ
    let name = arg.name
    result.add fmt ArgTempl
    if id != args.high: result.add SeparatorArgs
#___________________
const ProcProtoTempl = "{qual}{T} {name} ({args});\n"
const ProcDefTempl   = "{qual}{T} {name} ({args}) {{\n{body}\n}}\n"
proc mincProcDef (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Proc
  let name = code.:name
  let qual = mincProcQualifiers(code, indent)
  let T    = code.:returnT
  let args = mincProcArgs(procs.get(code, "args"), indent)
  let body = MinC(procs.get(code,"body"), indent+1).c # TODO: Could Header stuff happen inside a body ??
  # Generate the result
  result.h =
    if code.isPublic and name notin KnownMainNames : fmt ProcProtoTempl
    else: ""
  result.c = fmt ProcDefTempl
#_____________________________
proc mincFuncDef (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  # __attribute__ ((pure))
  # write-only memory idea from herose (like GPU write-only mem)
  ensure code, Func
  mincProcDef(code, indent, special)
  # code.trigger ProcError, "proc and func are identical in C"  # TODO : Sideffects checks


#_______________________________________
# @section Calls & Commands
#_____________________________
const CallAddrTempl = "{name}{args}"
const CallRawTempl  = "{name}({args})"
const CallTempl     = "{indent*Tab}{call};\n"
proc mincCall (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  # TODO: Union special case
  # TODO: &(StructType){...} special case
  # TODO: StructType(_) special case
  ensure code, Call
  if code.kind == nkCallStrLit: return mincLiteral(code, indent, special)
  # Get the name
  let name = code.:name
  # Get the args code
  var args :string
  let code_args = calls.get(code, "args")
  for id,arg in code_args.pairs:
    args.add MinC(arg, indent+1, Argument).c
    if id != code_args.sons.high: args.add SeparatorArgs
  # Apply to the result
  let call =
    case name
    of "&": fmt CallAddrTempl
    else:   fmt CallRawTempl
  result.c =
    if special == {Context.None} : fmt CallTempl  # Format it by default
    else                         : call           # Leave it unchanged for special cases
#_____________________________
proc mincCommand (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Call
  mincCall(code, indent, special)  # Command and Call are identical in C


#_______________________________________
# @section Variables
#_____________________________
const VarDeclTempl = "{indent*Tab}extern {qual}{T} {name};\n"
const VarDefTempl  = "{indent*Tab}{qual}{T} {name}{eq}{value};\n"
#___________________
proc mincVariable (
    code   : PNode;
    indent : int;
    kind   : Kind;
  ) :CFilePair=
  # Error check
  ensure code, Const, Let, Var, msg="Tried to generate code for a variable, but its kind is incorrect"
  let typ  = vars.get(code, "type")
  let body = vars.get(code, "body")
  if typ.kind == nkEmpty: code.trigger VariableError,
    &"Declaring a variable without a type is forbidden."
  if kind == Const and body.kind == nkEmpty: code.trigger VariableError,
    &"Declaring a variable without a value is forbidden for `const`."
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
  let value = MinC(body, indent+1, Context.Variable).c
  let eq    = if value != "": " = " else: ""
  # Generate the result
  result.h =
    if code.isPublic and indent == 0 : fmt VarDeclTempl
    else:""
  result.c = fmt VarDefTempl
#___________________
proc mincConstSection (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Const
  for entry in code.sons: result.add mincVariable(entry, indent, Kind.Const)
#___________________
proc mincLetSection (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Let
  for entry in code.sons: result.add mincVariable(entry, indent, Kind.Let)
#___________________
proc mincVarSection (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Var
  for entry in code.sons: result.add mincVariable(entry, indent, Kind.Var)
#___________________
const AsgnTempl = "{indent*Tab}{left} = {right};"
proc mincAsgn (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Asgn
  const (Left, Right) = (0,1)
  let left  = MinC(code[Left], indent).c
  let right = MinC(code[Right], indent).c
  result.c = fmt AsgnTempl
  if special == {Context.None}: result.c.add "\n"


#_______________________________________
# @section Literals
#_____________________________
proc mincNil (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Nil
  result.c = NilValue
#___________________
proc mincChar (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Char
  result.c = &"'{code.strValue}'"
#___________________
proc mincFloat (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Float
  result.c = $code.floatVal
  case code.kind
  of nkFloat32Lit  : result.c.add "f"
  of nkFloat128Lit : result.c.add "L"
  else: discard
#___________________
proc mincInt (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Int
  result.c = $code.intVal
#___________________
proc mincUInt (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, UInt
  result.c = $code.intVal
#___________________
const StrKinds = nim.Str+{nkCallStrLit}
const ValidRawStrPrefixes = ["raw"]
proc isCustomTripleStrLitRaw (code :PNode) :bool= (code.kind in {nkCallStrLit} and code[0].strValue in ValidRawStrPrefixes and code[1].kind == nkTripleStrLit)
proc isTripleStrLit (code :PNode) :bool=  code.kind == nkTripleStrLit or code.isCustomTripleStrLitRaw
proc getTripleStrLit (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :string=
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
proc mincStr (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, StrKinds, "Called mincStr with an incorrect node kind."
  if code.isTripleStrLit : result.c = code.getTripleStrLit(indent, special)
  else                   : result.c = &"\"{code.strValue}\""
#___________________
proc mincLiteral (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
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
proc mincBracket (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  if Variable in special:
    result.c.add "{ "
    for id,value in code.sons.pairs:
      result.c.add &"\n{indent*Tab}[{id}]= "
      result.c.add MinC(value, indent+1, special).c
      result.c.add if id != code.sons.high: "," else: "\n"
    result.c.add &"{indent*Tab}}}"
  else: code.trigger BracketError, &"Found an unmapped SpecialContext kind for interpreting Bracket code:  {special}"
#___________________
proc mincIdent (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, nkIdent
  let val = code.strValue
  if Variable in special:
    result.c =
      if val == "_" : "{0}"  # TODO: Probably incorrect for the Object SpecialContext
      else          : val
  elif Readonly in special:
    result.c = &"{val} const"
  elif special.anyIn {Context.None, Argument, Condition, Typedef}:
    result.c = val
  else: code.trigger IdentError, &"Found an unmapped SpecialContext kind for interpreting Ident code:  {special}"


#_______________________________________
# @section Types
#_____________________________
const PointerTempl = "{typ}*"
proc mincType_ptr (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
    isVar   : bool           = false
  ) :CFilePair=
  ensure code, nkPtrTy
  const Type = 0
  let typ = MinC(code[Type], indent, special).c
  result.c = fmt PointerTempl
#___________________
proc mincType (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
    isVar   : bool           = false
  ) :CFilePair=
  ensure code, Type
  case code.kind
  of nkPtrTy : result = mincType_ptr(code, indent, special, isVar)
  of nkVarTy : result = MinC(code[0], indent, special.without Readonly)
  else: code.trigger TypeError, &"Found an unmapped kind for interpreting Type code:  {code.kind}"
#___________________
const TypedefTempl = "typedef {typ} {name};\n"
proc mincTypeDef (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Kind.TypeDef
  let pragm = types.get(code, "pragma").renderTree
  let isVar = "readonly" notin pragm
  let name  = code.:name
  let specl = if isVar: special else: special.with Readonly
  let typ   = MinC(types.get(code, "type"), indent, specl).c
  result.c  = fmt TypedefTempl


#_______________________________________
# @section Pragmas
#_____________________________
proc mincPragmaWarning (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ## @descr Codegen for {.warning: "msg".} pragmas
  ensure code, Pragma
  let body = pragmas.get(code, "body")
  ensure body, Str, &"Only {{.warning: [[SomeString]].}} warning pragmas are currently supported."
  let msg = mincStr(body, indent, special).c
  result.c = &"{indent*Tab}#warning {msg}\n"
#___________________
proc mincPragmaError (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ## @descr Codegen for {.error: "msg".} pragmas
  ensure code, Pragma
  let body = pragmas.get(code, "body")
  ensure body, Str, &"Only {{.error: [[SomeString]].}} error pragmas are currently supported."
  let msg = mincStr(body, indent, special).c
  result.c = &"{indent*Tab}#error {msg}\n"
#___________________
proc mincPragmaEmit (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ## @descr Codegen for {.emit: "source.code".} pragmas
  ensure code, Pragma
  let body = pragmas.get(code, "body")
  ensure body, Str, &"Only {{.emit: [[SomeString]].}} emit pragmas are currently supported."
  result.c = &"{indent*Tab}{body.strValue}\n"
#___________________
proc mincPragmaNamespace (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ## @descr Codegen for {.namespace: some.sub.name.} pragmas
  # TODO: Symbol namespacing using a `Context` object
  # TODO: Name separation without hard-replacing `.` with `_`
  ensure code, Pragma
  let name = pragmas.get(code, "name")
  let body = pragmas.get(code, "body")
  ensure name, nkIdent, nkDotExpr, &"Only {{.namespace:name.}} and {{.namespace:name.sub.}} namespace pragmas are currently supported."
  let ns_name = body.renderTree.replace(".", "_")
  result.c = &"{indent*Tab}// namespace {ns_name}\n"
#___________________
const ValidDefineAsignSymbols = ["->"]
const DefineTempl = "{indent*Tab}#define {name}{value}\n"
proc mincPragmaDefine (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ## @descr Codegen for {.define: ... .} pragmas
  const (Value,AssignSymbol,AssignValue, InfixName,InfixSymbol,InfixValue) = (1,0,1, 1,0,2)
  ensure code, Pragma
  let body = pragmas.get(code, "body")
  # Get the name
  var name :string
  case body.kind
  of nkIdent : name = body.strValue
  of nkInfix : name = body[InfixName].strValue
  else:
    code.trigger PragmaError, "Define[name] error: Only {.define:name.} and {.define: name[sym]value.} pragmas are currently supported."
  # Get the value
  var value :string
  # └─ Empty space between the name and the value when there is a value
  if code.len > 1 or body.kind == nkInfix:
    value.add " "
  # └─ Value for the {.define: name[sym]value.} when the value is not part of the body
  if code.len == 2:
    if code[Value].kind == nkPrefix and code[Value][AssignSymbol].strValue in ValidDefineAsignSymbols:
      value.add code[Value][AssignValue].strValue
  # └─ Value for the {.define: name[sym]value.} when the value is part of the body
  elif code.len == 1 and body.kind == nkInfix:
    if body[InfixSymbol].strValue in ValidDefineAsignSymbols:
      value.add body[InfixValue].strValue
    else: code.trigger PragmaError, &"Define[sym] error: Unsupported symbol for {{.define: name[sym]value.}}. Currently suppported list:  {ValidDefineAsignSymbols}"
  # └─ Value is empty when there is only {.define: name.}
  elif code.len == 1: value = ""
  else:
    code.trigger PragmaError, "Define[value] error: Only {.define:name.} and {.define: name[sym]value.} pragmas are currently supported."
  # Assign to the result
  result.c = fmt DefineTempl  # TODO: Should go to the header instead
#___________________
const PragmaOnceTempl = "{indent*Tab}#pragma once"
proc mincPragmaOnce (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Pragma
  result.h = fmt PragmaOnceTempl
#___________________
const KnownCPragmas = ["once"]
proc mincPragmaCPragma (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Pragma
  case code.:body
  of "once": result = mincPragmaOnce(code, indent, special)
  else: code.trigger PragmaError, &"Only {KnownCPragmas} pragmas are currently supported for {{.pragma: [name].}} ."
#___________________
const KnownPragmas = ["define", "error", "warning", "namespace", "emit", "pragma"]
proc mincPragma (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ## @descr
  ##  Codegen for all standalone pragmas
  ##  Context-specific pragmas are handled inside each section
  ensure code, Pragma
  case code.:name
  of "error"     : result = mincPragmaError(code, indent, special)
  of "warning"   : result = mincPragmaWarning(code, indent, special)
  of "emit"      : result = mincPragmaEmit(code, indent, special)
  of "namespace" : result = mincPragmaNamespace(code, indent, special)
  of "define"    : result = mincPragmaDefine(code, indent, special)
  of "pragma"    : result = mincPragmaCPragma(code, indent, special)
  else: code.trigger PragmaError, &"Only {KnownPragmas} pragmas are currently supported."


#_______________________________________
# @section Affixes
#_____________________________
const PrefixTempl = "{affix}{body}"
proc mincPrefix (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, nkPrefix
  let affix = ( code.:name ).renamed(code.kind, special)
  if Condition in special:
    let body = MinC(affixes.getPrefix(code, "body"), indent, special).c
    result.c = fmt PrefixTempl
  else: code.trigger ConditionError, &"Found an unmapped special case for mincPrefix:  {special}"
#___________________
const InfixTempl = "{left} {affix} {right}"
proc mincInfix (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, nkInfix
  let left  = MinC(affixes.getInfix(code, "left"),  indent, special).c
  let right = MinC(affixes.getInfix(code, "right"), indent, special).c
  let affix = ( code.:name ).renamed(code.kind, special)
  result.c = fmt InfixTempl


#______________________________________________________
# @section Discard
#_____________________________
const DiscardTempl = "{indent*Tab}(void){body};/*discard*/\n"
proc mincDiscard (
    code    : PNode;
    indent  : int            = 0;
    special : SpecialContext = Context.None;
  ) :CFilePair=
  ensure code, Discard
  let D = code[0]
  case D.kind
  of nkTupleConstr,nkPar:
    for arg in D:
      let body = MinC(arg, indent, special).c
      result.c.add fmt DiscardTempl
  else:
    let body = MinC(D, indent, special).c
    result.c = fmt DiscardTempl


#______________________________________________________
# @section Comments
#_____________________________
const NewLineTempl = "\n{indent*Tab}/// "
const CommentTempl = "{indent*Tab}/// {cmt}\n"
proc mincComment (code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair=
  ensure code, Comment
  let newl = fmt NewLineTempl
  let cmt  = code.strValue.replace("\n", newl)
  result.c = fmt CommentTempl


#______________________________________________________
# @section Source-to-Source Generator
#_____________________________
proc MinC *(code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair=
  if code == nil: return
  case code.kind
  # Recursive Cases
  of nkStmtList, nkTypeSection:
    for child in code   : result.add MinC( child, indent, special )
  # Intermediate cases
  # └─ Procedures
  of nkProcDef          : result = mincProcDef(code, indent, special)
  of nkFuncDef          : result = mincFuncDef(code, indent, special)
  # └─ Control flow
  of nkReturnStmt       : result = mincReturnStmt(code, indent, special)
  of nkWhileStmt        : result = mincWhile(code, indent, special)
  of nkIfStmt           : result = mincIf(code, indent, special)
  # └─ Variables
  of nkConstSection     : result = mincConstSection(code, indent, special)
  of nkLetSection       : result = mincLetSection(code, indent, special)
  of nkVarSection       : result = mincVarSection(code, indent, special)
  of nkAsgn             : result = mincAsgn(code, indent, special)
  of nkDiscardStmt      : result = mincDiscard(code, indent, special)
  # └─ Pragmas
  of nkPragma           : result = mincPragma(code, indent, special)
  # └─ Affixes
  of nkPrefix           : result = mincPrefix(code, indent, special)
  of nkInfix            : result = mincInfix(code, indent, special)
  # Terminal cases
  of nkEmpty            : result = CFilePair()
  of nim.SomeLit        : result = mincLiteral(code, indent, special)
  of nkCallStrLit       : result = mincLiteral(code, indent, special)
  of nkCall             : result = mincCall(code, indent, special)
  of nkCommand          : result = mincCommand(code, indent, special)
  of nkBracket          : result = mincBracket(code, indent, special)
  of nkIdent            : result = mincIdent(code, indent, special)
  of nkIncludeStmt      : result = mincInclude(code, indent, special)
  of nkCommentStmt      : result = mincComment(code, indent, special)
  of nim.SomeType       : result = mincType(code, indent, special)
  of nkTypeDef          : result = mincTypeDef(code, indent, special)
  # └─ Control flow
  of nkBreakStmt        : result = mincBreakStmt(code, indent, special)
  of nkContinueStmt     : result = mincContinueStmt(code, indent, special)
  else: code.err &"Translating {code.kind} to MinC is not supported yet."

