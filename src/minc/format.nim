#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps ndk
import nstd/shell
import nstd/strings
import nstd/paths
# @deps minc
import ./types
import ./cli

#_______________________________________
# @section Clang Format
#_____________________________
proc run (clangFmt :ClangFormat; file :Path) :void=
  var cmd :string= &"{clangFmt.bin} -i --style=file"
  if clangFmt.file != "".Path: cmd.add &":{clangFmt.file}"
  cmd.add &" {file}"
  sh cmd
#___________________
proc clang *(
    cli  : cli.Cfg;
    code : string;
  ) :string=
  ## TODO: Support for Multi-file
  # Clean the temporary file before starting
  let tmpFile :Path= cli.cacheDir/"clangFmt.tmp.c"
  if not dirExists(cli.cacheDir): md cli.cacheDir
  if fileExists(tmpFile): rm tmpFile
  # Write the temporary file
  tmpFile.writeFile code
  # Format it in-place
  cli.clangFmt.run(tmpFile)
  # Return the formatted result as a string
  result = tmpFile.readFile

