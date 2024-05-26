const Title = "Comments and Newlines"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "Basic Doc Comment"   : check "01"
test name "Multi-line Comments" : check "02"

