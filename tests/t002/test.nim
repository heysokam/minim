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
test name "01 | Const: Normal definition"  : check "01"
test name "02 | Const: Private definition" : check "02"
test name "03 | Let: Private definition"   : check "03"
test name "04 | Var: Private definition"   : check "04"
test name "05 | Return: Identifier"        : check "05"
test name "06 | Pragma: Persist"           : check "06"
test name "07 | Assignment: Arrays"        : check "07"
test name "08 | Assignment: Identifiers"   : check "08"
test name "09 | Assignment: Literals"      : check "09"

#  TODO: Convert  _  to  {0}  and  {}
#  TODO: Multiline strings
#  TODO: chars
#  TODO: Array Value
#  TODO: Object Value
#  TODO: All literal types

