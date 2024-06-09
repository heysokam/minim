const Title = "Type Definitions"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic Typedef"   : check "01"
test name "02 | Object: Basic"   : check "02"
test name "03 | Object: Stub"    : check "03"
# test name "04 | Object: Nested " : check "04"
test name "05 | Proc: Basic "    : check "05"

