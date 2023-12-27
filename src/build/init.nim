import std/os
const rootDir = os.parentDir( currentSourcePath() )/".."/".."
const binDir  = rootDir/"bin"
const nimDir  = binDir/".nim"/"bin"
os.copyFile( nimDir/"nim", binDir/"nim" )
