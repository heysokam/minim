# @warning MUST be `include`d, not `import`ed
#_______________________________________
# @section Dependencies used by all tests
# @deps std
import std/unittest
from std/os import parentDir, lastPathPart, `/`, execShellCmd
from std/osproc import execProcess
from std/strformat import `&`
from std/strutils import join

#_______________________________________
# @section General Tools
#_____________________________
type UnitTestError = object of CatchableError
template err *(msg :varargs[string, `$`]) :void= raise newException(UnitTestError, msg.join(""))
proc sh *(cmd :string) :void=
  try: os.execShellCmd(cmd)
  except CatchableError: err "Failed to execute the command:\n  ",cmd

#_______________________________________
# @section Tests Tools
#_____________________________
template name *(
    descr : string;
    testN : string = "test";
    title : string = "";
  ) :string=
  ## @descr Confusing syntax. Returns the correct prefix for the given test information
  let t = when declared(Title): Title else: title
  let n = when declared(tName): tName else: testN
  n&": " & (
    if t != "" : t&" | " else: ""
    ) & descr
#_____________________________
proc minc *(args :varargs[string, `$`]) :void=  sh "minc " & args.join(" ")
proc compile *(file :string; outDir :string) :string=
  let tmp = outDir/"tmp.c"
  try    : minc "cc", file, "tmp.c", "--codeDir:"&outDir
  except : err "Something went wrong when compiling a tmp file:  ", tmp
  try    : result = readFile(tmp)
  except : err "Something went wrong when reading the resulting tmp file:  ", tmp
#_____________________________
template compile *(file :string) :string=  compile file, thisDir

