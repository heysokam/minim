
template todo (code :NimNode) :void=
  raise newException(IOError, &"Interpreting {code.kind} is currently not supported for Min C. Its Nim code is:\n{code.toStrLit}\n")

## Generator Cases for Min C
proc cminNone             (code :NimNode) :string=  assert code.kind == nnkNone             ; todo(code)  ## TODO : Converts a nnkNone into the Min C Language
proc cminEmpty            (code :NimNode) :string=  assert code.kind == nnkEmpty            ; todo(code)  ## TODO : Converts a nnkEmpty into the Min C Language
proc cminIdent            (code :NimNode) :string=  assert code.kind == nnkIdent            ; todo(code)  ## TODO : Converts a nnkIdent into the Min C Language
proc cminSym              (code :NimNode) :string=  assert code.kind == nnkSym              ; todo(code)  ## TODO : Converts a nnkSym into the Min C Language
proc cminType             (code :NimNode) :string=  assert code.kind == nnkType             ; todo(code)  ## TODO : Converts a nnkType into the Min C Language
proc cminCharLit          (code :NimNode) :string=  assert code.kind == nnkCharLit          ; todo(code)  ## TODO : Converts a nnkCharLit into the Min C Language
proc cminIntLit           (code :NimNode) :string=  assert code.kind == nnkIntLit           ; todo(code)  ## TODO : Converts a nnkIntLit into the Min C Language
proc cminInt8Lit          (code :NimNode) :string=  assert code.kind == nnkInt8Lit          ; todo(code)  ## TODO : Converts a nnkInt8Lit into the Min C Language
proc cminInt16Lit         (code :NimNode) :string=  assert code.kind == nnkInt16Lit         ; todo(code)  ## TODO : Converts a nnkInt16Lit into the Min C Language
proc cminInt32Lit         (code :NimNode) :string=  assert code.kind == nnkInt32Lit         ; todo(code)  ## TODO : Converts a nnkInt32Lit into the Min C Language
proc cminInt64Lit         (code :NimNode) :string=  assert code.kind == nnkInt64Lit         ; todo(code)  ## TODO : Converts a nnkInt64Lit into the Min C Language
proc cminUIntLit          (code :NimNode) :string=  assert code.kind == nnkUIntLit          ; todo(code)  ## TODO : Converts a nnkUIntLit into the Min C Language
proc cminUInt8Lit         (code :NimNode) :string=  assert code.kind == nnkUInt8Lit         ; todo(code)  ## TODO : Converts a nnkUInt8Lit into the Min C Language
proc cminUInt16Lit        (code :NimNode) :string=  assert code.kind == nnkUInt16Lit        ; todo(code)  ## TODO : Converts a nnkUInt16Lit into the Min C Language
proc cminUInt32Lit        (code :NimNode) :string=  assert code.kind == nnkUInt32Lit        ; todo(code)  ## TODO : Converts a nnkUInt32Lit into the Min C Language
proc cminUInt64Lit        (code :NimNode) :string=  assert code.kind == nnkUInt64Lit        ; todo(code)  ## TODO : Converts a nnkUInt64Lit into the Min C Language
proc cminFloatLit         (code :NimNode) :string=  assert code.kind == nnkFloatLit         ; todo(code)  ## TODO : Converts a nnkFloatLit into the Min C Language
proc cminFloat32Lit       (code :NimNode) :string=  assert code.kind == nnkFloat32Lit       ; todo(code)  ## TODO : Converts a nnkFloat32Lit into the Min C Language
proc cminFloat64Lit       (code :NimNode) :string=  assert code.kind == nnkFloat64Lit       ; todo(code)  ## TODO : Converts a nnkFloat64Lit into the Min C Language
proc cminFloat128Lit      (code :NimNode) :string=  assert code.kind == nnkFloat128Lit      ; todo(code)  ## TODO : Converts a nnkFloat128Lit into the Min C Language
proc cminStrLit           (code :NimNode) :string=  assert code.kind == nnkStrLit           ; todo(code)  ## TODO : Converts a nnkStrLit into the Min C Language
proc cminRStrLit          (code :NimNode) :string=  assert code.kind == nnkRStrLit          ; todo(code)  ## TODO : Converts a nnkRStrLit into the Min C Language
proc cminTripleStrLit     (code :NimNode) :string=  assert code.kind == nnkTripleStrLit     ; todo(code)  ## TODO : Converts a nnkTripleStrLit into the Min C Language
proc cminNilLit           (code :NimNode) :string=  assert code.kind == nnkNilLit           ; todo(code)  ## TODO : Converts a nnkNilLit into the Min C Language
proc cminComesFrom        (code :NimNode) :string=  assert code.kind == nnkComesFrom        ; todo(code)  ## TODO : Converts a nnkComesFrom into the Min C Language
proc cminDotCall          (code :NimNode) :string=  assert code.kind == nnkDotCall          ; todo(code)  ## TODO : Converts a nnkDotCall into the Min C Language
proc cminCommand          (code :NimNode) :string=  assert code.kind == nnkCommand          ; todo(code)  ## TODO : Converts a nnkCommand into the Min C Language
proc cminCall             (code :NimNode) :string=  assert code.kind == nnkCall             ; todo(code)  ## TODO : Converts a nnkCall into the Min C Language
proc cminCallStrLit       (code :NimNode) :string=  assert code.kind == nnkCallStrLit       ; todo(code)  ## TODO : Converts a nnkCallStrLit into the Min C Language
proc cminInfix            (code :NimNode) :string=  assert code.kind == nnkInfix            ; todo(code)  ## TODO : Converts a nnkInfix into the Min C Language
proc cminPrefix           (code :NimNode) :string=  assert code.kind == nnkPrefix           ; todo(code)  ## TODO : Converts a nnkPrefix into the Min C Language
proc cminPostfix          (code :NimNode) :string=  assert code.kind == nnkPostfix          ; todo(code)  ## TODO : Converts a nnkPostfix into the Min C Language
proc cminHiddenCallConv   (code :NimNode) :string=  assert code.kind == nnkHiddenCallConv   ; todo(code)  ## TODO : Converts a nnkHiddenCallConv into the Min C Language
proc cminExprEqExpr       (code :NimNode) :string=  assert code.kind == nnkExprEqExpr       ; todo(code)  ## TODO : Converts a nnkExprEqExpr into the Min C Language
proc cminExprColonExpr    (code :NimNode) :string=  assert code.kind == nnkExprColonExpr    ; todo(code)  ## TODO : Converts a nnkExprColonExpr into the Min C Language
proc cminIdentDefs        (code :NimNode) :string=  assert code.kind == nnkIdentDefs        ; todo(code)  ## TODO : Converts a nnkIdentDefs into the Min C Language
proc cminVarTuple         (code :NimNode) :string=  assert code.kind == nnkVarTuple         ; todo(code)  ## TODO : Converts a nnkVarTuple into the Min C Language
proc cminPar              (code :NimNode) :string=  assert code.kind == nnkPar              ; todo(code)  ## TODO : Converts a nnkPar into the Min C Language
proc cminObjConstr        (code :NimNode) :string=  assert code.kind == nnkObjConstr        ; todo(code)  ## TODO : Converts a nnkObjConstr into the Min C Language
proc cminCurly            (code :NimNode) :string=  assert code.kind == nnkCurly            ; todo(code)  ## TODO : Converts a nnkCurly into the Min C Language
proc cminCurlyExpr        (code :NimNode) :string=  assert code.kind == nnkCurlyExpr        ; todo(code)  ## TODO : Converts a nnkCurlyExpr into the Min C Language
proc cminBracket          (code :NimNode) :string=  assert code.kind == nnkBracket          ; todo(code)  ## TODO : Converts a nnkBracket into the Min C Language
proc cminBracketExpr      (code :NimNode) :string=  assert code.kind == nnkBracketExpr      ; todo(code)  ## TODO : Converts a nnkBracketExpr into the Min C Language
proc cminPragmaExpr       (code :NimNode) :string=  assert code.kind == nnkPragmaExpr       ; todo(code)  ## TODO : Converts a nnkPragmaExpr into the Min C Language
proc cminRange            (code :NimNode) :string=  assert code.kind == nnkRange            ; todo(code)  ## TODO : Converts a nnkRange into the Min C Language
proc cminDotExpr          (code :NimNode) :string=  assert code.kind == nnkDotExpr          ; todo(code)  ## TODO : Converts a nnkDotExpr into the Min C Language
proc cminCheckedFieldExpr (code :NimNode) :string=  assert code.kind == nnkCheckedFieldExpr ; todo(code)  ## TODO : Converts a nnkCheckedFieldExpr into the Min C Language
proc cminDerefExpr        (code :NimNode) :string=  assert code.kind == nnkDerefExpr        ; todo(code)  ## TODO : Converts a nnkDerefExpr into the Min C Language
proc cminIfExpr           (code :NimNode) :string=  assert code.kind == nnkIfExpr           ; todo(code)  ## TODO : Converts a nnkIfExpr into the Min C Language
proc cminElifExpr         (code :NimNode) :string=  assert code.kind == nnkElifExpr         ; todo(code)  ## TODO : Converts a nnkElifExpr into the Min C Language
proc cminElseExpr         (code :NimNode) :string=  assert code.kind == nnkElseExpr         ; todo(code)  ## TODO : Converts a nnkElseExpr into the Min C Language
proc cminLambda           (code :NimNode) :string=  assert code.kind == nnkLambda           ; todo(code)  ## TODO : Converts a nnkLambda into the Min C Language
proc cminDo               (code :NimNode) :string=  assert code.kind == nnkDo               ; todo(code)  ## TODO : Converts a nnkDo into the Min C Language
proc cminAccQuoted        (code :NimNode) :string=  assert code.kind == nnkAccQuoted        ; todo(code)  ## TODO : Converts a nnkAccQuoted into the Min C Language
proc cminTableConstr      (code :NimNode) :string=  assert code.kind == nnkTableConstr      ; todo(code)  ## TODO : Converts a nnkTableConstr into the Min C Language
proc cminBind             (code :NimNode) :string=  assert code.kind == nnkBind             ; todo(code)  ## TODO : Converts a nnkBind into the Min C Language
proc cminClosedSymChoice  (code :NimNode) :string=  assert code.kind == nnkClosedSymChoice  ; todo(code)  ## TODO : Converts a nnkClosedSymChoice into the Min C Language
proc cminOpenSymChoice    (code :NimNode) :string=  assert code.kind == nnkOpenSymChoice    ; todo(code)  ## TODO : Converts a nnkOpenSymChoice into the Min C Language
proc cminHiddenStdConv    (code :NimNode) :string=  assert code.kind == nnkHiddenStdConv    ; todo(code)  ## TODO : Converts a nnkHiddenStdConv into the Min C Language
proc cminHiddenSubConv    (code :NimNode) :string=  assert code.kind == nnkHiddenSubConv    ; todo(code)  ## TODO : Converts a nnkHiddenSubConv into the Min C Language
proc cminConv             (code :NimNode) :string=  assert code.kind == nnkConv             ; todo(code)  ## TODO : Converts a nnkConv into the Min C Language
proc cminCast             (code :NimNode) :string=  assert code.kind == nnkCast             ; todo(code)  ## TODO : Converts a nnkCast into the Min C Language
proc cminStaticExpr       (code :NimNode) :string=  assert code.kind == nnkStaticExpr       ; todo(code)  ## TODO : Converts a nnkStaticExpr into the Min C Language
proc cminAddr             (code :NimNode) :string=  assert code.kind == nnkAddr             ; todo(code)  ## TODO : Converts a nnkAddr into the Min C Language
proc cminHiddenAddr       (code :NimNode) :string=  assert code.kind == nnkHiddenAddr       ; todo(code)  ## TODO : Converts a nnkHiddenAddr into the Min C Language
proc cminHiddenDeref      (code :NimNode) :string=  assert code.kind == nnkHiddenDeref      ; todo(code)  ## TODO : Converts a nnkHiddenDeref into the Min C Language
proc cminObjDownConv      (code :NimNode) :string=  assert code.kind == nnkObjDownConv      ; todo(code)  ## TODO : Converts a nnkObjDownConv into the Min C Language
proc cminObjUpConv        (code :NimNode) :string=  assert code.kind == nnkObjUpConv        ; todo(code)  ## TODO : Converts a nnkObjUpConv into the Min C Language
proc cminChckRangeF       (code :NimNode) :string=  assert code.kind == nnkChckRangeF       ; todo(code)  ## TODO : Converts a nnkChckRangeF into the Min C Language
proc cminChckRange64      (code :NimNode) :string=  assert code.kind == nnkChckRange64      ; todo(code)  ## TODO : Converts a nnkChckRange64 into the Min C Language
proc cminChckRange        (code :NimNode) :string=  assert code.kind == nnkChckRange        ; todo(code)  ## TODO : Converts a nnkChckRange into the Min C Language
proc cminStringToCString  (code :NimNode) :string=  assert code.kind == nnkStringToCString  ; todo(code)  ## TODO : Converts a nnkStringToCString into the Min C Language
proc cminCStringToString  (code :NimNode) :string=  assert code.kind == nnkCStringToString  ; todo(code)  ## TODO : Converts a nnkCStringToString into the Min C Language
proc cminAsgn             (code :NimNode) :string=  assert code.kind == nnkAsgn             ; todo(code)  ## TODO : Converts a nnkAsgn into the Min C Language
proc cminFastAsgn         (code :NimNode) :string=  assert code.kind == nnkFastAsgn         ; todo(code)  ## TODO : Converts a nnkFastAsgn into the Min C Language
proc cminGenericParams    (code :NimNode) :string=  assert code.kind == nnkGenericParams    ; todo(code)  ## TODO : Converts a nnkGenericParams into the Min C Language
proc cminFormalParams     (code :NimNode) :string=  assert code.kind == nnkFormalParams     ; todo(code)  ## TODO : Converts a nnkFormalParams into the Min C Language
proc cminOfInherit        (code :NimNode) :string=  assert code.kind == nnkOfInherit        ; todo(code)  ## TODO : Converts a nnkOfInherit into the Min C Language
proc cminImportAs         (code :NimNode) :string=  assert code.kind == nnkImportAs         ; todo(code)  ## TODO : Converts a nnkImportAs into the Min C Language
proc cminProcDef          (code :NimNode) :string
proc cminMethodDef        (code :NimNode) :string=  assert code.kind == nnkMethodDef        ; todo(code)  ## TODO : Converts a nnkMethodDef into the Min C Language
proc cminConverterDef     (code :NimNode) :string=  assert code.kind == nnkConverterDef     ; todo(code)  ## TODO : Converts a nnkConverterDef into the Min C Language
proc cminMacroDef         (code :NimNode) :string=  assert code.kind == nnkMacroDef         ; todo(code)  ## TODO : Converts a nnkMacroDef into the Min C Language
proc cminTemplateDef      (code :NimNode) :string=  assert code.kind == nnkTemplateDef      ; todo(code)  ## TODO : Converts a nnkTemplateDef into the Min C Language
proc cminIteratorDef      (code :NimNode) :string=  assert code.kind == nnkIteratorDef      ; todo(code)  ## TODO : Converts a nnkIteratorDef into the Min C Language
proc cminOfBranch         (code :NimNode) :string=  assert code.kind == nnkOfBranch         ; todo(code)  ## TODO : Converts a nnkOfBranch into the Min C Language
proc cminElifBranch       (code :NimNode) :string=  assert code.kind == nnkElifBranch       ; todo(code)  ## TODO : Converts a nnkElifBranch into the Min C Language
proc cminExceptBranch     (code :NimNode) :string=  assert code.kind == nnkExceptBranch     ; todo(code)  ## TODO : Converts a nnkExceptBranch into the Min C Language
proc cminElse             (code :NimNode) :string=  assert code.kind == nnkElse             ; todo(code)  ## TODO : Converts a nnkElse into the Min C Language
proc cminAsmStmt          (code :NimNode) :string=  assert code.kind == nnkAsmStmt          ; todo(code)  ## TODO : Converts a nnkAsmStmt into the Min C Language
proc cminPragma           (code :NimNode) :string=  assert code.kind == nnkPragma           ; todo(code)  ## TODO : Converts a nnkPragma into the Min C Language
proc cminPragmaBlock      (code :NimNode) :string=  assert code.kind == nnkPragmaBlock      ; todo(code)  ## TODO : Converts a nnkPragmaBlock into the Min C Language
proc cminIfStmt           (code :NimNode) :string=  assert code.kind == nnkIfStmt           ; todo(code)  ## TODO : Converts a nnkIfStmt into the Min C Language
proc cminWhenStmt         (code :NimNode) :string=  assert code.kind == nnkWhenStmt         ; todo(code)  ## TODO : Converts a nnkWhenStmt into the Min C Language
proc cminForStmt          (code :NimNode) :string=  assert code.kind == nnkForStmt          ; todo(code)  ## TODO : Converts a nnkForStmt into the Min C Language
proc cminParForStmt       (code :NimNode) :string=  assert code.kind == nnkParForStmt       ; todo(code)  ## TODO : Converts a nnkParForStmt into the Min C Language
proc cminWhileStmt        (code :NimNode) :string=  assert code.kind == nnkWhileStmt        ; todo(code)  ## TODO : Converts a nnkWhileStmt into the Min C Language
proc cminCaseStmt         (code :NimNode) :string=  assert code.kind == nnkCaseStmt         ; todo(code)  ## TODO : Converts a nnkCaseStmt into the Min C Language
proc cminTypeSection      (code :NimNode) :string=  assert code.kind == nnkTypeSection      ; todo(code)  ## TODO : Converts a nnkTypeSection into the Min C Language
proc cminVarSection       (code :NimNode) :string=  assert code.kind == nnkVarSection       ; todo(code)  ## TODO : Converts a nnkVarSection into the Min C Language
proc cminLetSection       (code :NimNode) :string=  assert code.kind == nnkLetSection       ; todo(code)  ## TODO : Converts a nnkLetSection into the Min C Language
proc cminConstSection     (code :NimNode) :string=  assert code.kind == nnkConstSection     ; todo(code)  ## TODO : Converts a nnkConstSection into the Min C Language
proc cminConstDef         (code :NimNode) :string=  assert code.kind == nnkConstDef         ; todo(code)  ## TODO : Converts a nnkConstDef into the Min C Language
proc cminTypeDef          (code :NimNode) :string=  assert code.kind == nnkTypeDef          ; todo(code)  ## TODO : Converts a nnkTypeDef into the Min C Language
proc cminYieldStmt        (code :NimNode) :string=  assert code.kind == nnkYieldStmt        ; todo(code)  ## TODO : Converts a nnkYieldStmt into the Min C Language
proc cminDefer            (code :NimNode) :string=  assert code.kind == nnkDefer            ; todo(code)  ## TODO : Converts a nnkDefer into the Min C Language
proc cminTryStmt          (code :NimNode) :string=  assert code.kind == nnkTryStmt          ; todo(code)  ## TODO : Converts a nnkTryStmt into the Min C Language
proc cminFinally          (code :NimNode) :string=  assert code.kind == nnkFinally          ; todo(code)  ## TODO : Converts a nnkFinally into the Min C Language
proc cminRaiseStmt        (code :NimNode) :string=  assert code.kind == nnkRaiseStmt        ; todo(code)  ## TODO : Converts a nnkRaiseStmt into the Min C Language
proc cminReturnStmt       (code :NimNode) :string=  assert code.kind == nnkReturnStmt       ; todo(code)  ## TODO : Converts a nnkReturnStmt into the Min C Language
proc cminBreakStmt        (code :NimNode) :string=  assert code.kind == nnkBreakStmt        ; todo(code)  ## TODO : Converts a nnkBreakStmt into the Min C Language
proc cminContinueStmt     (code :NimNode) :string=  assert code.kind == nnkContinueStmt     ; todo(code)  ## TODO : Converts a nnkContinueStmt into the Min C Language
proc cminBlockStmt        (code :NimNode) :string=  assert code.kind == nnkBlockStmt        ; todo(code)  ## TODO : Converts a nnkBlockStmt into the Min C Language
proc cminStaticStmt       (code :NimNode) :string=  assert code.kind == nnkStaticStmt       ; todo(code)  ## TODO : Converts a nnkStaticStmt into the Min C Language
proc cminDiscardStmt      (code :NimNode) :string=  assert code.kind == nnkDiscardStmt      ; todo(code)  ## TODO : Converts a nnkDiscardStmt into the Min C Language
proc cminStmtList         (code :NimNode) :string=  assert code.kind == nnkStmtList         ; todo(code)  ## TODO : Converts a nnkStmtList into the Min C Language
proc cminImportStmt       (code :NimNode) :string=  assert code.kind == nnkImportStmt       ; todo(code)  ## TODO : Converts a nnkImportStmt into the Min C Language
proc cminImportExceptStmt (code :NimNode) :string=  assert code.kind == nnkImportExceptStmt ; todo(code)  ## TODO : Converts a nnkImportExceptStmt into the Min C Language
proc cminExportStmt       (code :NimNode) :string=  assert code.kind == nnkExportStmt       ; todo(code)  ## TODO : Converts a nnkExportStmt into the Min C Language
proc cminExportExceptStmt (code :NimNode) :string=  assert code.kind == nnkExportExceptStmt ; todo(code)  ## TODO : Converts a nnkExportExceptStmt into the Min C Language
proc cminFromStmt         (code :NimNode) :string=  assert code.kind == nnkFromStmt         ; todo(code)  ## TODO : Converts a nnkFromStmt into the Min C Language
proc cminIncludeStmt      (code :NimNode) :string=  assert code.kind == nnkIncludeStmt      ; todo(code)  ## TODO : Converts a nnkIncludeStmt into the Min C Language
proc cminBindStmt         (code :NimNode) :string=  assert code.kind == nnkBindStmt         ; todo(code)  ## TODO : Converts a nnkBindStmt into the Min C Language
proc cminMixinStmt        (code :NimNode) :string=  assert code.kind == nnkMixinStmt        ; todo(code)  ## TODO : Converts a nnkMixinStmt into the Min C Language
proc cminUsingStmt        (code :NimNode) :string=  assert code.kind == nnkUsingStmt        ; todo(code)  ## TODO : Converts a nnkUsingStmt into the Min C Language
proc cminCommentStmt      (code :NimNode) :string=  assert code.kind == nnkCommentStmt      ; todo(code)  ## TODO : Converts a nnkCommentStmt into the Min C Language
proc cminStmtListExpr     (code :NimNode) :string=  assert code.kind == nnkStmtListExpr     ; todo(code)  ## TODO : Converts a nnkStmtListExpr into the Min C Language
proc cminBlockExpr        (code :NimNode) :string=  assert code.kind == nnkBlockExpr        ; todo(code)  ## TODO : Converts a nnkBlockExpr into the Min C Language
proc cminStmtListType     (code :NimNode) :string=  assert code.kind == nnkStmtListType     ; todo(code)  ## TODO : Converts a nnkStmtListType into the Min C Language
proc cminBlockType        (code :NimNode) :string=  assert code.kind == nnkBlockType        ; todo(code)  ## TODO : Converts a nnkBlockType into the Min C Language
proc cminWith             (code :NimNode) :string=  assert code.kind == nnkWith             ; todo(code)  ## TODO : Converts a nnkWith into the Min C Language
proc cminWithout          (code :NimNode) :string=  assert code.kind == nnkWithout          ; todo(code)  ## TODO : Converts a nnkWithout into the Min C Language
proc cminTypeOfExpr       (code :NimNode) :string=  assert code.kind == nnkTypeOfExpr       ; todo(code)  ## TODO : Converts a nnkTypeOfExpr into the Min C Language
proc cminObjectTy         (code :NimNode) :string=  assert code.kind == nnkObjectTy         ; todo(code)  ## TODO : Converts a nnkObjectTy into the Min C Language
proc cminTupleTy          (code :NimNode) :string=  assert code.kind == nnkTupleTy          ; todo(code)  ## TODO : Converts a nnkTupleTy into the Min C Language
proc cminTupleClassTy     (code :NimNode) :string=  assert code.kind == nnkTupleClassTy     ; todo(code)  ## TODO : Converts a nnkTupleClassTy into the Min C Language
proc cminTypeClassTy      (code :NimNode) :string=  assert code.kind == nnkTypeClassTy      ; todo(code)  ## TODO : Converts a nnkTypeClassTy into the Min C Language
proc cminStaticTy         (code :NimNode) :string=  assert code.kind == nnkStaticTy         ; todo(code)  ## TODO : Converts a nnkStaticTy into the Min C Language
proc cminRecList          (code :NimNode) :string=  assert code.kind == nnkRecList          ; todo(code)  ## TODO : Converts a nnkRecList into the Min C Language
proc cminRecCase          (code :NimNode) :string=  assert code.kind == nnkRecCase          ; todo(code)  ## TODO : Converts a nnkRecCase into the Min C Language
proc cminRecWhen          (code :NimNode) :string=  assert code.kind == nnkRecWhen          ; todo(code)  ## TODO : Converts a nnkRecWhen into the Min C Language
proc cminRefTy            (code :NimNode) :string=  assert code.kind == nnkRefTy            ; todo(code)  ## TODO : Converts a nnkRefTy into the Min C Language
proc cminPtrTy            (code :NimNode) :string=  assert code.kind == nnkPtrTy            ; todo(code)  ## TODO : Converts a nnkPtrTy into the Min C Language
proc cminVarTy            (code :NimNode) :string=  assert code.kind == nnkVarTy            ; todo(code)  ## TODO : Converts a nnkVarTy into the Min C Language
proc cminConstTy          (code :NimNode) :string=  assert code.kind == nnkConstTy          ; todo(code)  ## TODO : Converts a nnkConstTy into the Min C Language
proc cminOutTy            (code :NimNode) :string=  assert code.kind == nnkOutTy            ; todo(code)  ## TODO : Converts a nnkOutTy into the Min C Language
proc cminDistinctTy       (code :NimNode) :string=  assert code.kind == nnkDistinctTy       ; todo(code)  ## TODO : Converts a nnkDistinctTy into the Min C Language
proc cminProcTy           (code :NimNode) :string=  assert code.kind == nnkProcTy           ; todo(code)  ## TODO : Converts a nnkProcTy into the Min C Language
proc cminIteratorTy       (code :NimNode) :string=  assert code.kind == nnkIteratorTy       ; todo(code)  ## TODO : Converts a nnkIteratorTy into the Min C Language
proc cminSinkAsgn         (code :NimNode) :string=  assert code.kind == nnkSinkAsgn         ; todo(code)  ## TODO : Converts a nnkSinkAsgn into the Min C Language
proc cminEnumTy           (code :NimNode) :string=  assert code.kind == nnkEnumTy           ; todo(code)  ## TODO : Converts a nnkEnumTy into the Min C Language
proc cminEnumFieldDef     (code :NimNode) :string=  assert code.kind == nnkEnumFieldDef     ; todo(code)  ## TODO : Converts a nnkEnumFieldDef into the Min C Language
proc cminArgList          (code :NimNode) :string=  assert code.kind == nnkArgList          ; todo(code)  ## TODO : Converts a nnkArgList into the Min C Language
proc cminPattern          (code :NimNode) :string=  assert code.kind == nnkPattern          ; todo(code)  ## TODO : Converts a nnkPattern into the Min C Language
proc cminHiddenTryStmt    (code :NimNode) :string=  assert code.kind == nnkHiddenTryStmt    ; todo(code)  ## TODO : Converts a nnkHiddenTryStmt into the Min C Language
proc cminClosure          (code :NimNode) :string=  assert code.kind == nnkClosure          ; todo(code)  ## TODO : Converts a nnkClosure into the Min C Language
proc cminGotoState        (code :NimNode) :string=  assert code.kind == nnkGotoState        ; todo(code)  ## TODO : Converts a nnkGotoState into the Min C Language
proc cminState            (code :NimNode) :string=  assert code.kind == nnkState            ; todo(code)  ## TODO : Converts a nnkState into the Min C Language
proc cminBreakState       (code :NimNode) :string=  assert code.kind == nnkBreakState       ; todo(code)  ## TODO : Converts a nnkBreakState into the Min C Language
proc cminFuncDef          (code :NimNode) :string=  assert code.kind == nnkFuncDef          ; todo(code)  ## TODO : Converts a nnkFuncDef into the Min C Language
proc cminTupleConstr      (code :NimNode) :string=  assert code.kind == nnkTupleConstr      ; todo(code)  ## TODO : Converts a nnkTupleConstr into the Min C Language
proc cminError            (code :NimNode) :string=  assert code.kind == nnkError            ; todo(code)  ## TODO : Converts a nnkError into the Min C Language



