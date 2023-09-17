#:______________________________________________________
#  *slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/macros
# *slate dependencies
import ./cmin/convert{.all.}
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

const tst1 = convert.toCmin( main )
static:echo tst1,"\n"


##[ TODO : Broken ]#
const Ncode = astToStr(main)
const tst2  = Ncode.parseExpr().bindSym().Cmin()
static:echo tst2,"\n"
]##
