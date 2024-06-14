const Title = "Control Flow"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
# Keywords
test name "01 | Keywords"                 : check "01"

# While
test name "02 | While: Basic"             : check "02"
test name "03 | While: Complex logic"     : check "03"

# When
test name "10 | When: Basic"              : check "10"
test name "11 | When: else branch"        : check "11"
test name "12 | When: elif branches"      : check "12"
test name "13 | When: Multi-condition"    : check "13"
# When: TODO Multifile                 : When inside .h files
# When: TODO SingleFile + SingleHeader : When inside .h sections

# Case
test name "20 | Case: Basic"              : check "20"
test name "21 | Case: Fallthrough"        : check "21"
# test name "22 | Case: Should-break"    : check "22"

# For
test name "30 | For: Basic"               : check "30"

# If
test name "40 | If: Basic"                : check "40"
test name "41 | If: else branch"          : check "41"
test name "42 | If: elif branches"        : check "42"
test name "43 | If: Multi-condition"      : check "43"

# Ternary
test name "50 | Ternary: Basic"           : check "50"
test name "51 | Ternary: Multi-condition" : check "51"
# test name "52 | Ternary: elif branches"   : check "52"

# do..while
test name "60 | DoWhile: Basic"           : check "60"

