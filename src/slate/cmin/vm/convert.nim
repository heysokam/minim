#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
import std/macros
# *Slate dependencies
import ../element/procdef
# cmin dependencies
include ./fwdecl


func report (code :NimNode) :void=
  debugEcho "\n_______________"
  debugEcho code.treeRepr
  debugEcho "_______________"
  debugEcho code.astGenRepr
  debugEcho "_______________\n"

# Generator Template
const ProcDefTmpl    * = "{procdef.getRetT(code)} {procdef.getName(code)} ({cminProcDefGetArgs(code)}) {{ {body} }}"
const ProcDefArgTmpl * = "{procdef.getArgT(arg.node)} {procdef.getArgName(arg.node)}{sep}"

func cminProcDefGetArgs *(node :NimNode) :string=
  assert node.kind == nnkProcDef and node[ProcDef.Params].kind == nnkFormalParams
  for arg in node.args:
    let sep = if not arg.last: "," else: ""
    result.add( fmt ProcDefArgTmpl )

proc cminProcDef (code :NimNode) :string=
  ## TODO : Converts a nnkProcDef into the Min C Language
  assert code.kind == nnkProcDef
  var body = ""
  code.report()
  result = fmt ProcDefTmpl


# TODO
proc Cmin (code :NimNode) :string=
  ## Node selector function. Sends the node into the relevant codegen function.
  case code.kind
  of nnkProcDef          : result = cminProcDef(code)

  of nnkNone             : result = cminNone(code)
  of nnkEmpty            : result = cminEmpty(code)
  of nnkIdent            : result = cminIdent(code)
  of nnkSym              : result = cminSym(code)
  of nnkType             : result = cminType(code)
  of nnkCharLit          : result = cminCharLit(code)
  of nnkIntLit           : result = cminIntLit(code)
  of nnkInt8Lit          : result = cminInt8Lit(code)
  of nnkInt16Lit         : result = cminInt16Lit(code)
  of nnkInt32Lit         : result = cminInt32Lit(code)
  of nnkInt64Lit         : result = cminInt64Lit(code)
  of nnkUIntLit          : result = cminUIntLit(code)
  of nnkUInt8Lit         : result = cminUInt8Lit(code)
  of nnkUInt16Lit        : result = cminUInt16Lit(code)
  of nnkUInt32Lit        : result = cminUInt32Lit(code)
  of nnkUInt64Lit        : result = cminUInt64Lit(code)
  of nnkFloatLit         : result = cminFloatLit(code)
  of nnkFloat32Lit       : result = cminFloat32Lit(code)
  of nnkFloat64Lit       : result = cminFloat64Lit(code)
  of nnkFloat128Lit      : result = cminFloat128Lit(code)
  of nnkStrLit           : result = cminStrLit(code)
  of nnkRStrLit          : result = cminRStrLit(code)
  of nnkTripleStrLit     : result = cminTripleStrLit(code)
  of nnkNilLit           : result = cminNilLit(code)
  of nnkComesFrom        : result = cminComesFrom(code)
  of nnkDotCall          : result = cminDotCall(code)
  of nnkCommand          : result = cminCommand(code)
  of nnkCall             : result = cminCall(code)
  of nnkCallStrLit       : result = cminCallStrLit(code)
  of nnkInfix            : result = cminInfix(code)
  of nnkPrefix           : result = cminPrefix(code)
  of nnkPostfix          : result = cminPostfix(code)
  of nnkHiddenCallConv   : result = cminHiddenCallConv(code)
  of nnkExprEqExpr       : result = cminExprEqExpr(code)
  of nnkExprColonExpr    : result = cminExprColonExpr(code)
  of nnkIdentDefs        : result = cminIdentDefs(code)
  of nnkVarTuple         : result = cminVarTuple(code)
  of nnkPar              : result = cminPar(code)
  of nnkObjConstr        : result = cminObjConstr(code)
  of nnkCurly            : result = cminCurly(code)
  of nnkCurlyExpr        : result = cminCurlyExpr(code)
  of nnkBracket          : result = cminBracket(code)
  of nnkBracketExpr      : result = cminBracketExpr(code)
  of nnkPragmaExpr       : result = cminPragmaExpr(code)
  of nnkRange            : result = cminRange(code)
  of nnkDotExpr          : result = cminDotExpr(code)
  of nnkCheckedFieldExpr : result = cminCheckedFieldExpr(code)
  of nnkDerefExpr        : result = cminDerefExpr(code)
  of nnkIfExpr           : result = cminIfExpr(code)
  of nnkElifExpr         : result = cminElifExpr(code)
  of nnkElseExpr         : result = cminElseExpr(code)
  of nnkLambda           : result = cminLambda(code)
  of nnkDo               : result = cminDo(code)
  of nnkAccQuoted        : result = cminAccQuoted(code)
  of nnkTableConstr      : result = cminTableConstr(code)
  of nnkBind             : result = cminBind(code)
  of nnkClosedSymChoice  : result = cminClosedSymChoice(code)
  of nnkOpenSymChoice    : result = cminOpenSymChoice(code)
  of nnkHiddenStdConv    : result = cminHiddenStdConv(code)
  of nnkHiddenSubConv    : result = cminHiddenSubConv(code)
  of nnkConv             : result = cminConv(code)
  of nnkCast             : result = cminCast(code)
  of nnkStaticExpr       : result = cminStaticExpr(code)
  of nnkAddr             : result = cminAddr(code)
  of nnkHiddenAddr       : result = cminHiddenAddr(code)
  of nnkHiddenDeref      : result = cminHiddenDeref(code)
  of nnkObjDownConv      : result = cminObjDownConv(code)
  of nnkObjUpConv        : result = cminObjUpConv(code)
  of nnkChckRangeF       : result = cminChckRangeF(code)
  of nnkChckRange64      : result = cminChckRange64(code)
  of nnkChckRange        : result = cminChckRange(code)
  of nnkStringToCString  : result = cminStringToCString(code)
  of nnkCStringToString  : result = cminCStringToString(code)
  of nnkAsgn             : result = cminAsgn(code)
  of nnkFastAsgn         : result = cminFastAsgn(code)
  of nnkGenericParams    : result = cminGenericParams(code)
  of nnkFormalParams     : result = cminFormalParams(code)
  of nnkOfInherit        : result = cminOfInherit(code)
  of nnkImportAs         : result = cminImportAs(code)
  of nnkMethodDef        : result = cminMethodDef(code)
  of nnkConverterDef     : result = cminConverterDef(code)
  of nnkMacroDef         : result = cminMacroDef(code)
  of nnkTemplateDef      : result = cminTemplateDef(code)
  of nnkIteratorDef      : result = cminIteratorDef(code)
  of nnkOfBranch         : result = cminOfBranch(code)
  of nnkElifBranch       : result = cminElifBranch(code)
  of nnkExceptBranch     : result = cminExceptBranch(code)
  of nnkElse             : result = cminElse(code)
  of nnkAsmStmt          : result = cminAsmStmt(code)
  of nnkPragma           : result = cminPragma(code)
  of nnkPragmaBlock      : result = cminPragmaBlock(code)
  of nnkIfStmt           : result = cminIfStmt(code)
  of nnkWhenStmt         : result = cminWhenStmt(code)
  of nnkForStmt          : result = cminForStmt(code)
  of nnkParForStmt       : result = cminParForStmt(code)
  of nnkWhileStmt        : result = cminWhileStmt(code)
  of nnkCaseStmt         : result = cminCaseStmt(code)
  of nnkTypeSection      : result = cminTypeSection(code)
  of nnkVarSection       : result = cminVarSection(code)
  of nnkLetSection       : result = cminLetSection(code)
  of nnkConstSection     : result = cminConstSection(code)
  of nnkConstDef         : result = cminConstDef(code)
  of nnkTypeDef          : result = cminTypeDef(code)
  of nnkYieldStmt        : result = cminYieldStmt(code)
  of nnkDefer            : result = cminDefer(code)
  of nnkTryStmt          : result = cminTryStmt(code)
  of nnkFinally          : result = cminFinally(code)
  of nnkRaiseStmt        : result = cminRaiseStmt(code)
  of nnkReturnStmt       : result = cminReturnStmt(code)
  of nnkBreakStmt        : result = cminBreakStmt(code)
  of nnkContinueStmt     : result = cminContinueStmt(code)
  of nnkBlockStmt        : result = cminBlockStmt(code)
  of nnkStaticStmt       : result = cminStaticStmt(code)
  of nnkDiscardStmt      : result = cminDiscardStmt(code)
  of nnkStmtList         : result = cminStmtList(code)
  of nnkImportStmt       : result = cminImportStmt(code)
  of nnkImportExceptStmt : result = cminImportExceptStmt(code)
  of nnkExportStmt       : result = cminExportStmt(code)
  of nnkExportExceptStmt : result = cminExportExceptStmt(code)
  of nnkFromStmt         : result = cminFromStmt(code)
  of nnkIncludeStmt      : result = cminIncludeStmt(code)
  of nnkBindStmt         : result = cminBindStmt(code)
  of nnkMixinStmt        : result = cminMixinStmt(code)
  of nnkUsingStmt        : result = cminUsingStmt(code)
  of nnkCommentStmt      : result = cminCommentStmt(code)
  of nnkStmtListExpr     : result = cminStmtListExpr(code)
  of nnkBlockExpr        : result = cminBlockExpr(code)
  of nnkStmtListType     : result = cminStmtListType(code)
  of nnkBlockType        : result = cminBlockType(code)
  of nnkWith             : result = cminWith(code)
  of nnkWithout          : result = cminWithout(code)
  of nnkTypeOfExpr       : result = cminTypeOfExpr(code)
  of nnkObjectTy         : result = cminObjectTy(code)
  of nnkTupleTy          : result = cminTupleTy(code)
  of nnkTupleClassTy     : result = cminTupleClassTy(code)
  of nnkTypeClassTy      : result = cminTypeClassTy(code)
  of nnkStaticTy         : result = cminStaticTy(code)
  of nnkRecList          : result = cminRecList(code)
  of nnkRecCase          : result = cminRecCase(code)
  of nnkRecWhen          : result = cminRecWhen(code)
  of nnkRefTy            : result = cminRefTy(code)
  of nnkPtrTy            : result = cminPtrTy(code)
  of nnkVarTy            : result = cminVarTy(code)
  of nnkConstTy          : result = cminConstTy(code)
  of nnkOutTy            : result = cminOutTy(code)
  of nnkDistinctTy       : result = cminDistinctTy(code)
  of nnkProcTy           : result = cminProcTy(code)
  of nnkIteratorTy       : result = cminIteratorTy(code)
  of nnkSinkAsgn         : result = cminSinkAsgn(code)
  of nnkEnumTy           : result = cminEnumTy(code)
  of nnkEnumFieldDef     : result = cminEnumFieldDef(code)
  of nnkArgList          : result = cminArgList(code)
  of nnkPattern          : result = cminPattern(code)
  of nnkHiddenTryStmt    : result = cminHiddenTryStmt(code)
  of nnkClosure          : result = cminClosure(code)
  of nnkGotoState        : result = cminGotoState(code)
  of nnkState            : result = cminState(code)
  of nnkBreakState       : result = cminBreakState(code)
  of nnkFuncDef          : result = cminFuncDef(code)
  of nnkTupleConstr      : result = cminTupleConstr(code)
  of nnkError            : result = cminError(code)

macro toCmin *(code :typed) :string=  newLit Cmin( code.getImpl() )
  ## Converts a block of Nim code into the Min C Language

