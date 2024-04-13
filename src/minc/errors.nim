# @deps minc
import ./cfg

#______________________________________________________
# @section Codegen: Errors
#_____________________________
type LiteralError   * = object of CatchableError
# TODO
type ProcError      * = object of CatchableError
type AffixError     * = object of CatchableError
type CallsError     * = object of CatchableError
type VariableError  * = object of CatchableError
type PragmaError    * = object of CatchableError
type ConditionError * = object of CatchableError
type ObjectError    * = object of CatchableError
type AssignError    * = object of CatchableError
#_____________________________
type SomeCodegenError =
  AffixError     | CallsError  | VariableError | PragmaError |
  ConditionError | ObjectError | AssignError   | ProcError   |
  LiteralError
#_____________________________
func trigger *(err :typedesc[SomeCodegenError]; msg :varargs[string, `$`]) :void=
  ## @descr Raises the given {@arg err} with {@arg msg}.
  ## @note Adds formatting to {@arg msg} first.
  raise newException(err, cfg.Prefix & ": " & msg.join(" "))

