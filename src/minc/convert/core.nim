#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# This file should be divided into separate modules.    |____________
# But the `MinC` function is recursive and called from many of them  |
# which creates a cyclic dependency :_(                              |
#____________________________________________________________________|
# std dependencies
import std/strutils
# *Slate dependencies
import slate/element/procdef
import slate/element/error
import slate/element/vars
import slate/element/incldef
import slate/element/calls
import slate/element/loops
import slate/element/types
# minc dependencies
import ../cfg
include ./fwdecl


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
proc mincVariable (entry :PNode; indent :int; kind :VarKind) :string=
  assert entry.kind in [nkConstDef, nkIdentDefs], entry.treeRepr
  let priv  = if vars.isPrivate(entry,indent): "static " else: ""
  let mut   = case kind
    of VarKind.Const : "" # constants become constexpr, they don't need type mutability
    of VarKind.Let   : "const "
    of VarKind.Var   : ""
  let typ = vars.getType(entry)
  var T   = typ.name
  if typ.isPtr: T &= "*"  # T = Type Name
  let name  = vars.getName(entry)
  # Value asignment
  let value = entry[^1] # Value Node
  if value.kind == nkEmpty and kind == VarKind.Const: # TODO : unbounded support
    raise newException(VariableCodegenError, &"Declaring a variable without a value is forbidden for `const`. The illegal code is:\n{entry.renderTree}")
  let val =
    if   value.kind == nkEmpty: ""
    elif value.kind == nkCall: mincCallRaw( value )
    elif value.kind in nkStrLit..nkTripleStrLit: &"\"{vars.getValue(entry)}\""
    else: vars.getValue(entry)
  let asign = if val == "": "" else: &" = {val}"
  # Apply to the result
  if not vars.isPrivate(entry,indent) and indent == 0:
    result.add &"{indent*Tab}extern {T}{name}; " # TODO: Write Extern decl to header
  let qualif = case kind
    of VarKind.Const : &"const/*comptime*/ {priv}"  # TODO:clang.18->   &"constexpr {priv}"
    of VarKind.Let   : &"{priv}"
    of VarKind.Var   : &"{priv}"
  result.add &"{indent*Tab}{qualif}{T} {mut}{name}{asign};\n"

proc mincConstSection (code :PNode; indent :int= 0) :string=
  assert code.kind == nkConstSection # Let and Const are identical in C
  for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Const)

proc mincLetSection (code :PNode; indent :int= 0) :string=
  assert code.kind == nkLetSection # Let and Const are identical in C
  for entry in code.sons: result.add mincVariable(entry,indent, VarKind.Let)

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
# Comments
#_____________________________
proc mincCommentStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkCommentStmt
  result.add &"{indent*Tab}/// {code.strValue}\n"


#______________________________________________________
# Control Flow
#_____________________________
proc mincDiscardStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkDiscardStmt
  for arg in code: result.add &"{indent*Tab}(void){arg.strValue}; //discard\n"


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
  result.add &"{indent*Tab}return {code[0].strValue};\n"
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
    assert branch[^1][0].len > 1, "Multi-condition if/elif statements are currently not supported"
    let condition :string=
      if   branch.kind == nkElifBranch : &"({mincGetCondition(branch)}) "
      elif branch.kind == nkElse       : ""
      else:""
    result.add &"{pfx}{condition}{{\n{body}{tab}}}"
  result.add "\n" # Finish with Newline on the last branch


#______________________________________________________
# Types
#_____________________________
proc mincTypeDef (code :PNode; indent :int= 0) :string=
  assert code.kind == nkTypeDef
  let name = &"{types.getName(code)}"
  let info = types.getType(code)
  let typ  =
    if info.isPtr : &"{info.name}*"
    else          : info.name
  let mut  = if info.isRead: " const" else: ""
  let body = ""
  result   = &"typedef {typ}{mut} {name}{body};\n"
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
  of nkReturnStmt       : result = mincReturnStmt(code, indent)
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
  of nkElifBranch       : result = mincElifBranch(code)
  #   Comments
  of nkCommentStmt      : result = mincCommentStmt(code, indent)
  #   Assignment
  of nkAsgn             : result = mincAsgn(code, indent)




  #____________________________________________________
  # TODO cases
  of nkIdent            : result = mincIdent(code)
  of nkSym              : result = mincSym(code)
  of nkType             : result = mincType(code)
  of nkComesFrom        : result = mincComesFrom(code)

  of nkDotCall          : result = mincDotCall(code)
  of nkCallStrLit       : result = mincCallStrLit(code)

  of nkInfix            : result = mincInfix(code)
  of nkPrefix           : result = mincPrefix(code)
  of nkPostfix          : result = mincPostfix(code)

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

  of nkFastAsgn         : result = mincFastAsgn(code)
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
  of nkPragma           : result = mincPragma(code)
  of nkPragmaBlock      : result = mincPragmaBlock(code)

  of nkWhenStmt         : result = mincWhenStmt(code)
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
  of nkBreakStmt        : result = mincBreakStmt(code)
  of nkContinueStmt     : result = mincContinueStmt(code)
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

  # Recursive Cases
  of nkStmtList:
    for child in code: result.add MinC( child, indent )


