const Title = "Control Flow"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "Basic Cases" : check "01"

