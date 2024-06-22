const Title = "Procedures"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic Proc"       : check "01"
test name "02 | Args: Basic"      : check "02"
test name "03 | Args: Complex"    : check "03"
test name "04 | Visibility"       : check "04"
test name "05 | Varargs"          : check "05"
# Pragmas
test name "10 | Pragma: inline"   : check "10"
test name "11 | Pragma: noreturn" : check "11"
# Func
test name "50 | Func: Basic"      : check "50"
test name "51 | Func: pure"       : check "51"

