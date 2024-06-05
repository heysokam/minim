const Title = "Applications"
#_______________________________________
# @deps tests
include ../base
const thisDir = currentSourcePath.Path.parentDir()
template tName:Path= thisDir.lastPathPart()
#_______________________________________


#_______________________________________
# @section Folder Configuration
#_____________________________
const rootDir = thisDir/".."/".."
const appsDir = rootDir/"examples"

#_______________________________________
# @section Test Setup
#_____________________________
func prefixWith (file :Path; id :string) :Path= Path( id & "_" & file.lastPathPart.string )
#___________________
proc checkApp (id,name :string) :void=
  # Setup the test with the app's example code
  for dir in appsDir.walkDir:
    # Filter everything that doesn't match
    if dir.kind != pcDir: continue  # Skip non folders
    let dirName = dir.path.lastPathPart.string
    if not dirName.startsWith("app"): continue  # Skip folders that don't start with "app"
    if not dirName[3..^1].startsWith(id): continue  # Skip folders that do not match the ID
    # Move the files into the test folder
    for file in dir.path.walkDirRec:
      cp file, thisDir/file.prefixWith(id)
    # Get a list of all files that were moved
    var files :seq[Path]
    for file in thisDir.walkDir:
      if file.kind != pcFile: continue  # Skip folders
      if name notin file.path.string: continue  # Skip files that don't match the name
      files.add file.path
    if files.len > 2: err "UnitTesting multi-file apps is not supported yet"
    # Rename the files
    for file in files:
      let ext = file.splitFile.ext
      mv file, thisDir/id.Path.changeFileExt(ext)
  # Run the Test
  check id


#_______________________________________
# @section Test
#_____________________________
test name "GLFW: Hello Window"  : checkApp "00", "hellowindow"
test name "OpenGL: Hello Clear" : checkApp "01", "helloclear"

