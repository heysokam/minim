#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps *Slate
import slate/nimc
import slate/format
# @deps minc
import ./base

#_______________________________________
# @section Main Code Generator
#_____________________________
proc MinC *(code :PNode; indent :int= 0) :string

#_____________________________
# @section Custom Tools
proc mincGetValueRaw (code :PNode; indent :int= 0) :string
proc mincCallRaw     (code :PNode; indent :int= 0) :string # Format-less version of an nkCall. Used for arguments

#_______________________________________
# @section Generator Cases for MinC
#_____________________________
# Process
proc mincProcDef          (code :PNode; indent :int= 0) :string
proc mincFuncDef          (code :PNode; indent :int= 0) :string
proc mincReturnStmt       (code :PNode; indent :int= 1) :string
proc mincConstSection     (code :PNode; indent :int= 0) :string
proc mincLetSection       (code :PNode; indent :int= 0) :string
proc mincIncludeStmt      (code :PNode; indent :int= 0) :string
proc mincCommand          (code :PNode; indent :int= 0) :string
proc mincCall             (code :PNode; indent :int= 0) :string
proc mincCommentStmt      (code :PNode; indent :int= 0) :string
proc mincDiscardStmt      (code :PNode; indent :int= 0) :string
proc mincVarSection       (code :PNode; indent :int= 0) :string
proc mincWhileStmt        (code :PNode; indent :int= 0) :string
proc mincIfStmt           (code :PNode; indent :int= 0) :string
proc mincTypeSection      (code :PNode; indent :int= 0) :string
proc mincTypeDef          (code :PNode; indent :int= 0) :string
proc mincAsgn             (code :PNode; indent :int= 0) :string
proc mincContinueStmt     (code :PNode; indent :int= 0) :string
proc mincBreakStmt        (code :PNode; indent :int= 0) :string
proc mincWhenStmt         (code :PNode; indent :int= 0) :string
proc mincPragma           (code :PNode; indent :int= 0) :string
proc mincInfix            (code :PNode; indent :int= 0; raw :bool= false) :string
proc mincPrefix           (code :PNode; indent :int= 0; raw :bool= false) :string
proc mincPostfix          (code :PNode; indent :int= 0; raw :bool= false) :string
proc mincForStmt          (code :PNode; indent :int= 0) :string
proc mincCaseStmt         (code :PNode; indent :int= 0) :string

# TODO
proc mincNone             (code :PNode) :string=  assert code.kind == nkNone             ; todo(code)  ## TODO : Converts a nkNone into the Min C Language
proc mincEmpty            (code :PNode) :string=  assert code.kind == nkEmpty            ; todo(code)  ## TODO : Converts a nkEmpty into the Min C Language
proc mincIdent            (code :PNode) :string=  assert code.kind == nkIdent            ; todo(code)  ## TODO : Converts a nkIdent into the Min C Language
proc mincSym              (code :PNode) :string=  assert code.kind == nkSym              ; todo(code)  ## TODO : Converts a nkSym into the Min C Language
proc mincType             (code :PNode) :string=  assert code.kind == nkType             ; todo(code)  ## TODO : Converts a nkType into the Min C Language
proc mincCharLit          (code :PNode) :string=  assert code.kind == nkCharLit          ; todo(code)  ## TODO : Converts a nkCharLit into the Min C Language
proc mincIntLit           (code :PNode) :string=  assert code.kind == nkIntLit           ; todo(code)  ## TODO : Converts a nkIntLit into the Min C Language
proc mincInt8Lit          (code :PNode) :string=  assert code.kind == nkInt8Lit          ; todo(code)  ## TODO : Converts a nkInt8Lit into the Min C Language
proc mincInt16Lit         (code :PNode) :string=  assert code.kind == nkInt16Lit         ; todo(code)  ## TODO : Converts a nkInt16Lit into the Min C Language
proc mincInt32Lit         (code :PNode) :string=  assert code.kind == nkInt32Lit         ; todo(code)  ## TODO : Converts a nkInt32Lit into the Min C Language
proc mincInt64Lit         (code :PNode) :string=  assert code.kind == nkInt64Lit         ; todo(code)  ## TODO : Converts a nkInt64Lit into the Min C Language
proc mincUIntLit          (code :PNode) :string=  assert code.kind == nkUIntLit          ; todo(code)  ## TODO : Converts a nkUIntLit into the Min C Language
proc mincUInt8Lit         (code :PNode) :string=  assert code.kind == nkUInt8Lit         ; todo(code)  ## TODO : Converts a nkUInt8Lit into the Min C Language
proc mincUInt16Lit        (code :PNode) :string=  assert code.kind == nkUInt16Lit        ; todo(code)  ## TODO : Converts a nkUInt16Lit into the Min C Language
proc mincUInt32Lit        (code :PNode) :string=  assert code.kind == nkUInt32Lit        ; todo(code)  ## TODO : Converts a nkUInt32Lit into the Min C Language
proc mincUInt64Lit        (code :PNode) :string=  assert code.kind == nkUInt64Lit        ; todo(code)  ## TODO : Converts a nkUInt64Lit into the Min C Language
proc mincFloatLit         (code :PNode) :string=  assert code.kind == nkFloatLit         ; todo(code)  ## TODO : Converts a nkFloatLit into the Min C Language
proc mincFloat32Lit       (code :PNode) :string=  assert code.kind == nkFloat32Lit       ; todo(code)  ## TODO : Converts a nkFloat32Lit into the Min C Language
proc mincFloat64Lit       (code :PNode) :string=  assert code.kind == nkFloat64Lit       ; todo(code)  ## TODO : Converts a nkFloat64Lit into the Min C Language
proc mincFloat128Lit      (code :PNode) :string=  assert code.kind == nkFloat128Lit      ; todo(code)  ## TODO : Converts a nkFloat128Lit into the Min C Language
proc mincStrLit           (code :PNode) :string=  assert code.kind == nkStrLit           ; todo(code)  ## TODO : Converts a nkStrLit into the Min C Language
proc mincRStrLit          (code :PNode) :string=  assert code.kind == nkRStrLit          ; todo(code)  ## TODO : Converts a nkRStrLit into the Min C Language
proc mincTripleStrLit     (code :PNode) :string=  assert code.kind == nkTripleStrLit     ; todo(code)  ## TODO : Converts a nkTripleStrLit into the Min C Language
proc mincNilLit           (code :PNode) :string=  assert code.kind == nkNilLit           ; todo(code)  ## TODO : Converts a nkNilLit into the Min C Language
proc mincComesFrom        (code :PNode) :string=  assert code.kind == nkComesFrom        ; todo(code)  ## TODO : Converts a nkComesFrom into the Min C Language

proc mincDotCall          (code :PNode) :string=  assert code.kind == nkDotCall          ; todo(code)  ## TODO : Converts a nkDotCall into the Min C Language
proc mincCallStrLit       (code :PNode) :string=  assert code.kind == nkCallStrLit       ; todo(code)  ## TODO : Converts a nkCallStrLit into the Min C Language

proc mincHiddenCallConv   (code :PNode) :string=  assert code.kind == nkHiddenCallConv   ; todo(code)  ## TODO : Converts a nkHiddenCallConv into the Min C Language
proc mincExprEqExpr       (code :PNode) :string=  assert code.kind == nkExprEqExpr       ; todo(code)  ## TODO : Converts a nkExprEqExpr into the Min C Language
proc mincExprColonExpr    (code :PNode) :string=  assert code.kind == nkExprColonExpr    ; todo(code)  ## TODO : Converts a nkExprColonExpr into the Min C Language
proc mincIdentDefs        (code :PNode) :string=  assert code.kind == nkIdentDefs        ; todo(code)  ## TODO : Converts a nkIdentDefs into the Min C Language
proc mincVarTuple         (code :PNode) :string=  assert code.kind == nkVarTuple         ; todo(code)  ## TODO : Converts a nkVarTuple into the Min C Language
proc mincPar              (code :PNode) :string=  assert code.kind == nkPar              ; todo(code)  ## TODO : Converts a nkPar into the Min C Language
proc mincObjConstr        (code :PNode) :string=  assert code.kind == nkObjConstr        ; todo(code)  ## TODO : Converts a nkObjConstr into the Min C Language
proc mincCurly            (code :PNode) :string=  assert code.kind == nkCurly            ; todo(code)  ## TODO : Converts a nkCurly into the Min C Language
proc mincCurlyExpr        (code :PNode) :string=  assert code.kind == nkCurlyExpr        ; todo(code)  ## TODO : Converts a nkCurlyExpr into the Min C Language
proc mincBracket          (code :PNode) :string=  assert code.kind == nkBracket          ; todo(code)  ## TODO : Converts a nkBracket into the Min C Language
proc mincBracketExpr      (code :PNode) :string=  assert code.kind == nkBracketExpr      ; todo(code)  ## TODO : Converts a nkBracketExpr into the Min C Language
proc mincPragmaExpr       (code :PNode) :string=  assert code.kind == nkPragmaExpr       ; todo(code)  ## TODO : Converts a nkPragmaExpr into the Min C Language
proc mincRange            (code :PNode) :string=  assert code.kind == nkRange            ; todo(code)  ## TODO : Converts a nkRange into the Min C Language
proc mincDotExpr          (code :PNode) :string=  assert code.kind == nkDotExpr          ; todo(code)  ## TODO : Converts a nkDotExpr into the Min C Language
proc mincCheckedFieldExpr (code :PNode) :string=  assert code.kind == nkCheckedFieldExpr ; todo(code)  ## TODO : Converts a nkCheckedFieldExpr into the Min C Language
proc mincDerefExpr        (code :PNode) :string=  assert code.kind == nkDerefExpr        ; todo(code)  ## TODO : Converts a nkDerefExpr into the Min C Language
proc mincIfExpr           (code :PNode) :string=  assert code.kind == nkIfExpr           ; todo(code)  ## TODO : Converts a nkIfExpr into the Min C Language
proc mincElifExpr         (code :PNode) :string=  assert code.kind == nkElifExpr         ; todo(code)  ## TODO : Converts a nkElifExpr into the Min C Language
proc mincElseExpr         (code :PNode) :string=  assert code.kind == nkElseExpr         ; todo(code)  ## TODO : Converts a nkElseExpr into the Min C Language
proc mincLambda           (code :PNode) :string=  assert code.kind == nkLambda           ; todo(code)  ## TODO : Converts a nkLambda into the Min C Language
proc mincDo               (code :PNode) :string=  assert code.kind == nkDo               ; todo(code)  ## TODO : Converts a nkDo into the Min C Language
proc mincAccQuoted        (code :PNode) :string=  assert code.kind == nkAccQuoted        ; todo(code)  ## TODO : Converts a nkAccQuoted into the Min C Language
proc mincTableConstr      (code :PNode) :string=  assert code.kind == nkTableConstr      ; todo(code)  ## TODO : Converts a nkTableConstr into the Min C Language
proc mincBind             (code :PNode) :string=  assert code.kind == nkBind             ; todo(code)  ## TODO : Converts a nkBind into the Min C Language
proc mincClosedSymChoice  (code :PNode) :string=  assert code.kind == nkClosedSymChoice  ; todo(code)  ## TODO : Converts a nkClosedSymChoice into the Min C Language
proc mincOpenSymChoice    (code :PNode) :string=  assert code.kind == nkOpenSymChoice    ; todo(code)  ## TODO : Converts a nkOpenSymChoice into the Min C Language
proc mincHiddenStdConv    (code :PNode) :string=  assert code.kind == nkHiddenStdConv    ; todo(code)  ## TODO : Converts a nkHiddenStdConv into the Min C Language
proc mincHiddenSubConv    (code :PNode) :string=  assert code.kind == nkHiddenSubConv    ; todo(code)  ## TODO : Converts a nkHiddenSubConv into the Min C Language
proc mincConv             (code :PNode) :string=  assert code.kind == nkConv             ; todo(code)  ## TODO : Converts a nkConv into the Min C Language
proc mincCast             (code :PNode) :string=  assert code.kind == nkCast             ; todo(code)  ## TODO : Converts a nkCast into the Min C Language
proc mincStaticExpr       (code :PNode) :string=  assert code.kind == nkStaticExpr       ; todo(code)  ## TODO : Converts a nkStaticExpr into the Min C Language
proc mincAddr             (code :PNode) :string=  assert code.kind == nkAddr             ; todo(code)  ## TODO : Converts a nkAddr into the Min C Language
proc mincHiddenAddr       (code :PNode) :string=  assert code.kind == nkHiddenAddr       ; todo(code)  ## TODO : Converts a nkHiddenAddr into the Min C Language
proc mincHiddenDeref      (code :PNode) :string=  assert code.kind == nkHiddenDeref      ; todo(code)  ## TODO : Converts a nkHiddenDeref into the Min C Language
proc mincObjDownConv      (code :PNode) :string=  assert code.kind == nkObjDownConv      ; todo(code)  ## TODO : Converts a nkObjDownConv into the Min C Language
proc mincObjUpConv        (code :PNode) :string=  assert code.kind == nkObjUpConv        ; todo(code)  ## TODO : Converts a nkObjUpConv into the Min C Language
proc mincChckRangeF       (code :PNode) :string=  assert code.kind == nkChckRangeF       ; todo(code)  ## TODO : Converts a nkChckRangeF into the Min C Language
proc mincChckRange64      (code :PNode) :string=  assert code.kind == nkChckRange64      ; todo(code)  ## TODO : Converts a nkChckRange64 into the Min C Language
proc mincChckRange        (code :PNode) :string=  assert code.kind == nkChckRange        ; todo(code)  ## TODO : Converts a nkChckRange into the Min C Language
proc mincStringToCString  (code :PNode) :string=  assert code.kind == nkStringToCString  ; todo(code)  ## TODO : Converts a nkStringToCString into the Min C Language
proc mincCStringToString  (code :PNode) :string=  assert code.kind == nkCStringToString  ; todo(code)  ## TODO : Converts a nkCStringToString into the Min C Language

proc mincFastAsgn         (code :PNode) :string=  assert code.kind == nkFastAsgn         ; todo(code)  ## TODO : Converts a nkFastAsgn into the Min C Language
proc mincGenericParams    (code :PNode) :string=  assert code.kind == nkGenericParams    ; todo(code)  ## TODO : Converts a nkGenericParams into the Min C Language
proc mincFormalParams     (code :PNode) :string=  assert code.kind == nkFormalParams     ; todo(code)  ## TODO : Converts a nkFormalParams into the Min C Language
proc mincOfInherit        (code :PNode) :string=  assert code.kind == nkOfInherit        ; todo(code)  ## TODO : Converts a nkOfInherit into the Min C Language
proc mincImportAs         (code :PNode) :string=  assert code.kind == nkImportAs         ; todo(code)  ## TODO : Converts a nkImportAs into the Min C Language

proc mincMethodDef        (code :PNode) :string=  assert code.kind == nkMethodDef        ; todo(code)  ## TODO : Converts a nkMethodDef into the Min C Language
proc mincConverterDef     (code :PNode) :string=  assert code.kind == nkConverterDef     ; todo(code)  ## TODO : Converts a nkConverterDef into the Min C Language
proc mincMacroDef         (code :PNode) :string=  assert code.kind == nkMacroDef         ; todo(code)  ## TODO : Converts a nkMacroDef into the Min C Language
proc mincTemplateDef      (code :PNode) :string=  assert code.kind == nkTemplateDef      ; todo(code)  ## TODO : Converts a nkTemplateDef into the Min C Language
proc mincIteratorDef      (code :PNode) :string=  assert code.kind == nkIteratorDef      ; todo(code)  ## TODO : Converts a nkIteratorDef into the Min C Language

proc mincAsmStmt          (code :PNode) :string=  assert code.kind == nkAsmStmt          ; todo(code)  ## TODO : Converts a nkAsmStmt into the Min C Language
proc mincPragmaBlock      (code :PNode) :string=  assert code.kind == nkPragmaBlock      ; todo(code)  ## TODO : Converts a nkPragmaBlock into the Min C Language
proc mincOfBranch         (code :PNode) :string=  assert code.kind == nkOfBranch         ; todo(code)  ## TODO : Converts a nkOfBranch into the Min C Language
proc mincElifBranch       (code :PNode) :string=  assert code.kind == nkElifBranch       ; todo(code)  ## TODO : Converts a nkElifBranch into the Min C Language
proc mincElse             (code :PNode) :string=  assert code.kind == nkElse             ; todo(code)  ## TODO : Converts a nkElse into the Min C Language

proc mincParForStmt       (code :PNode) :string=  assert code.kind == nkParForStmt       ; todo(code)  ## TODO : Converts a nkParForStmt into the Min C Language

proc mincConstDef         (code :PNode) :string=  assert code.kind == nkConstDef         ; todo(code)  ## TODO : Converts a nkConstDef into the Min C Language

proc mincYieldStmt        (code :PNode) :string=  assert code.kind == nkYieldStmt        ; todo(code)  ## TODO : Converts a nkYieldStmt into the Min C Language
proc mincDefer            (code :PNode) :string=  assert code.kind == nkDefer            ; todo(code)  ## TODO : Converts a nkDefer into the Min C Language
proc mincTryStmt          (code :PNode) :string=  assert code.kind == nkTryStmt          ; todo(code)  ## TODO : Converts a nkTryStmt into the Min C Language
proc mincExceptBranch     (code :PNode) :string=  assert code.kind == nkExceptBranch     ; todo(code)  ## TODO : Converts a nkExceptBranch into the Min C Language
proc mincFinally          (code :PNode) :string=  assert code.kind == nkFinally          ; todo(code)  ## TODO : Converts a nkFinally into the Min C Language
proc mincRaiseStmt        (code :PNode) :string=  assert code.kind == nkRaiseStmt        ; todo(code)  ## TODO : Converts a nkRaiseStmt into the Min C Language

proc mincBlockStmt        (code :PNode) :string=  assert code.kind == nkBlockStmt        ; todo(code)  ## TODO : Converts a nkBlockStmt into the Min C Language
proc mincStaticStmt       (code :PNode) :string=  assert code.kind == nkStaticStmt       ; todo(code)  ## TODO : Converts a nkStaticStmt into the Min C Language

proc mincImportStmt       (code :PNode) :string=  assert code.kind == nkImportStmt       ; todo(code)  ## TODO : Converts a nkImportStmt into the Min C Language
proc mincImportExceptStmt (code :PNode) :string=  assert code.kind == nkImportExceptStmt ; todo(code)  ## TODO : Converts a nkImportExceptStmt into the Min C Language
proc mincExportStmt       (code :PNode) :string=  assert code.kind == nkExportStmt       ; todo(code)  ## TODO : Converts a nkExportStmt into the Min C Language
proc mincExportExceptStmt (code :PNode) :string=  assert code.kind == nkExportExceptStmt ; todo(code)  ## TODO : Converts a nkExportExceptStmt into the Min C Language
proc mincFromStmt         (code :PNode) :string=  assert code.kind == nkFromStmt         ; todo(code)  ## TODO : Converts a nkFromStmt into the Min C Language

proc mincBindStmt         (code :PNode) :string=  assert code.kind == nkBindStmt         ; todo(code)  ## TODO : Converts a nkBindStmt into the Min C Language
proc mincMixinStmt        (code :PNode) :string=  assert code.kind == nkMixinStmt        ; todo(code)  ## TODO : Converts a nkMixinStmt into the Min C Language
proc mincUsingStmt        (code :PNode) :string=  assert code.kind == nkUsingStmt        ; todo(code)  ## TODO : Converts a nkUsingStmt into the Min C Language
proc mincStmtListExpr     (code :PNode) :string=  assert code.kind == nkStmtListExpr     ; todo(code)  ## TODO : Converts a nkStmtListExpr into the Min C Language
proc mincBlockExpr        (code :PNode) :string=  assert code.kind == nkBlockExpr        ; todo(code)  ## TODO : Converts a nkBlockExpr into the Min C Language
proc mincStmtListType     (code :PNode) :string=  assert code.kind == nkStmtListType     ; todo(code)  ## TODO : Converts a nkStmtListType into the Min C Language
proc mincBlockType        (code :PNode) :string=  assert code.kind == nkBlockType        ; todo(code)  ## TODO : Converts a nkBlockType into the Min C Language
proc mincWith             (code :PNode) :string=  assert code.kind == nkWith             ; todo(code)  ## TODO : Converts a nkWith into the Min C Language
proc mincWithout          (code :PNode) :string=  assert code.kind == nkWithout          ; todo(code)  ## TODO : Converts a nkWithout into the Min C Language
proc mincTypeOfExpr       (code :PNode) :string=  assert code.kind == nkTypeOfExpr       ; todo(code)  ## TODO : Converts a nkTypeOfExpr into the Min C Language
proc mincObjectTy         (code :PNode) :string=  assert code.kind == nkObjectTy         ; todo(code)  ## TODO : Converts a nkObjectTy into the Min C Language
proc mincTupleTy          (code :PNode) :string=  assert code.kind == nkTupleTy          ; todo(code)  ## TODO : Converts a nkTupleTy into the Min C Language
proc mincTupleClassTy     (code :PNode) :string=  assert code.kind == nkTupleClassTy     ; todo(code)  ## TODO : Converts a nkTupleClassTy into the Min C Language
proc mincTypeClassTy      (code :PNode) :string=  assert code.kind == nkTypeClassTy      ; todo(code)  ## TODO : Converts a nkTypeClassTy into the Min C Language
proc mincStaticTy         (code :PNode) :string=  assert code.kind == nkStaticTy         ; todo(code)  ## TODO : Converts a nkStaticTy into the Min C Language
proc mincRecList          (code :PNode) :string=  assert code.kind == nkRecList          ; todo(code)  ## TODO : Converts a nkRecList into the Min C Language
proc mincRecCase          (code :PNode) :string=  assert code.kind == nkRecCase          ; todo(code)  ## TODO : Converts a nkRecCase into the Min C Language
proc mincRecWhen          (code :PNode) :string=  assert code.kind == nkRecWhen          ; todo(code)  ## TODO : Converts a nkRecWhen into the Min C Language

proc mincRefTy            (code :PNode) :string=  assert code.kind == nkRefTy            ; todo(code)  ## TODO : Converts a nkRefTy into the Min C Language
proc mincPtrTy            (code :PNode) :string=  assert code.kind == nkPtrTy            ; todo(code)  ## TODO : Converts a nkPtrTy into the Min C Language
proc mincVarTy            (code :PNode) :string=  assert code.kind == nkVarTy            ; todo(code)  ## TODO : Converts a nkVarTy into the Min C Language
proc mincConstTy          (code :PNode) :string=  assert code.kind == nkConstTy          ; todo(code)  ## TODO : Converts a nkConstTy into the Min C Language
proc mincOutTy            (code :PNode) :string=  assert code.kind == nkOutTy            ; todo(code)  ## TODO : Converts a nkOutTy into the Min C Language
proc mincDistinctTy       (code :PNode) :string=  assert code.kind == nkDistinctTy       ; todo(code)  ## TODO : Converts a nkDistinctTy into the Min C Language
proc mincProcTy           (code :PNode) :string=  assert code.kind == nkProcTy           ; todo(code)  ## TODO : Converts a nkProcTy into the Min C Language
proc mincIteratorTy       (code :PNode) :string=  assert code.kind == nkIteratorTy       ; todo(code)  ## TODO : Converts a nkIteratorTy into the Min C Language
proc mincSinkAsgn         (code :PNode) :string=  assert code.kind == nkSinkAsgn         ; todo(code)  ## TODO : Converts a nkSinkAsgn into the Min C Language
proc mincEnumTy           (code :PNode) :string=  assert code.kind == nkEnumTy           ; todo(code)  ## TODO : Converts a nkEnumTy into the Min C Language
proc mincEnumFieldDef     (code :PNode) :string=  assert code.kind == nkEnumFieldDef     ; todo(code)  ## TODO : Converts a nkEnumFieldDef into the Min C Language

proc mincArgList          (code :PNode) :string=  assert code.kind == nkArgList          ; todo(code)  ## TODO : Converts a nkArgList into the Min C Language
proc mincPattern          (code :PNode) :string=  assert code.kind == nkPattern          ; todo(code)  ## TODO : Converts a nkPattern into the Min C Language
proc mincHiddenTryStmt    (code :PNode) :string=  assert code.kind == nkHiddenTryStmt    ; todo(code)  ## TODO : Converts a nkHiddenTryStmt into the Min C Language
proc mincClosure          (code :PNode) :string=  assert code.kind == nkClosure          ; todo(code)  ## TODO : Converts a nkClosure into the Min C Language
proc mincGotoState        (code :PNode) :string=  assert code.kind == nkGotoState        ; todo(code)  ## TODO : Converts a nkGotoState into the Min C Language
proc mincState            (code :PNode) :string=  assert code.kind == nkState            ; todo(code)  ## TODO : Converts a nkState into the Min C Language
proc mincBreakState       (code :PNode) :string=  assert code.kind == nkBreakState       ; todo(code)  ## TODO : Converts a nkBreakState into the Min C Language
proc mincTupleConstr      (code :PNode) :string=  assert code.kind == nkTupleConstr      ; todo(code)  ## TODO : Converts a nkTupleConstr into the Min C Language
proc mincError            (code :PNode) :string=  assert code.kind == nkError            ; todo(code)  ## TODO : Converts a nkError into the Min C Language
proc mincModuleRef        (code :PNode) :string=  assert code.kind == nkModuleRef        ; todo(code)  ## TODO : Converts a nkModuleRef into the Min C Language
proc mincReplayAction     (code :PNode) :string=  assert code.kind == nkReplayAction     ; todo(code)  ## TODO : Converts a nkReplayAction into the Min C Language
proc mincNilRodNode       (code :PNode) :string=  assert code.kind == nkNilRodNode       ; todo(code)  ## TODO : Converts a nkNilRodNode into the Min C Language
# Recursive
# proc mincStmtList         (code :PNode) :string=  assert code.kind == nkStmtList         ; todo(code)  ## TODO : Converts a nkStmtList into the Min C Language
