const Title = "Includes"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Simple case"       : check "01"
test name "02 | Global: @"         : check "02"
test name "03 | Global: \"<...>\"" : check "03"
test name "04 | Local: .h"         : check "04"
test name "05 | Local: .c"         : check "05"
test name "06 | Local: .cm"        : check "06"
# test name "07 | Global : .cm"       : check "07"

