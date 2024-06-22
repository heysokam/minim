const Title = "Comments and Newlines"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic Doc Comment"   : check "01"
test name "02 | Multi-line Comments" : check "02"

