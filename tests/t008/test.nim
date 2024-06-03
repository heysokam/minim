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
test name "Basic Call"          : check "01"
test name "Basic Command"       : check "02"
test name "Multi-args: Call"    : check "03"
test name "Multi-args: Command" : check "04"
test name "Reserved Names"      : check "05"
# TODO: ObjectType(_) case
