#:______________________________________________________
#  *slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________

##[ CompileTime ]#
const tst1 = convert.toCmin( main )
static:echo tst1,"\n"
]##

##[ TODO : Broken ]#
const Ncode = astToStr(main)
const tst2  = Ncode.parseExpr().bindSym().Cmin()
static:echo tst2,"\n"
]##
