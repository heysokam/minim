#:______________________________________________________
#  ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps n*dk
import pkg/nstd/logger as nstd_log
# @deps minc
import ./cfg

proc init *() :void=
  ## @descr Initializes the logger for the MinC compiler process.
  ## TODO: Change to initialize multiple loggers when more processes are executed
  nstd_log.setDefaultLogger(nstd_log.newConLogger(
    name      = cfg.Prefix,
    threshold = if cfg.quiet: Log.Err else: Log.All,
    )) # << nstd_log.newConLogger( ... )
proc info *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.info(args)
  ## @descr Logs an information message.
proc dbg *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.dbg(args)
  ## @descr Logs a debug information message.
proc fail *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.fatal(args); quit(101)
  ## @descr Logs a fatal error message and quits the application.
