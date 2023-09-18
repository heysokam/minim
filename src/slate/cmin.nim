#:______________________________________________________
#  *slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
# *slate dependencies
import ./types

const Ccode * = """
int main(int argc) {return 0;}"""
# Ncode
proc main*(argc :int; argv :ptr string; argv2 :seq[string]; argv3 :array[3,cstring]):int= return 0


# Describe the language
const cmin * = Lang(
  name : "Min C",
  pfx  : "cmin",
  )

import ./nimc


import ./cmin/convert
const code = "proc main*(count:int):int= return 0"
echo "\nrepr______________________________________________________"
echo code.getAST().repr
echo "\nrenderTree________________________________________________"
echo code.getAST().renderTree
echo "\ntreeRepr__________________________________________________"
echo code.getAST().treeRepr
echo "\ntoCmin____________________________________________________"
var res = convert.toCmin(code)
discard res

