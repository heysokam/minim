#_______________________________________
# @deps tests
template tName:string= currentSourcePath.parentDir.lastPathPart()
include ../base
resetID()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "correct sum 2": check 5+5 == 10

