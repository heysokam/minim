const Title = "Cast"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic cast[T](..)" : check "01"
test name "02 | Basic as syntax"   : check "02"
test name "03 | Basic @  syntax"   : check "03"

