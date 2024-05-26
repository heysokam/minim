const Title = "Standalone Pragmas"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "Error"          : check "01"
test name "Warning"        : check "02"
test name "Emit"           : check "03"
test name "Namespace"      : check "04"
test name "Define"         : check "05"
test name "C Pragma: once" : check "06"

