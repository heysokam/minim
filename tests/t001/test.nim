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
test name "01 | Basic Proc"    : check "01"
test name "02 | Args: Basic"   : check "02"
test name "03 | Args: Complex" : check "03"

