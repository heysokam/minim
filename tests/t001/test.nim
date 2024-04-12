const Title = "Category"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.parentDir()
template tName:string= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Test
#_____________________________
test name "correct sum": check 5+5 == 10
test name "dummy check 2":
  let code = compile thisDir/"entry.cm"
  check code == readFile(thisDir/"ref.c")
