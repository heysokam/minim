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
test name "05 | Pragma: inline"   : check "05"
test name "06 | Pragma: noreturn" : check "06"
test name "90 | Basic func"       : check "90"

