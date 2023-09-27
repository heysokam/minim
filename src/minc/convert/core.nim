#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# This file should be divided into separate modules.    |____________
# But the `MinC` function is recursive and called from many of them  |
# which creates a cyclic dependency :_(                              |
#____________________________________________________________________|
# std dependencies
import std/strutils
import std/parseutils
# *Slate dependencies
import slate/element/procdef
import slate/element/error
import slate/element/vars
import slate/element/incldef
import slate/element/calls
import slate/element/loops
import slate/element/types
import slate/element/affixes
# minc dependencies
import ../cfg
include ./fwdecl


#______________________________________________________
# General tools
#_____________________________
proc mincGetValueRaw *(code :PNode) :string=
  assert code.kind in [nkEmpty, nkIdent, nkBracketExpr] or code.kind in nkCharLit..nkTripleStrLit
  if   code.kind == nkEmpty       : ""
  elif code.kind == nkBracketExpr : &"{code[0].strValue}[{code[1].strValue}]"
  else                            : code.strValue


#______________________________________________________
# Affixes
#_____________________________
type AffixCodegenError = object of CatchableError
#_____________________________
proc mincPrefix (code :PNode; indent :int= 0; raw :bool= false) :string=
  assert code.kind == nkPrefix
  let data = affixes.getPrefix(code)
  if not raw: result.add indent*Tab
  case data.fix
  of "++","--":
    discard # Known Prefixes. Do nothing, the line after this caseof will add their code
  of "+", "-", "~":
    assert raw, &"Found a prefix that cannot be used in a standalone line. The incorrect code is:\n{code.renderTree}"
  of "&", "!", "*": raise newException(AffixCodegenError,
    &"Found a C prefix that cannot be used in MinC. The incorrect code is:\n{code.renderTree}")
  result.add &"{data.fix}{data.right}"
  if not raw: result.add ";\n"
#_____________________________
proc mincInfix (code :PNode; indent :int= 0; raw :bool= false) :string=
  assert code.kind == nkInfix
  var data = affixes.getInfix(code)
  if not raw: result.add indent*Tab
  case data.fix
  of "++","--":
    if data.right == "": raise newException(AffixCodegenError,
      &"Using ++ or -- as postfixes is currently not possible. The default Nim parser interprets them as infix, and breaks the code written afterwards. Please convert them to prefixes. The code that triggered this is:\n{code.renderTree}\n")
  of "+=", "-=", "/=", "*=", "%=", "&=", "|=", "^=", "<<=", ">>=":
    # Known Infixes. Do nothing, the line after this caseof will add their code
    discard
  of "+", "-", "*", "/", "%", "&", "|", "^", ">>", "<<",
     "and", "or", "xor", "shr", "shl", "div", "mod":
    # Known infixes that cannot be standalone
    assert raw, &"Found an infix that cannot be used in a standalone line. The incorrect code is:\n{code.renderTree}"
  of "in", "notin", "is", "isnot", "of", "as", "from":
    assert false, &"Found a nim infix keyword that cannot be used in MinC. The incorrect code is:\n{code.renderTree}"
  of "not":
    assert false, &"Found a nim infix keyword that can only be used as prefix. The incorrect code is:\n{code.renderTree}"
  else: raise newException(AffixCodegenError, &"Found an unknown infix. The code that contains it is:\n{code.renderTree}\n")
  # Remap nim keywords to C
  case data.fix
  of "and" : data.fix = "&"
  of "or"  : data.fix = "|"
  of "xor" : data.fix = "^"
  of "shl" : data.fix = "<<"
  of "shr" : data.fix = ">>"
  of "div" : data.fix = "/"  # TODO: Check that the types used are integers
  of "mod" : data.fix = "%"
  else:discard
  # Add the the code as left fix right
  result.add &"{data.left} {data.fix} {data.right}"
  if not raw: result.add ";\n"
#_____________________________
proc mincPostfix (code :PNode; indent :int= 0; raw :bool= false) :string=
  ## WARNING: Nim parser interprets no postfixes, other than `*` for visibility
  ## https://nim-lang.org/docs/macros.html#callsslashexpressions-postfix-operator-call
  assert code.kind == nkPostfix
  case affixes.getPostfix(code).fix
  of "*": raise newException(AffixCodegenError,
    &"Using * as a postfix is forbidden in MinC. The code that triggered this error is:\n{code.renderTree}")
  else: raise newException(AffixCodegenError, "Unreachable case found in mincPostfix.\n{code.treeRepr}\n{code.renderTree}")


#______________________________________________________
# Procedures
#_____________________________
proc mincProcDefGetArgs  (code :PNode) :string=
  ## Returns the code for all arguments of the given ProcDef node.
  assert code.kind == nkProcDef
  let params = code[procdef.Elem.Args]
  assert params.kind == nkFormalParams
  let argc = procdef.getArgCount(code)
  if argc == 0: return "void"  # Explicit fill with void for no arguments
  # Find all arguments
  for arg in procdef.args(code): # For every individual argument -> args can be single or grouped arguments. this expands them
    let mut  = if not arg.typ.isMut : " const"            else: ""  # Add const by default, when arg is not marked as var
    let typ  = if arg.typ.isPtr     : &"{arg.typ.name}*"  else: arg.typ.name
    let sep  = if arg.last          : ""                  else: ", "
    result.add( fmt "{typ}{mut} {arg.name}{sep}" )
#_____________________________
proc mincFuncDef  (code :PNode; indent :int= 0) :string=
  assert false, "proc and func are identical in C"  # TODO : Sideffects checks
  # __attribute__ ((pure))
  # write-only memory idea from herose (like GPU write-only mem)
#_____________________________
proc mincProcDefGetBody  (code :PNode; indent :int= 1) :string=
  ## Returns the code for the body of the given ProcDef node.
  # note: stored in core because it calls MinC
  result.add "\n"
  result.add MinC(code[procdef.Elem.Body], indent)
#_____________________________
proc mincProcDef  (code :PNode; indent :int= 0) :string=
  ## Converts a nkProcDef into the Min C Language
  # note: stored in core because of MinC in getbody
  assert code.kind == nkProcDef
  var pragma :string
  if procdef.hasPragma(code):
    let prag = procdef.getPragma(code)
    if prag[0].kind == nkIdent:
      pragma = case prag[0].strValue
      of "noreturn_GNU": "__attribute__((noreturn)) "
      of "noreturn_C11": "_Noreturn "
      of "noreturn"    : "[[noreturn]] "
      else:""
  let priv = if procdef.isPrivate(code, indent): "static " else: ""
  result = fmt "{pragma}{priv}{procdef.getRetT(code)} {procdef.getName(code)} ({mincProcDefGetArgs(code)}) {{{mincProcDefGetBody(code)}}}\n"


#______________________________________________________
# Function Calls
#_____________________________
# const CallArgTmpl = "{calls.getArgs(arg.node)} {calls.getArgName(arg.node)}{sep}"
proc mincCallGetArgs (code :PNode) :string=
  ## Returns the code for all arguments of the given ProcDef node.
  assert code.kind in [nkCall, nkCommand]
  if calls.getArgCount(code) == 0: return
  for arg in calls.args(code):
    if arg.node.kind in nkStrLit..nkTripleStrLit:
      let str = arg.node.strValue.replace("\n", "\\n")
      result.add &"\"{str}\""
    elif arg.node.kind == nkNilLit: result.add "NULL"
    else: result.add arg.node.strValue
    result.add( if arg.last: "" else: ", " )
#_____________________________
proc mincCallRaw (code :PNode) :string=
  assert code.kind in [nkCall, nkCommand]
  result = &"{calls.getName(code,0)}({mincCallGetArgs(code)})"
#_____________________________
proc mincCall (code :PNode; indent :int= 0) :string=
  assert code.kind in [nkCall, nkCommand]
  result.add &"{indent*Tab}{mincCallRaw(code)};\n"
#_____________________________
proc mincCommand (code :PNode; indent :int= 0) :string=
  assert code.kind in [nkCommand]
  mincCall(code,indent)  # Command and Call are identical in C


#______________________________________________________
# Variables
#_____________________________
type VariableCodegenError = object of CatchableError
type VarKind {.pure.}= enum Const, Let, Var
#_____________________________
proc mincVariable (entry :PNode; indent :int; kind :VarKind) :string=
  assert entry.kind in [nkConstDef, nkIdentDefs], entry.treeRepr
  let priv  = if vars.isPrivate(entry,indent): "static " else: ""
  let mut   = case kind
    of VarKind.Const : "" # constants become constexpr, they don't need type mutability
    of VarKind.Let   : "const "
    of VarKind.Var   : ""
  if entry[^2].kind == nkEmpty: raise newException(VariableCodegenError,
    &"Declaring a variable without a type is forbidden. The illegal code is:\n{entry.renderTree}\n")
  let typ = vars.getType(entry)
  var T   = typ.name
  # if typ.isArr and typ.arrSize == "_": raise newException(VariableCodegenError,  # TODO: When -Wunsafe-buffer-usage becomes stable
  #   &"MinC uses the Safe Buffers programming model exclusively. Declaring arrays of an unknown size is disabled. The illegal code is:\n{entry.renderTree}\n")
  var arr :string=
    if   typ.isArr and typ.arrSize == "_": "[]"
    elif typ.isArr and typ.arrSize != "_": &"[{typ.arrSize}]"
    else:""
  assert not (typ.isArr and arr == ""), "Found an array type, but its code has not been correctly generated.\n{entry.treeRepr}\n{entry.renderTree}\n"
  if typ.isPtr: T &= "*"  # T = Type Name
  let name  = vars.getName(entry)
  # Value asignment
  let value = entry[^1] # Value Node
  if value.kind == nkEmpty and kind == VarKind.Const: raise newException(VariableCodegenError, # TODO : unbounded support
    &"Declaring a variable without a value is forbidden for `const`. The illegal code is:\n{entry.renderTree}")
  let tab1 = (indent+1)*Tab
  let val  =
    if   value.kind == nkEmpty             : ""
    elif value.kind == nkCall              : " " & mincCallRaw( value )
    elif value.kind in nkStrLit..nkRStrLit : &" \"{vars.getValue(entry)}\""
    elif value.kind == nkTripleStrLit      :
      "\n" & tab1 & "\"" &
      vars.getValue(entry)
      .replace( "\n" , "\\n\"\n" & tab1 & "\"" ) &  # turn every \n character into \\n"\nTAB"  to use C's "" concatenation
      "\""
    elif value.kind == nkCharLit     : &" '{vars.getValue(entry).parseInt().char}'"
    elif typ.isArr                   : &" {{ {vars.getValue(entry).split(\" \").join(\", \")} }}"
    elif value.kind == nkBracketExpr : &" {mincGetValueRaw(value)}"
    else: " " & vars.getValue(entry)
  let asign = if val == "": "" else: &" ={val}"
  # Apply to the result
  if not vars.isPrivate(entry,indent) and indent == 0:
    result.add &"{indent*Tab}extern {T}{name}{arr}; " # TODO: Write Extern decl to header
  let qualif = case kind
    of VarKind.Const : &"const/*comptime*/ {priv}"  # TODO:clang.18->   &"constexpr {priv}"
    of VarKind.Let   : &"{priv}"
    of VarKind.Var   : &"{priv}"
  result.add &"{indent*Tab}{qualif}{T} {mut}{name}{arr}{asign};\n"
#_____________________________
proc mincConstSection (code :PNode; indent :int= 0) :string=
  assert code.kind == nkConstSection # Let and Const are identical in C
  for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Const)
#_____________________________
proc mincLetSection (code :PNode; indent :int= 0) :string=
  assert code.kind == nkLetSection # Let and Const are identical in C
  for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Let)
#_____________________________
proc mincVarSection (code :PNode; indent :int= 0) :string=
  assert code.kind == nkVarSection
  for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Var)


#______________________________________________________
# Modules
#_____________________________
proc mincIncludeStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkIncludeStmt
  if indent > 0: raise newException(IncludeError, &"Include statements are only allowed at the top level.\nThe incorrect code is:\n{code.renderTree}\n")
  result.add &"#include {incldef.getModule(code)}\n"


#______________________________________________________
# Pragmas
#_____________________________
type PragmaCodegenError = object of CatchableError
proc mincPragmaDefine (code :PNode; indent :int= 0) :string=
  assert code.kind == nkPragma
  assert code[0].len == 2, &"Only {{.define:symbol.}} pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}"
  result.add &"{indent*Tab}#define {code[0][1].strValue}\n"
#_____________________________
proc mincPragmaError (code :PNode; indent :int= 0) :string=
  assert code.kind == nkPragma
  let data = code[0] # The data is inside an nkExprColonExpr node
  assert data.kind == nkExprColonExpr and data.len == 2 and data[1].kind == nkStrLit, &"Only {{.error:\"msg\".}} error pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}"
  result.add &"{indent*Tab}#error {data[1].strValue}\n"
#_____________________________
proc mincPragmaWarning (code :PNode; indent :int= 0) :string=
  assert code.kind == nkPragma
  let data = code[0] # The data is inside an nkExprColonExpr node
  assert data.kind == nkExprColonExpr and data.len == 2 and data[1].kind == nkStrLit, &"Only {{.warning:\"msg\".}} warning pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}"
  result.add &"{indent*Tab}#warning {data[1].strValue}\n"
#_____________________________
proc mincPragma (code :PNode; indent :int= 0) :string=
  ## Codegen for standalone pragmas
  ## Context-specific pragmas are handled inside each section
  assert code.kind == nkPragma
  assert code[0].kind == nkExprColonExpr and code[0].len == 2, &"Only pragmas with the shape {{.key:val.}} are currently supported.\nThe incorrect code is:\n{code.renderTree}"
  let key = code[0][0].strValue
  case key
  of "define"  : result = mincPragmaDefine(code,indent)
  of "error"   : result = mincPragmaError(code,indent)
  of "warning" : result = mincPragmaWarning(code,indent)
  else: raise newException(PragmaCodegenError, &"Only {{.define:symbol.}} pragmas are currently supported.\nThe incorrect code is:\n{code.renderTree}")


#______________________________________________________
# Conditions
#_____________________________
proc mincGetCondition (code :PNode) :string=
  # TODO: Unconfuse this total mess. Remove hardcoded numbers. Should be names and a loop.
  if code[0].kind == nkPrefix:
    result.add code[0][0].strValue.replace("not","!")
    if code[0][1].kind == nkCall: result.add mincCallRaw( code[0][1] )
    else:                         result.add code[0][1].strValue
  else: assert false, &"Non-Prefix conditions are currently supported\n{code.renderTree}"

#______________________________________________________
# Control Flow
#_____________________________
proc mincReturnStmt (code :PNode; indent :int= 1) :string=
  assert code.kind == nkReturnStmt
  assert indent != 0, "Return statements cannot exist at the top level in C.\n" & code.renderTree
  result.add &"{indent*Tab}return {mincGetValueRaw(code[0])};\n"
#_____________________________
proc mincContinueStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkContinueStmt
  assert indent != 0, "Continue statements cannot exist at the top level in C.\n" & code.renderTree
  result.add &"{indent*Tab}continue;\n"
#_____________________________
proc mincBreakStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkBreakStmt
  assert indent != 0, "Break statements cannot exist at the top level in C.\n" & code.renderTree
  result.add &"{indent*Tab}break;\n"
#_____________________________
proc mincWhileStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkWhileStmt
  result.add &"{indent*Tab}while ({mincGetCondition(code)}) {{\n"
  result.add MinC( code[^1], indent+1 )
  result.add &"{indent*Tab}}}\n"
#_____________________________
proc mincIfStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkIfStmt
  let tab :string= indent*Tab
  for id,branch in code.pairs:
    let body = &"{MinC(branch[^1], indent+1)}"
    let pfx :string=
      if   branch.kind == nkElifBranch and id == 0 : &"{tab}if "
      elif branch.kind == nkElifBranch             : " else if "
      elif branch.kind == nkElse                   : " else "
      else:""
    assert pfx != "", "Unknown branch kind in minc.IfStmt"
    assert branch[^1][0].len <= 2, "Multi-condition if/elif statements are currently not supported"
    let condition :string=
      if   branch.kind == nkElifBranch : &"({mincGetCondition(branch)}) "
      elif branch.kind == nkElse       : ""
      else:""
    result.add &"{pfx}{condition}{{\n{body}{tab}}}"
  result.add "\n" # Finish with Newline on the last branch
#_____________________________
proc mincWhenStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkWhenStmt
  let tab :string= indent*Tab
  for id,branch in code.pairs:
    # Get the macro prefix
    let pfx :string=
      if   branch.kind == nkElifBranch and id == 0 : &"{tab}#if "
      elif branch.kind == nkElifBranch             : &"{tab}#elif "
      elif branch.kind == nkElse                   : &"{tab}#else "
      else:""
    assert pfx != "", "Unknown branch kind in minc.WhenStmt"
    # Get the condition
    assert branch[^2].kind == nkIdent or branch[^2].len <= 2, "Multi-condition when/elif/else statements are currently not supported"
    let cond = branch[0]
    assert cond.kind == nkPrefix or cond.kind == nkIdent, &"Only Prefix or Single conditions are currently supported\n{code.renderTree}"
    var condition :string
    if cond.kind == nkIdent: # single condition case. Add its content to condition
      condition.add cond.strValue
    elif cond[0].kind == nkIdent and cond[0].strValue == "not":
      condition.add "!"
    # TODO: This is broken for most. Only works for `when defined(thing)`
    if cond.kind == nkIdent: discard # single condition case. Skip searching for subnodes
    elif cond[1].kind == nkCall and cond[1][0].strValue == "defined":
      condition.add &"defined({cond[1][1].strValue})"
    elif cond[1].kind == nkIdent:
      condition.add cond[1].strValue
    else: assert false, &"Unknown when condition in:\n{code.renderTree}"
    # Get the body code from the Stmt section
    let body = &"{MinC(branch[^1], indent+1)}"
    # Add to the result
    result.add &"{pfx}{condition}\n{body}"
  result.add &"{tab}#endif\n"


#______________________________________________________
# Types
#_____________________________
const KnownMultiwordPrefixes = ["unsigned", "signed", "long", "short"]
proc mincTypeDef (code :PNode; indent :int= 0) :string=
  assert code.kind == nkTypeDef
  let name = &"{types.getName(code)}"
  let info = types.getType(code, KnownMultiwordPrefixes)
  let mut  = if info.isRead: " const" else: ""
  var typ  = info.name & mut
  if info.isPtr: typ &= "*"
  let body = ""
  result   = &"typedef {typ} {name}{body};\n"
#_____________________________
proc mincTypeSection (code :PNode; indent :int= 0) :string=
  assert code.kind == nkTypeSection
  for entry in code: result.add mincTypeDef(entry, indent)


#______________________________________________________
# Assignment
#_____________________________
proc mincAsgn (code :PNode; indent :int= 0) :string=
  assert code.kind == nkAsgn
  result = &"{indent*Tab}{code[0].strValue} = {code[^1].strValue};\n"


#______________________________________________________
# Comments
#_____________________________
proc mincCommentStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkCommentStmt
  result.add &"{indent*Tab}/// {code.strValue}\n"


#______________________________________________________
# Other tools
#_____________________________
proc mincDiscardStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkDiscardStmt
  for arg in code: result.add &"{indent*Tab}(void){arg.strValue}; //discard\n"


#______________________________________________________
# Source-to-Source Generator
#_____________________________
proc MinC *(code :PNode; indent :int= 0) :string=
  ## Node selector function. Sends the node into the relevant codegen function.
  # Base Cases
  if code == nil: return
  case code.kind
  of nkNone             : result = mincNone(code)
  of nkEmpty            : result = mincEmpty(code)

  # Process this node
  #   Modules
  of nkIncludeStmt      : result = mincIncludeStmt(code, indent)
  #   Procedures
  of nkProcDef          : result = mincProcDef(code, indent)
  of nkFuncDef          : result = mincProcDef(code, indent)
  #   Other Tools
  of nkDiscardStmt      : result = mincDiscardStmt(code, indent)
  #   Function calls
  of nkCommand          : result = mincCommand(code, indent)
  of nkCall             : result = mincCall(code, indent)
  # Types
  of nkTypeSection      : result = mincTypeSection(code, indent)
  of nkTypeDef          : result = mincTypeDef(code, indent) # Accessed by nkTypeSection
  #   Variables
  of nkConstSection     : result = mincConstSection(code, indent)
  of nkLetSection       : result = mincLetSection(code, indent)
  of nkVarSection       : result = mincVarSection(code, indent)
  #   Loops
  of nkWhileStmt        : result = mincWhileStmt(code, indent)
  #   Conditionals
  of nkIfStmt           : result = mincIfStmt(code, indent)
  of nkWhenStmt         : result = mincWhenStmt(code, indent)
  of nkElifBranch       : result = mincElifBranch(code)
  #   Comments
  of nkCommentStmt      : result = mincCommentStmt(code, indent)
  #   Assignment
  of nkAsgn             : result = mincAsgn(code, indent)
  #   Control flow
  of nkReturnStmt       : result = mincReturnStmt(code, indent)
  of nkBreakStmt        : result = mincBreakStmt(code, indent)
  of nkContinueStmt     : result = mincContinueStmt(code, indent)
  #   Pragmas
  of nkPragma           : result = mincPragma(code, indent)
  #   Pre-In-Post.fix
  of nkInfix            : result = mincInfix(code, indent)
  of nkPrefix           : result = mincPrefix(code, indent)
  of nkPostfix          : result = mincPostfix(code, indent)




  #____________________________________________________
  # TODO cases
  of nkIdent            : result = mincIdent(code)
  of nkSym              : result = mincSym(code)
  of nkType             : result = mincType(code)
  of nkComesFrom        : result = mincComesFrom(code)

  of nkDotCall          : result = mincDotCall(code)
  of nkCallStrLit       : result = mincCallStrLit(code)

  of nkHiddenCallConv   : result = mincHiddenCallConv(code)
  of nkExprEqExpr       : result = mincExprEqExpr(code)
  of nkExprColonExpr    : result = mincExprColonExpr(code)
  of nkVarTuple         : result = mincVarTuple(code)
  of nkPar              : result = mincPar(code)
  of nkObjConstr        : result = mincObjConstr(code)
  of nkCurly            : result = mincCurly(code)
  of nkCurlyExpr        : result = mincCurlyExpr(code)
  of nkBracket          : result = mincBracket(code)
  of nkBracketExpr      : result = mincBracketExpr(code)
  of nkPragmaExpr       : result = mincPragmaExpr(code)
  of nkRange            : result = mincRange(code)
  of nkDotExpr          : result = mincDotExpr(code)
  of nkCheckedFieldExpr : result = mincCheckedFieldExpr(code)
  of nkDerefExpr        : result = mincDerefExpr(code)
  of nkIfExpr           : result = mincIfExpr(code)
  of nkElifExpr         : result = mincElifExpr(code)
  of nkElseExpr         : result = mincElseExpr(code)
  of nkLambda           : result = mincLambda(code)
  of nkDo               : result = mincDo(code)
  of nkAccQuoted        : result = mincAccQuoted(code)
  of nkTableConstr      : result = mincTableConstr(code)
  of nkBind             : result = mincBind(code)
  of nkClosedSymChoice  : result = mincClosedSymChoice(code)
  of nkOpenSymChoice    : result = mincOpenSymChoice(code)
  of nkHiddenStdConv    : result = mincHiddenStdConv(code)
  of nkHiddenSubConv    : result = mincHiddenSubConv(code)
  of nkConv             : result = mincConv(code)
  of nkCast             : result = mincCast(code)
  of nkStaticExpr       : result = mincStaticExpr(code)
  of nkAddr             : result = mincAddr(code)
  of nkHiddenAddr       : result = mincHiddenAddr(code)
  of nkHiddenDeref      : result = mincHiddenDeref(code)
  of nkObjDownConv      : result = mincObjDownConv(code)
  of nkObjUpConv        : result = mincObjUpConv(code)
  of nkChckRangeF       : result = mincChckRangeF(code)
  of nkChckRange64      : result = mincChckRange64(code)
  of nkChckRange        : result = mincChckRange(code)
  of nkStringToCString  : result = mincStringToCString(code)
  of nkCStringToString  : result = mincCStringToString(code)

  of nkGenericParams    : result = mincGenericParams(code)
  of nkFormalParams     : result = mincFormalParams(code)
  of nkOfInherit        : result = mincOfInherit(code)
  of nkImportAs         : result = mincImportAs(code)
  of nkMethodDef        : result = mincMethodDef(code)
  of nkConverterDef     : result = mincConverterDef(code)
  of nkMacroDef         : result = mincMacroDef(code)
  of nkTemplateDef      : result = mincTemplateDef(code)
  of nkIteratorDef      : result = mincIteratorDef(code)
  of nkExceptBranch     : result = mincExceptBranch(code)
  of nkAsmStmt          : result = mincAsmStmt(code)
  of nkPragmaBlock      : result = mincPragmaBlock(code)

  of nkCaseStmt         : result = mincCaseStmt(code)
  of nkOfBranch         : result = mincOfBranch(code)
  of nkElse             : result = mincElse(code)

  of nkForStmt          : result = mincForStmt(code)
  of nkParForStmt       : result = mincParForStmt(code)

  of nkYieldStmt        : result = mincYieldStmt(code)
  of nkDefer            : result = mincDefer(code)
  of nkTryStmt          : result = mincTryStmt(code)
  of nkFinally          : result = mincFinally(code)
  of nkRaiseStmt        : result = mincRaiseStmt(code)
  of nkBlockStmt        : result = mincBlockStmt(code)
  of nkStaticStmt       : result = mincStaticStmt(code)

  of nkImportStmt       : result = mincImportStmt(code)
  of nkImportExceptStmt : result = mincImportExceptStmt(code)
  of nkExportStmt       : result = mincExportStmt(code)
  of nkExportExceptStmt : result = mincExportExceptStmt(code)
  of nkFromStmt         : result = mincFromStmt(code)

  of nkBindStmt         : result = mincBindStmt(code)
  of nkMixinStmt        : result = mincMixinStmt(code)
  of nkUsingStmt        : result = mincUsingStmt(code)
  of nkStmtListExpr     : result = mincStmtListExpr(code)
  of nkBlockExpr        : result = mincBlockExpr(code)
  of nkStmtListType     : result = mincStmtListType(code)
  of nkBlockType        : result = mincBlockType(code)
  of nkWith             : result = mincWith(code)
  of nkWithout          : result = mincWithout(code)
  of nkTypeOfExpr       : result = mincTypeOfExpr(code)
  of nkObjectTy         : result = mincObjectTy(code)
  of nkTupleTy          : result = mincTupleTy(code)
  of nkTupleClassTy     : result = mincTupleClassTy(code)
  of nkTypeClassTy      : result = mincTypeClassTy(code)
  of nkStaticTy         : result = mincStaticTy(code)
  of nkRecList          : result = mincRecList(code)
  of nkRecCase          : result = mincRecCase(code)
  of nkRecWhen          : result = mincRecWhen(code)
  of nkRefTy            : result = mincRefTy(code)
  of nkPtrTy            : result = mincPtrTy(code)
  of nkVarTy            : result = mincVarTy(code)
  of nkConstTy          : result = mincConstTy(code)
  of nkOutTy            : result = mincOutTy(code)
  of nkDistinctTy       : result = mincDistinctTy(code)
  of nkProcTy           : result = mincProcTy(code)
  of nkIteratorTy       : result = mincIteratorTy(code)
  of nkSinkAsgn         : result = mincSinkAsgn(code)
  of nkEnumTy           : result = mincEnumTy(code)
  of nkEnumFieldDef     : result = mincEnumFieldDef(code)
  of nkArgList          : result = mincArgList(code)
  of nkPattern          : result = mincPattern(code)
  of nkHiddenTryStmt    : result = mincHiddenTryStmt(code)
  of nkClosure          : result = mincClosure(code)
  of nkGotoState        : result = mincGotoState(code)
  of nkState            : result = mincState(code)
  of nkBreakState       : result = mincBreakState(code)
  of nkTupleConstr      : result = mincTupleConstr(code)
  of nkError            : result = mincError(code)
  of nkModuleRef        : result = mincModuleRef(code)      # for .rod file support: A (moduleId, itemId) pair
  of nkReplayAction     : result = mincReplayAction(code)   # for .rod file support: A replay action
  of nkNilRodNode       : result = mincNilRodNode(code)     # for .rod file support: a 'nil' PNode

  # Unreachable
  of nkConstDef         : result = mincConstDef(code)   # Accessed by nkConstSection
  of nkIdentDefs        : result = mincIdentDefs(code)  # Accessed by nkLetSection and nkVarSection
  of nkCharLit          : result = mincCharLit(code)
  of nkIntLit           : result = mincIntLit(code)
  of nkInt8Lit          : result = mincInt8Lit(code)
  of nkInt16Lit         : result = mincInt16Lit(code)
  of nkInt32Lit         : result = mincInt32Lit(code)
  of nkInt64Lit         : result = mincInt64Lit(code)
  of nkUIntLit          : result = mincUIntLit(code)
  of nkUInt8Lit         : result = mincUInt8Lit(code)
  of nkUInt16Lit        : result = mincUInt16Lit(code)
  of nkUInt32Lit        : result = mincUInt32Lit(code)
  of nkUInt64Lit        : result = mincUInt64Lit(code)
  of nkFloatLit         : result = mincFloatLit(code)
  of nkFloat32Lit       : result = mincFloat32Lit(code)
  of nkFloat64Lit       : result = mincFloat64Lit(code)
  of nkFloat128Lit      : result = mincFloat128Lit(code)
  of nkStrLit           : result = mincStrLit(code)
  of nkRStrLit          : result = mincRStrLit(code)
  of nkTripleStrLit     : result = mincTripleStrLit(code)
  of nkNilLit           : result = mincNilLit(code)
  # Not needed
  of nkFastAsgn         : result = mincFastAsgn(code)

  # Recursive Cases
  of nkStmtList:
    for child in code: result.add MinC( child, indent )


