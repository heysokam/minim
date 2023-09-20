#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/cmdline
# *Slate dependencies
import slate/types
import slate/minc/convert
# MinC dependencies

const Ccode * = """
int main(int argc) {return 0;}"""
# Ncode
proc main*(argc :int; argv :ptr string; argv2 :seq[string]; argv3 :array[3,cstring]):int= return 0


# Describe the language
const cmin * = Lang(
  name : "MinC",
  pfx  : "minc",
  )


#[
import ./nimc
const code = "proc main*(count:int; argc:int32):int= return 42"
echo "\nrepr______________________________________________________"
echo nimc.getAST(code).repr
echo "\nrenderTree________________________________________________"
echo nimc.getAST(code).renderTree
echo "\ntreeRepr__________________________________________________"
echo nimc.getAST(code).treeRepr
echo "\ntoMinC____________________________________________________"
var res = convert.toMinC(code)
echo res
]#

when isMainModule:
  let cli = commandLineParams()
  let src = cli[0].readFile()
  let trg = cli[1]
  trg.writeFile(convert.toMinC(src))
