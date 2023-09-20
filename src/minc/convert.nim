#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/paths
import std/strformat
import std/strutils
# *Slate dependencies
import slate/format
import slate/element/error
import slate/element/procdef
import slate/element/vars
import slate/element/incldef
import slate/element/calls
# minc dependencies
include ./fwdecl

const Tab = "  "

proc report *(code :PNode) :void=
  debugEcho code.treeRepr
  debugEcho code.renderTree,"\n"


#______________________________________________________
# Procedure Definition
#_____________________________
const ProcDefTmpl    * = "{priv}{procdef.getRetT(code)} {procdef.getName(code)} ({mincProcDefGetArgs(code)}) {{{mincProcDefGetBody(code)}}}"
const ProcDefArgTmpl * = "{procdef.getArgT(arg.node)} {procdef.getArgName(arg.node)}{sep}"

proc mincProcDefGetArgs *(code :PNode) :string=
  ## Returns the code for all arguments of the given ProcDef node.
  assert code.kind == nkProcDef
  let params = code[procdef.Elem.Args]
  assert params.kind == nkFormalParams
  if procdef.getArgCount(code) == 0: return "void"
  for arg in procdef.args(code):
    let sep = if not arg.last: ", " else: ""
    result.add( fmt ProcDefArgTmpl )

proc mincProcDefGetBody *(code :PNode; indent :int= 1) :string=
  ## Returns the code for the body of the given ProcDef node.
  result.add "\n"
  result.add MinC(code[procdef.Elem.Body], indent)

proc mincFuncDef (code :PNode; indent :int= 0) :string=
  assert false, "proc and func are identical in C"  # TODO : Sideffects error checking

proc mincProcDef (code :PNode; indent :int= 0) :string=
  ## TODO : Converts a nkProcDef into the Min C Language
  assert code.kind == nkProcDef
  let priv = if procdef.isPrivate(code, indent): "static " else: ""
  result = fmt ProcDefTmpl


#______________________________________________________
# Return Statement
#_____________________________
proc mincReturnStmt (code :PNode; indent :int= 1) :string=
  assert indent != 0
  assert code.kind == nkReturnStmt
  result.add &"{indent*Tab}return {code[0].strValue};\n"


#______________________________________________________
# Variables
#_____________________________
proc mincConstSection (code :PNode; indent :int= 0) :string=
  assert code.kind in [nkConstSection, nkLetSection] # Let and Const are identical in C
  for entry in code.sons:
    let priv = if vars.isPrivate(entry,indent): "static " else: ""
    if not vars.isPrivate(entry,indent): result.add &"{indent*Tab}extern const {vars.getType(entry)} {vars.getName(entry)};\n"
    result.add &"{indent*Tab}{priv}const {vars.getType(entry)} {vars.getName(entry)} = {vars.getValue(entry)};\n"

proc mincLetSection (code :PNode; indent :int= 0) :string=
  assert false, "Let and Const are identical in C"

proc mincIncludeStmt (code :PNode; indent :int= 0) :string=
  assert code.kind == nkIncludeStmt
  if indent > 0: raise newException(IncludeError, &"Include statements are only allowed at the top level.\nThe incorrect code is:\n{code.renderTree}\n")
  result.add &"#include {incldef.getModule(code)}\n"


#______________________________________________________
# Function Calls
#_____________________________
const CallArgTmpl * = "{calls.getArgs(arg.node)} {calls.getArgName(arg.node)}{sep}"
proc mincCallGetArgs *(code :PNode) :string=
  ## Returns the code for all arguments of the given ProcDef node.
  assert code.kind in [nkCall, nkCommand]
  if calls.getArgCount(code) == 0: return
  for arg in calls.args(code):
    let str = arg.node.strValue.replace("\n", "\\n")
    if arg.node.kind in nkStrLit..nkTripleStrLit: result.add &"\"{str}\""
    else: result.add arg.node.strValue
    result.add( if arg.last: "" else: ", " )

proc mincCall (code :PNode; indent :int= 0) :string=
  assert code.kind in [nkCall, nkCommand]
  result.add &"{indent*Tab}{calls.getName(code, indent)}({mincCallGetArgs(code)});\n"

proc mincCommand (code :PNode; indent :int= 0) :string=
  assert false, "Command and Call are identical in C"


#______________________________________________________
# Source-to-Source Generator
#_____________________________
proc MinC (code :PNode; indent :int= 0) :string=
  ## Node selector function. Sends the node into the relevant codegen function.
  # Base Cases
  if code == nil: return
  case code.kind
  of nkNone             : result = mincNone(code)
  of nkEmpty            : result = mincEmpty(code)

  # Process this node
  of nkProcDef          : result = mincProcDef(code, indent)
  of nkFuncDef          : result = mincProcDef(code, indent)
  of nkReturnStmt       : result = mincReturnStmt(code, indent)
  of nkConstSection     : result = mincConstSection(code, indent)
  of nkLetSection       : result = mincConstSection(code, indent)
  of nkIncludeStmt      : result = mincIncludeStmt(code, indent)
  of nkCommand          : result = mincCommand(code, indent)
  of nkCall             : result = mincCall(code, indent)

  #____________________________________________________
  # TODO cases
  of nkVarSection       : result = mincVarSection(code)

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
  of nkAsgn             : result = mincAsgn(code)
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
  of nkOfBranch         : result = mincOfBranch(code)
  of nkElifBranch       : result = mincElifBranch(code)
  of nkExceptBranch     : result = mincExceptBranch(code)
  of nkElse             : result = mincElse(code)
  of nkAsmStmt          : result = mincAsmStmt(code)
  of nkPragma           : result = mincPragma(code)
  of nkPragmaBlock      : result = mincPragmaBlock(code)
  of nkIfStmt           : result = mincIfStmt(code)
  of nkWhenStmt         : result = mincWhenStmt(code)
  of nkForStmt          : result = mincForStmt(code)
  of nkParForStmt       : result = mincParForStmt(code)
  of nkWhileStmt        : result = mincWhileStmt(code)
  of nkCaseStmt         : result = mincCaseStmt(code)
  of nkTypeSection      : result = mincTypeSection(code)
  of nkTypeDef          : result = mincTypeDef(code)

  of nkYieldStmt        : result = mincYieldStmt(code)
  of nkDefer            : result = mincDefer(code)
  of nkTryStmt          : result = mincTryStmt(code)
  of nkFinally          : result = mincFinally(code)
  of nkRaiseStmt        : result = mincRaiseStmt(code)
  of nkBreakStmt        : result = mincBreakStmt(code)
  of nkContinueStmt     : result = mincContinueStmt(code)
  of nkBlockStmt        : result = mincBlockStmt(code)
  of nkStaticStmt       : result = mincStaticStmt(code)
  of nkDiscardStmt      : result = mincDiscardStmt(code)

  of nkImportStmt       : result = mincImportStmt(code)
  of nkImportExceptStmt : result = mincImportExceptStmt(code)
  of nkExportStmt       : result = mincExportStmt(code)
  of nkExportExceptStmt : result = mincExportExceptStmt(code)
  of nkFromStmt         : result = mincFromStmt(code)

  of nkBindStmt         : result = mincBindStmt(code)
  of nkMixinStmt        : result = mincMixinStmt(code)
  of nkUsingStmt        : result = mincUsingStmt(code)
  of nkCommentStmt      : result = mincCommentStmt(code)
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


proc toMinC *(code :string|Path) :string=
  ## Converts a block of Nim code into the Min C Language
  when code is Path: MinC( code.readAST() ) & "\n"
  else:              MinC( code.getAST()  ) & "\n"

