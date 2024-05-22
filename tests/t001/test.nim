const Title = "Hello42"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "Basic Code Generation" : check "01"
