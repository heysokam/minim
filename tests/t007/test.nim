const Title = "Control Flow"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic Cases"          : check "01"
test name "02 | While: Basic"         : check "02"
test name "03 | While: Complex logic" : check "02"

