const Title = "Variables"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "Const: Normal definition"  : check "01"
test name "Const: Private definition" : check "02"
test name "Let: Private definition"   : check "03"
test name "Var: Private definition"   : check "04"
test name "Return: Identifier"        : check "05"
test name "Pragma: Persist"           : check "06"
test name "Assignment: Arrays"        : check "07"
test name "Assignment: Identifiers"   : check "08"
test name "Assignment: Literals"      : check "09"

#  TODO: Convert  _  to  {0}  and  {}
#  TODO: Multiline strings
#  TODO: chars
#  TODO: Array Value
#  TODO: Object Value
#  TODO: All literal types

