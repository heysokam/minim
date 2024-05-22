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
test name "Arrays: Definition"        : check "06"

#  TODO: Convert  _  to  {0}  and  {}
#  TODO: Multiline strings
#  TODO: chars
#  TODO: Array Value
#  TODO: Object Value

