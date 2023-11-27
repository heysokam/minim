#!/usr/bin/env sh
# @file
# Combined Shell and PowerShell initialization script.
# It's only goal is to build a local copy of Nim
# that is then used to run the .nims files that build the MinC compiler.
Prefix="ᛟ minc:"
echo --% >/dev/null;: ' | out-null
<#'
#_______________________________________
# Shell Initialization
#____________________________
# Don't use  #＞ directly  (e.g.  #"">   or similar).
# Otherwise the Shell section would be exited and Shell would try to execute Powershell code.
set -u # error on undefined variables
set -e # exit on first error
echo "$Prefix Running Unix Shell init section..."
thisDir=$(dirname $(realpath $BASH_SOURCE))
sh $thisDir/src/build/init.sh
echo "$Prefix Finished Unix Shell init."
# end bash section
exit #>
#____________________________



#_______________________________________
# PowerShell Initialization
#____________________________
# No need to escape anything. Shell cannot reach this section.
echo "$Prefix Running PowerShell init section..."

echo "[ERROR] PowerShell Initialization is not implemented yet. Install nim or initialize the nim submodule manually from ./src/lib/nim/"

echo "$Prefix Finished PowerShell init."
#____________________________
