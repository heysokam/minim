const Title = "Type Definitions"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "01 | Basic Typedef"               : check "01"
test name "02 | Multiword types"             : check "02"

# Objects
test name "10 | Object: Basic"               : check "10"
test name "11 | Object: Stub"                : check "11"
test name "12 | Object: With Arrays"         : check "12"

# Procs
test name "20 | Proc: Basic"                 : check "20"
test name "21 | Proc: Complex"               : check "21"

# Enums
test name "30 | Enum: Basic"                 : check "30"
test name "31 | Enum: Explicit Value"        : check "31"
test name "32 | Enum: Explicit Values"       : check "32"
test name "33 | Enum: {.unsafe.}"            : check "33"
test name "34 | Enum: {.unsafe.} + {.pure.}" : check "34"

# Unions
test name "40 | Union: Basic"                : check "40"
# test name "41 | Union: Array field types"    : check "41"

