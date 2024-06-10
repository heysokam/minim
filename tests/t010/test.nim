const Title = "Affixes"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Prefix: ++"  : check "01"
test name "02 | Prefix: --"  : check "02"
test name "03 | Prefix: not" : check "03"
test name "04 | Prefix: -"   : check "04"
test name "05 | Prefix: +"   : check "05"

