const Title = "Modules and Namespaces"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Include: Simple case"       : check "01"
test name "02 | Include: Global: @"         : check "02"
test name "03 | Include: Global: \"<...>\"" : check "03"
test name "04 | Include: Local: .h"         : check "04"
test name "05 | Include: Local: .c"         : check "05"
test name "06 | Include: Local: .cm"        : check "06"
# test name "07 | Include: Global: .cm"       : check "07"

# Blocks
test name "90 | Block: Simple case"        : check "90"
test name "91 | Block: Named"              : check "91"

# TODO: Imports   (at #50)

