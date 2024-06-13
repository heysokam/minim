static void echo(char* const format, ...) {
  char* fmt = malloc(strlen(format) + 2);
  strcpy(fmt, format);
  strcat(fmt, "\n");
  va_list args;
  va_start(args, fmt);
  vprintf(fmt, args);
  va_end(args);
  free(fmt);
  return;
}
