#_______________________________________
# @deps tests
template tName:string= currentSourcePath.parentDir.lastPathPart()
include ../base
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "dummy check": check 5+5 == 10
test name "dummy check 2": check 5+5 == 10
