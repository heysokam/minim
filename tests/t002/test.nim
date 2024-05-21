const Title = "Variables"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "Constants: Normal definition"  : check "01"
test name "Constants: Private definition" : check "02"

