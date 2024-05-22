const Title = "Variables"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "Const: Normal definition"  : check "01"
test name "Const: Private definition" : check "02"
test name "Let: Private definition"   : check "03"
test name "Var: Private definition"   : check "04"
test name "Pragma: Persist"           : check "05"

