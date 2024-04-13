#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
from std/strformat import `&`
from std/strutils import join
import nstd/paths

#_______________________________________
# @section Package Information
const Version *{.strdefine.}= "dev." & gorge "git --no-pager log -n 1 --pretty=format:%H"

#_______________________________________
# @section Format
const Tab         *{.strdefine.}= "  "
const Prefix      *{.strdefine.}= "ᛟ minc"
const Sep         *{.strdefine.}= "  "

#_______________________________________
# @section Configuration Defaults
let binDir *:Path= getCurrentDir()/"bin"
  ## @descr
  ##  Default binary folder
  ##  Can be changed with --binDir:path from cli
let mincCache *:Path= cfg.binDir/".cache"/"minc"
  ## @descr
  ##  Default folder where the MinC compiler will store its temporary output files
  ##  Can be changed with --cacheDir:path from cli
let zigBin *:Path= cfg.binDir/".zig"/"zig"
  ## @descr
  ##  Default zig binary will be searched for in "cfg.binDir/.zig/zig"
  ##  Can be changed with --zigBin:path from cli
const clangFmtBin *{.strdefine.}= "clang-format"
  ## @descr
  ##  Default clang-format binary will be used from $PATH
  ##  Can be changed with --clangFmtBin:path from cli

#_______________________________________
# @section Compile Flags
#_________________________________________________
const FilterFlags = [
  "-Wno-declaration-after-statement", # Explicitly allow asignment on definition. Useless warning for >= C99
  "-Wno-error=pre-c2x-compat",        # Explicitly allow < c2x compat, but keep the warnings
  "-Wno-error=#warnings",             # Explicitly allow user warnings without creating errors
  "-Wno-error=unsafe-buffer-usage",   # Explicitly avoid erroring on this (half-finished) warning group from clang.16
  "-Wno-error=vla",                   # Explicitly avoid erroring on VLA usage, but keep the warning (todo: only for debug)
  "-Wno-error=padded",                # Warn when structs are automatically padded, but don't error.
  "-Wno-error=unused-macros",         # Macros cannot be declared public to not trigger this, so better to not error and keep the warning
  "-Wno-error=documentation-unknown-command",  # Ignore Documentation errors for our custom syntax
  # Ignore C++ flags. We build C
  "-Wno-c++-compat",
  "-Wno-c++0x-compat",                   "-Wno-c++0x-extensions",                         "-Wno-c++0x-narrowing",
  "-Wno-c++11-compat",                   "-Wno-c++11-compat-deprecated-writable-strings", "-Wno-c++11-compat-pedantic",       "-Wno-c++11-compat-reserved-user-defined-literal",
  "-Wno-c++11-extensions",               "-Wno-c++11-extra-semi",                         "-Wno-c++11-inline-namespace",      "-Wno-c++11-long-long",                            "-Wno-c++11-narrowing",
  "-Wno-c++14-attribute-extensions",     "-Wno-c++14-binary-literal",                     "-Wno-c++14-compat",                "-Wno-c++14-compat-pedantic",                      "-Wno-c++14-extensions",
  "-Wno-c++17-attribute-extensions",     "-Wno-c++17-compat",                             "-Wno-c++17-compat-mangling",       "-Wno-c++17-compat-pedantic",                      "-Wno-c++17-extensions",
  "-Wno-c++1y-extensions",               "-Wno-c++1z-compat",                             "-Wno-c++1z-compat-mangling",       "-Wno-c++1z-extensions",
  "-Wno-c++20-attribute-extensions",     "-Wno-c++20-compat",                             "-Wno-c++20-compat-pedantic",       "-Wno-c++20-designator",                           "-Wno-c++20-extensions",
  "-Wno-c++2a-compat",                   "-Wno-c++2a-compat-pedantic",                    "-Wno-c++2a-extensions",            "-Wno-c++2b-extensions",
  "-Wno-c++98-c++11-c++14-c++17-compat", "-Wno-c++98-c++11-c++14-c++17-compat-pedantic",  "-Wno-c++98-c++11-c++14-compat",    "-Wno-c++98-c++11-c++14-compat-pedantic",
  "-Wno-c++98-c++11-compat",             "-Wno-c++98-c++11-compat-binary-literal",        "-Wno-c++98-c++11-compat-pedantic",
  "-Wno-c++98-compat",                   "-Wno-c++98-compat-bind-to-temporary-copy",      "-Wno-c++98-compat-extra-semi",     "-Wno-c++98-compat-local-type-template-args",      "-Wno-c++98-compat-pedantic", "-Wno-c++98-compat-unnamed-type-template-args",
  # TODO: Remove completely
  "-Wno-error=missing-braces",  # Irrelevant when using -Wmissing-field-initializers
  ].join(" ") # Flags to remove from -Weverything
const BaseFlags    = &"--std=c2x -Weverything -Werror -pedantic -pedantic-errors {FilterFlags} "  # C Compiler flags
const ReleaseFlags = ""
const DebugFlags   = "-ggdb -fno-sanitize-trap=undefined -fno-sanitize-recover=undefined -lubsan" # https://github.com/ziglang/zig/issues/5163
const flags      * = (
  release : BaseFlags & ReleaseFlags,
  debug   : BaseFlags & DebugFlags,
  ) # << flags ( ... )

