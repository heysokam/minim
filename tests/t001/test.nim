const Title = "Hello42"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic Code Generation" : check "01"
