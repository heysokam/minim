import std/[ os,strformat ]
const thisDir = os.parentDir( currentSourcePath() )
const rootDir = thisDir/".."/".."
const binDir  = rootDir/"bin"
const nimRoot = binDir/"nim"
const nimDir  = nimRoot/"bin"
withDir nimRoot:
  for file in nimDir.listFiles():
    echo file
    let name = file.lastPathPart
    cpFile file, nimRoot/name

