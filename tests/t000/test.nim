const Title = "DummyTemplate"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "dummy check": check 5+5 == 10
