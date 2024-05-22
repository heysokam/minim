#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/errors
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
# TODO
type ProcError      * = object of CatchableError
type AffixError     * = object of CatchableError
type CallsError     * = object of CatchableError
type PragmaError    * = object of CatchableError
type ConditionError * = object of CatchableError
type ObjectError    * = object of CatchableError
type AssignError    * = object of CatchableError
#_____________________________
type SomeCodegenError =
  AffixError     | CallsError   | VariableError | PragmaError |
  ConditionError | ObjectError  | AssignError   | ProcError   |
  LiteralError   | BracketError | IdentError
#_____________________________
proc trigger *(
    code : PNode;
    excp : typedesc[SomeCodegenError];
    msg  : varargs[string, `$`];
    pfx  : string= cfg.Prefix;
  ) :void=
  errors.trigger excp, &"\n{code.treeRepr}\n{code.renderTree}\n{msg}", pfx

