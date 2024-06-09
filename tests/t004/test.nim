const Title = "Standalone Pragmas"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Error"          : check "01"
test name "02 | Warning"        : check "02"
test name "03 | Emit"           : check "03"
test name "04 | Namespace"      : check "04"
test name "05 | Define"         : check "05"
test name "06 | C Pragma: once" : check "06"

