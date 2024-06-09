const Title = "Discard"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Single identifier" : check "01"
test name "02 | Multi identifier"  : check "02"

