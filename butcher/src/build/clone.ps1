#!/usr/bin/env sh
# vi: set ft=bash
# @fileoverview
#  Combined Shell and PowerShell repository cloning script.
#  It's only goal is to build a local copy of MinC
#  and enter the folder to run the initialization from there.
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
trgDir="$thisDir/.minc"
echo "$Prefix Downloading MinC from Bash ..."

#____________________________
# Init nimDir
prevDir=$PWD
err() {
  echo "$Prefix Error: $@" >&2
  return 1
}
clone() { 
  echo "$Prefix Cloning MinC into $@ ..."
  git clone https://github.com/heysokam/minc $@
  return 0
}
while :
do
  while :
  do
    msg="$Prefix Do you want to install MinC into $HOME/.minc ?  (Choose 'n' to select a folder)"$'\n'$"  [Recommended (yes)]  (y/n)?"
    read -rep "$msg"  -n 1 answer
    case "$answer" in
      "y" | "Y" | "" )
        clone "$HOME/.minc"
        ;;
      "n" | "N" | *  )
        break
        ;;
    esac
  done
  read -rep "  Enter directory name where MinC will be installed : " trgDir
  #check already exists
  [[ ! -e "$trgDir" ]] || err "$trgDir already exists" || continue

  #create a directory. if success: break the cycle
  clone "$trgDir" && break

  #otherwire repeat the question...
done
cd $trgDir
sh ./init.ps1

echo "$Prefix Finished initializing MinC binarie."
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

