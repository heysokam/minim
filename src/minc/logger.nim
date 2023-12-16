# @dependencies n*dk
import pkg/nstd/logger as nstd_log
# @dependencies minc
import ./cfg

proc init *() :void=  nstd_log.setDefaultLogger( nstd_log.newConLogger( cfg.Prefix & "Preprocessor") )  ## TODO: Change to initialize multiple loggers when more processes are executed
  ## @description Initializes the logger for the MinC compiler process.
proc info *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.inf(args)
  ## @description Logs an information message.
proc dbg *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.dbg(args)
  ## @description Logs a debug information message.
proc fail *(args :varargs[string, `$`]) :void {.inline.}=  nstd_log.fatal(args); quit(101)
  ## @description Logs a fatal error message and quits the application.
