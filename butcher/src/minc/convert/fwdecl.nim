# @warning This file is meant to be included, not imported |
#__________________________________________________________|
# @section Forward Declares
#_____________________________
proc MinC              *(code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair
proc mincLiteral        (code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair
proc mincObjConstr      (code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair
proc mincType_multiword (code :PNode; indent :int= 0; special :SpecialContext= Context.None) :CFilePair
proc mincProcArgs       (code :PNode; indent :int= 0) :string
