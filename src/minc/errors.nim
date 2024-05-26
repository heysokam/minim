#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/errors as nstdErr
# @deps slate
import slate/nimc as nim
# @deps minc
import ./cfg


#______________________________________________________
# @section Codegen: Errors
#_____________________________
type LiteralError   * = object of CatchableError
type VariableError  * = object of CatchableError
type BracketError   * = object of CatchableError
type IdentError     * = object of CatchableError
type PragmaError    * = object of CatchableError
type CallError      * = object of CatchableError
type FlowCtrlError  * = object of CatchableError
# TODO
type ProcError      * = object of CatchableError
type AffixError     * = object of CatchableError
type ConditionError * = object of CatchableError
type ObjectError    * = object of CatchableError
type AssignError    * = object of CatchableError
#_____________________________
type SomeCodegenError =
  AffixError     | CallError    | VariableError | PragmaError |
  ConditionError | ObjectError  | AssignError   | ProcError   |
  LiteralError   | BracketError | IdentError    | FlowCtrlError
#_____________________________
proc trigger *(
    code : PNode;
    excp : typedesc[SomeCodegenError];
    msg  : varargs[string, `$`];
    pfx  : string= cfg.Prefix;
  ) :void=
  nstdErr.trigger excp, &"\n{code.treeRepr}\n{code.renderTree}\n{msg}", pfx

