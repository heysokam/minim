const Title = "Category"
#_______________________________________
# @deps tests
template tName:string= currentSourcePath.parentDir.lastPathPart()
include ../base
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "correct sum": check 5+5 == 10

