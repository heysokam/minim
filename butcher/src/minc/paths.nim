# @fileoverview
#  Basic std/paths functionality support
#  @important Should be included, not imported
import std/os
import std/[ paths,files,dirs ]
func copyFile  (src,trg :Path; options = {cfSymlinkFollow}) :void {.borrow.}
func readFile  (src :Path) :string {.borrow.}
proc writeFile (trg :Path; data :string) :void {.borrow.}
