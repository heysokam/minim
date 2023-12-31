#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps n*dk
import pkg/nstd/logger as nstd_log
# @deps minc
import ./cfg

proc init *() :void=  nstd_log.setDefaultLogger( nstd_log.newConLogger( cfg.Prefix & "Preprocessor") )  ## TODO: Change to initialize multiple loggers when more processes are executed
  ## @descr Initializes the logger for the MinC compiler process.
proc info *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.inf(args)
  ## @descr Logs an information message.
proc dbg *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.dbg(args)
  ## @descr Logs a debug information message.
proc fail *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.fatal(args); quit(101)
  ## @descr Logs a fatal error message and quits the application.
