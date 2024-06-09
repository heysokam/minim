const Title = "DummyTemplate"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "00 | dummy check"           : check "00"
test name "01 | Basic Code Generation" : check "01"
