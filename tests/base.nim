# @warning MUST be `include`d, not `import`ed
#_______________________________________
# @section Dependencies used by all tests
# @deps std
import std/unittest
from std/paths import Path, parentDir, lastPathPart, `/`, changeFileExt
from std/files import removeFile, fileExists
from std/os import execShellCmd
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
# @section Paths
#_____________________________
converter toPath *(s :string) :Path= s.Path
proc readFile *(p :Path) :string {.borrow.}

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
  n.string&": " & (
    if t != "" : t&" | " else: ""
    ) & descr
#_____________________________
proc minc *(args :varargs[string, `$`]) :void=  sh "minc " & args.join(" ")
proc compile *(file,outDir :Path) :string=
  let tmp = outDir/"tmp.c"
  if fileExists(tmp): tmp.removeFile
  try    : minc "cc", file.string, "tmp.c", "--codeDir:"&outDir.string
  except : err "Something went wrong when compiling a tmp file:  ", tmp.string
  try    : result = readFile(tmp)
  except : err "Something went wrong when reading the resulting tmp file:  ", tmp.string
#_____________________________
template compile *(file :Path) :string=  compile file, thisDir
#_____________________________
template check *(cm,C :Path) :void=  check cm.compile == C.readFile
template check *(file :string) :void=  check thisDir/file.Path.changeFileExt(".cm"), thisDir/file.Path.changeFileExt(".c")

