const Title = "Calls and Procedures"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic Call"          : check "01"
test name "02 | Basic Command"       : check "02"
test name "03 | Multi-args: Call"    : check "03"
test name "04 | Multi-args: Command" : check "04"
test name "05 | Reserved Names"      : check "05"
# TODO: ObjectType(_) case
