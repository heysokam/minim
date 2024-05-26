#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/strings
import nstd/paths
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
template `.:`*(code :PNode; prop :untyped) :string=
  let field = astToStr(prop)
  case code.kind
  of nkStmtList :
    var id = int.high
    try : id = field.parseInt
    except NodeAccessError: code.err "Tried to access a Statement List, but the keyword passed was not a number:  "&field
    strValue( statement.get(code, id) )
  of nkProcDef:
    var id       = int.high
    var property = field
    if "arg" in field:
      property = field.split("_")[0]
      try : id = field.split("_")[1].parseInt
      except NodeAccessError: code.err "Tried to access an Argument ID for a nkProcDef, but the keyword passed has an incorrect format:  "&field
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
proc mincInclude (code :PNode; indent :int= 0) :CFilePair=
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
proc mincFuncDef (code :PNode; indent :int= 0) :CFilePair=
  # __attribute__ ((pure))
  # write-only memory idea from herose (like GPU write-only mem)
  ensure code, Func
  code.trigger ProcError, "proc and func are identical in C"  # TODO : Sideffects checks
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
  let body = MinC(procs.get(code,"body"), indent+1).c # TODO: Could Header stuff happen inside a body ??
  # Generate the result
  result.h =
    if code.isPublic and name != "main" : fmt ProcProtoTempl
    else                                : ""
  result.c = fmt ProcDefTempl
#___________________
proc mincCall *(code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Call
  if code.kind == nkCallStrLit: return mincLiteral(code, indent, special)
  code.trigger CallError, &"Calls are not supported yet\n{code.renderTree}"


#_______________________________________
# @section Variables
#_____________________________
const VarDeclTempl = "{indent*Tab}extern {qual}{T} {name};\n"
const VarDefTempl  = "{indent*Tab}{qual}{T} {name}{eq}{value};\n"
#___________________
proc mincVariable (code :PNode; indent :int; kind :Kind) :CFilePair=
  const Type = 2
  # Error check
  ensure code, Const, Let, Var, msg="Tried to generate code for a variable, but its kind is incorrect"
  let typ  = vars.get(code, "type")
  let body = vars.get(code, "body")
  if typ.kind == nkEmpty: code.trigger VariableError,
    &"Declaring a variable without a type is forbidden. The illegal code is:\n{code.renderTree}\n"
  if kind == Const and body.kind == nkEmpty: code.trigger VariableError,
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
proc mincNil (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Nil
  result.c = NilValue
#___________________
proc mincChar (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Char
  result.c = &"'{code.strValue}'"
#___________________
proc mincFloat (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Float
  result.c = $code.floatVal
  case code.kind
  of nkFloat32Lit  : result.c.add "f"
  of nkFloat128Lit : result.c.add "L"
  else: discard
#___________________
proc mincInt (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, Int
  result.c = $code.intVal
#___________________
proc mincUInt (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
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
proc mincStr (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ensure code, StrKinds, "Called mincStr with an incorrect node kind."
  if code.isTripleStrLit : result.c = code.getTripleStrLit(indent, special)
  else                   : result.c = &"\"{code.strVal}\""
#___________________
proc mincLiteral (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
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
proc mincBracket (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
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
proc mincIdent (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  let val = code.strValue
  case special
  of Variable:
    if val == "_": result.c = "{0}" # This is definitely incorrect for the Object SpecialContext
  of None: result.c = val
  else: code.trigger IdentError, &"Found an unmapped kind for interpreting Indent code:  {special}"

#_______________________________________
# @section Pragmas
#_____________________________
proc mincPragmaWarning (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ## @descr Codegen for {.warning: "msg".} pragmas
  ensure code, Pragma
  let body = pragmas.get(code, "body")
  ensure body, Str, &"Only {{.warning: [[SomeString]].}} warning pragmas are currently supported."
  let msg = mincStr(body, indent, special).c
  result.c = &"{indent*Tab}#warning {msg}\n"
#___________________
proc mincPragmaError (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ## @descr Codegen for {.error: "msg".} pragmas
  ensure code, Pragma
  let body = pragmas.get(code, "body")
  ensure body, Str, &"Only {{.error: [[SomeString]].}} error pragmas are currently supported."
  let msg = mincStr(body, indent, special).c
  result.c = &"{indent*Tab}#error {msg}\n"
#_____________________________
proc mincPragmaEmit (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ## @descr Codegen for {.emit: "source.code".} pragmas
  ensure code, Pragma
  let body = pragmas.get(code, "body")
  ensure body, Str, &"Only {{.emit: [[SomeString]].}} emit pragmas are currently supported."
  result.c = &"{indent*Tab}{body.strValue}\n"
#___________________
const KnownPragmas = ["define", "error", "warning", "namespace", "emit"]
proc mincPragma (code :PNode; indent :int= 0; special :SpecialContext= None) :CFilePair=
  ## @descr
  ##  Codegen for all standalone pragmas
  ##  Context-specific pragmas are handled inside each section
  ensure code, Pragma
  case code.:name
  # of "define"    : result = mincPragmaDefine(code, indent, special)
  of "error"     : result = mincPragmaError(code, indent, special)
  of "warning"   : result = mincPragmaWarning(code, indent, special)
  # of "namespace" : result = mincPragmaNamespace(code, indent, special)
  of "emit"      : result = mincPragmaEmit(code, indent, special)
  else: code.trigger PragmaError, &"Only {KnownPragmas} pragmas are currently supported."



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
  # └─ Pragmas
  of nkPragma           : result = mincPragma(code, indent, special)
  # Terminal cases
  of nim.SomeLit        : result = mincLiteral(code, indent, special)
  of nim.SomeCall       : result = mincCall(code, indent, special)
  of nkBracket          : result = mincBracket(code, indent, special)
  of nkIdent            : result = mincIdent(code, indent, special)
  of nkEmpty            : result = CFilePair()
  of nkIncludeStmt      : result = mincInclude(code, indent)
  else: code.err &"Translating {code.kind} to MinC is not supported yet."

