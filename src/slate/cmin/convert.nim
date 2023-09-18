#:______________________________________________________
#  *slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
import std/paths
# *slate dependencies
import ../element/procdef
# cmin dependencies
include ./fwdecl


proc report (code :PNode) :void=
  debugEcho "\n_______________"
  debugEcho code.renderTree
  debugEcho "_______________"

# Generator Template
const ProcDefTmpl    * = "{procdef.getRetT(code)} {procdef.getName(code)} ({cminProcDefGetArgs(code)}) {{ {body} }}"
const ProcDefArgTmpl * = "{procdef.getArgT(arg.node)} {procdef.getArgName(arg.node)}{sep}"

func cminProcDefGetArgs *(node :PNode) :string=
  assert node.kind == nkProcDef and node[ProcDef.Params].kind == nkFormalParams
  for arg in node.args:
    let sep = if not arg.last: "," else: ""
    result.add( fmt ProcDefArgTmpl )

proc cminProcDef (code :PNode) :string=
  ## TODO : Converts a nkProcDef into the Min C Language
  assert code.kind == nkProcDef
  var body = ""
  code.report()
  result = fmt ProcDefTmpl


# TODO
proc Cmin (code :PNode) :string=
  ## Node selector function. Sends the node into the relevant codegen function.
  case code.kind
  of nkProcDef          : result = cminProcDef(code)

  of nkNone             : result = cminNone(code)
  of nkEmpty            : result = cminEmpty(code)
  of nkIdent            : result = cminIdent(code)
  of nkSym              : result = cminSym(code)
  of nkType             : result = cminType(code)
  of nkCharLit          : result = cminCharLit(code)
  of nkIntLit           : result = cminIntLit(code)
  of nkInt8Lit          : result = cminInt8Lit(code)
  of nkInt16Lit         : result = cminInt16Lit(code)
  of nkInt32Lit         : result = cminInt32Lit(code)
  of nkInt64Lit         : result = cminInt64Lit(code)
  of nkUIntLit          : result = cminUIntLit(code)
  of nkUInt8Lit         : result = cminUInt8Lit(code)
  of nkUInt16Lit        : result = cminUInt16Lit(code)
  of nkUInt32Lit        : result = cminUInt32Lit(code)
  of nkUInt64Lit        : result = cminUInt64Lit(code)
  of nkFloatLit         : result = cminFloatLit(code)
  of nkFloat32Lit       : result = cminFloat32Lit(code)
  of nkFloat64Lit       : result = cminFloat64Lit(code)
  of nkFloat128Lit      : result = cminFloat128Lit(code)
  of nkStrLit           : result = cminStrLit(code)
  of nkRStrLit          : result = cminRStrLit(code)
  of nkTripleStrLit     : result = cminTripleStrLit(code)
  of nkNilLit           : result = cminNilLit(code)
  of nkComesFrom        : result = cminComesFrom(code)
  of nkDotCall          : result = cminDotCall(code)
  of nkCommand          : result = cminCommand(code)
  of nkCall             : result = cminCall(code)
  of nkCallStrLit       : result = cminCallStrLit(code)
  of nkInfix            : result = cminInfix(code)
  of nkPrefix           : result = cminPrefix(code)
  of nkPostfix          : result = cminPostfix(code)
  of nkHiddenCallConv   : result = cminHiddenCallConv(code)
  of nkExprEqExpr       : result = cminExprEqExpr(code)
  of nkExprColonExpr    : result = cminExprColonExpr(code)
  of nkIdentDefs        : result = cminIdentDefs(code)
  of nkVarTuple         : result = cminVarTuple(code)
  of nkPar              : result = cminPar(code)
  of nkObjConstr        : result = cminObjConstr(code)
  of nkCurly            : result = cminCurly(code)
  of nkCurlyExpr        : result = cminCurlyExpr(code)
  of nkBracket          : result = cminBracket(code)
  of nkBracketExpr      : result = cminBracketExpr(code)
  of nkPragmaExpr       : result = cminPragmaExpr(code)
  of nkRange            : result = cminRange(code)
  of nkDotExpr          : result = cminDotExpr(code)
  of nkCheckedFieldExpr : result = cminCheckedFieldExpr(code)
  of nkDerefExpr        : result = cminDerefExpr(code)
  of nkIfExpr           : result = cminIfExpr(code)
  of nkElifExpr         : result = cminElifExpr(code)
  of nkElseExpr         : result = cminElseExpr(code)
  of nkLambda           : result = cminLambda(code)
  of nkDo               : result = cminDo(code)
  of nkAccQuoted        : result = cminAccQuoted(code)
  of nkTableConstr      : result = cminTableConstr(code)
  of nkBind             : result = cminBind(code)
  of nkClosedSymChoice  : result = cminClosedSymChoice(code)
  of nkOpenSymChoice    : result = cminOpenSymChoice(code)
  of nkHiddenStdConv    : result = cminHiddenStdConv(code)
  of nkHiddenSubConv    : result = cminHiddenSubConv(code)
  of nkConv             : result = cminConv(code)
  of nkCast             : result = cminCast(code)
  of nkStaticExpr       : result = cminStaticExpr(code)
  of nkAddr             : result = cminAddr(code)
  of nkHiddenAddr       : result = cminHiddenAddr(code)
  of nkHiddenDeref      : result = cminHiddenDeref(code)
  of nkObjDownConv      : result = cminObjDownConv(code)
  of nkObjUpConv        : result = cminObjUpConv(code)
  of nkChckRangeF       : result = cminChckRangeF(code)
  of nkChckRange64      : result = cminChckRange64(code)
  of nkChckRange        : result = cminChckRange(code)
  of nkStringToCString  : result = cminStringToCString(code)
  of nkCStringToString  : result = cminCStringToString(code)
  of nkAsgn             : result = cminAsgn(code)
  of nkFastAsgn         : result = cminFastAsgn(code)
  of nkGenericParams    : result = cminGenericParams(code)
  of nkFormalParams     : result = cminFormalParams(code)
  of nkOfInherit        : result = cminOfInherit(code)
  of nkImportAs         : result = cminImportAs(code)
  of nkMethodDef        : result = cminMethodDef(code)
  of nkConverterDef     : result = cminConverterDef(code)
  of nkMacroDef         : result = cminMacroDef(code)
  of nkTemplateDef      : result = cminTemplateDef(code)
  of nkIteratorDef      : result = cminIteratorDef(code)
  of nkOfBranch         : result = cminOfBranch(code)
  of nkElifBranch       : result = cminElifBranch(code)
  of nkExceptBranch     : result = cminExceptBranch(code)
  of nkElse             : result = cminElse(code)
  of nkAsmStmt          : result = cminAsmStmt(code)
  of nkPragma           : result = cminPragma(code)
  of nkPragmaBlock      : result = cminPragmaBlock(code)
  of nkIfStmt           : result = cminIfStmt(code)
  of nkWhenStmt         : result = cminWhenStmt(code)
  of nkForStmt          : result = cminForStmt(code)
  of nkParForStmt       : result = cminParForStmt(code)
  of nkWhileStmt        : result = cminWhileStmt(code)
  of nkCaseStmt         : result = cminCaseStmt(code)
  of nkTypeSection      : result = cminTypeSection(code)
  of nkVarSection       : result = cminVarSection(code)
  of nkLetSection       : result = cminLetSection(code)
  of nkConstSection     : result = cminConstSection(code)
  of nkConstDef         : result = cminConstDef(code)
  of nkTypeDef          : result = cminTypeDef(code)
  of nkYieldStmt        : result = cminYieldStmt(code)
  of nkDefer            : result = cminDefer(code)
  of nkTryStmt          : result = cminTryStmt(code)
  of nkFinally          : result = cminFinally(code)
  of nkRaiseStmt        : result = cminRaiseStmt(code)
  of nkReturnStmt       : result = cminReturnStmt(code)
  of nkBreakStmt        : result = cminBreakStmt(code)
  of nkContinueStmt     : result = cminContinueStmt(code)
  of nkBlockStmt        : result = cminBlockStmt(code)
  of nkStaticStmt       : result = cminStaticStmt(code)
  of nkDiscardStmt      : result = cminDiscardStmt(code)
  of nkStmtList         : result = cminStmtList(code)
  of nkImportStmt       : result = cminImportStmt(code)
  of nkImportExceptStmt : result = cminImportExceptStmt(code)
  of nkExportStmt       : result = cminExportStmt(code)
  of nkExportExceptStmt : result = cminExportExceptStmt(code)
  of nkFromStmt         : result = cminFromStmt(code)
  of nkIncludeStmt      : result = cminIncludeStmt(code)
  of nkBindStmt         : result = cminBindStmt(code)
  of nkMixinStmt        : result = cminMixinStmt(code)
  of nkUsingStmt        : result = cminUsingStmt(code)
  of nkCommentStmt      : result = cminCommentStmt(code)
  of nkStmtListExpr     : result = cminStmtListExpr(code)
  of nkBlockExpr        : result = cminBlockExpr(code)
  of nkStmtListType     : result = cminStmtListType(code)
  of nkBlockType        : result = cminBlockType(code)
  of nkWith             : result = cminWith(code)
  of nkWithout          : result = cminWithout(code)
  of nkTypeOfExpr       : result = cminTypeOfExpr(code)
  of nkObjectTy         : result = cminObjectTy(code)
  of nkTupleTy          : result = cminTupleTy(code)
  of nkTupleClassTy     : result = cminTupleClassTy(code)
  of nkTypeClassTy      : result = cminTypeClassTy(code)
  of nkStaticTy         : result = cminStaticTy(code)
  of nkRecList          : result = cminRecList(code)
  of nkRecCase          : result = cminRecCase(code)
  of nkRecWhen          : result = cminRecWhen(code)
  of nkRefTy            : result = cminRefTy(code)
  of nkPtrTy            : result = cminPtrTy(code)
  of nkVarTy            : result = cminVarTy(code)
  of nkConstTy          : result = cminConstTy(code)
  of nkOutTy            : result = cminOutTy(code)
  of nkDistinctTy       : result = cminDistinctTy(code)
  of nkProcTy           : result = cminProcTy(code)
  of nkIteratorTy       : result = cminIteratorTy(code)
  of nkSinkAsgn         : result = cminSinkAsgn(code)
  of nkEnumTy           : result = cminEnumTy(code)
  of nkEnumFieldDef     : result = cminEnumFieldDef(code)
  of nkArgList          : result = cminArgList(code)
  of nkPattern          : result = cminPattern(code)
  of nkHiddenTryStmt    : result = cminHiddenTryStmt(code)
  of nkClosure          : result = cminClosure(code)
  of nkGotoState        : result = cminGotoState(code)
  of nkState            : result = cminState(code)
  of nkBreakState       : result = cminBreakState(code)
  of nkFuncDef          : result = cminFuncDef(code)
  of nkTupleConstr      : result = cminTupleConstr(code)
  of nkError            : result = cminError(code)
  of nkModuleRef        : result = cminModuleRef(code)      # for .rod file support: A (moduleId, itemId) pair
  of nkReplayAction     : result = cminReplayAction(code)   # for .rod file support: A replay action
  of nkNilRodNode       : result = cminNilRodNode(code)     # for .rod file support: a 'nil' PNode

proc toCmin *(code :string|Path) :string=
  ## Converts a block of Nim code into the Min C Language
  when code is Path: Cmin( code.readAST() )
  else:              Cmin( code.getAST()  )

