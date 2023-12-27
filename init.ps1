#!/usr/bin/env sh
# @fileoverview
#  Combined Shell and PowerShell initialization script.
#  It's only goal is to build a local copy of Nim
#  that is then used to run the .nims files that build the MinC compiler.
nimMaj=2          # Major nim version that MinC tracks
nimMin=0          # Minor nim version that MinC tracks
Prefix="ᛟ minc:"  # Prefix to append to all console info messages

#_______________________________________
# Shell Initialization
#____________________________
# Don't use  #＞ directly  (e.g.  #"">   or similar).
# Otherwise the Bash section would be exited and Bash would try to execute Powershell code.
echo --% >/dev/null;: ' | out-null
<#'
#____________________________
# Bash tools
set -u # error on undefined variables
set -e # exit on first error
# Project setup
thisDir=$(dirname "$(realpath "$BASH_SOURCE")")
rootDir="$thisDir"        # Find the root folder of the repository
binDir="$rootDir/bin"     # Binaries output folder
nimDir="$binDir/nim"      # nim submodule folder (absolute)
nimBranch="version-$nimMaj-$nimMin"  # Name of the Nim branch that MinC tracks
nim="$nimDir/bin/nim"     # Nim binary result after it has been bootstrapped
echo "$Prefix Initializing MinC binaries from Bash ..."

#____________________________
# Clean binDir
wrn="$Prefix Warning-> This will delete everything at $binDir . Continue?"$'\n'$"  [Recommended (yes)]  (y/n)? "
read -rep "$wrn" -n 1 answer
case "$answer" in
  "y" | "Y" | "" )
    echo "$Prefix Cleaning all content of $binDir ..."
    rm -rfv $binDir
    mkdir -v $binDir
    echo -e "*\n!.gitignore" > "$binDir"/.gitignore
    ;;
  "n" | "N" | * ) echo "$Prefix Continuing without removing $dir" ;;
esac

#____________________________
# Init nimDir
prevDir=$PWD
git clone --depth=1 -b $nimBranch https://github.com/nim-lang/Nim.git $nimDir
cd $nimDir
sh ./build_all.sh
cd $prevDir

echo "$Prefix Finished initializing MinC binaries."
#____________________________
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
