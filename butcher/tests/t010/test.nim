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
# Prefixes
test name "01 | Prefix: ++"  : check "01"
test name "02 | Prefix: --"  : check "02"
test name "03 | Prefix: not" : check "03"
test name "04 | Prefix: -"   : check "04"
test name "05 | Prefix: +"   : check "05"

# Infixes
test name "10 | Infix: ->"   : check "10"
test name "11 | Infix: +="   : check "11"
test name "12 | Infix: -="   : check "12"
test name "13 | Infix: *="   : check "13"
test name "14 | Infix: /="   : check "14"
test name "15 | Infix: %="   : check "15"
test name "16 | Infix: <<="  : check "16"
test name "17 | Infix: >>="  : check "17"
test name "18 | Infix: &="   : check "18"
test name "19 | Infix: ^="   : check "19"
test name "20 | Infix: |="   : check "20"
test name "21 | Infix: +"    : check "21"
test name "22 | Infix: -"    : check "22"
test name "23 | Infix: *"    : check "23"
test name "24 | Infix: /"    : check "24"
test name "25 | Infix: %"    : check "25"
test name "26 | Infix: &"    : check "26"
test name "27 | Infix: |"    : check "27"
test name "28 | Infix: ^"    : check "28"
test name "29 | Infix: >>"   : check "29"
test name "30 | Infix: <<"   : check "30"
test name "31 | Infix: <"    : check "31"
test name "32 | Infix: >"    : check "32"
test name "33 | Infix: <="   : check "33"
test name "34 | Infix: >="   : check "34"
test name "35 | Infix: =="   : check "35"
test name "36 | Infix: !="   : check "36"
test name "37 | Infix: &&"   : check "37"
test name "38 | Infix: ||"   : check "38"

