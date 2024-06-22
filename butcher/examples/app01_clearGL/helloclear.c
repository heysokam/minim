/// ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
/// @deps C stdlib
#include <stdio.h>
#include <stdlib.h>
/// @deps External
#include <epoxy/gl.h>
#include <epoxy/glx.h>
#include <GLFW/glfw3.h>
/// Types
typedef char*       str;
typedef char const* cstr;
/// GLFW Aliases
static /*constexpr*/ int const ClientApi  = GLFW_CLIENT_API;
static /*constexpr*/ int const NoApi      = GLFW_NO_API;
static /*constexpr*/ int const Resizable  = GLFW_RESIZABLE;
static /*constexpr*/ int const GLVers_M   = GLFW_CONTEXT_VERSION_MAJOR;
static /*constexpr*/ int const GLVers_m   = GLFW_CONTEXT_VERSION_MINOR;
static /*constexpr*/ int const OpenGLProf = GLFW_OPENGL_PROFILE;
static /*constexpr*/ int const OpenGLCore = GLFW_OPENGL_CORE_PROFILE;
static /*constexpr*/ int const ColorBit   = GL_COLOR_BUFFER_BIT;
/// Callbacks
static void cb_resize(GLFWwindow* win, int W, int H) {
  /// GLFW resize Callback
  glViewport(0, 0, W, H);
  (void)win; /*discard*/
}
static void cb_error(int code, cstr descr) {
  /// GLFW error callback
  printf("GLFW.Error:%d %s\n", code, descr);
}
/// Helpers
static void              echo(cstr const msg) { printf("%s\n", msg); }
[[noreturn]] static void err(cstr const msg) {
  echo(msg);
  exit(-1);
}
/// Configuration
static /*constexpr*/ str const cfg_Title = "MinC | Hello OpenGL 3.3";
static /*constexpr*/ int const cfg_W     = 960;
static /*constexpr*/ int const cfg_H     = 540;
/// _______________________________________
int const main(void) {
  /// Application Entry Point
  echo(cfg_Title);
  glfwSetErrorCallback(cb_error);
  glfwInit();
  glfwWindowHint(OpenGLProf, OpenGLCore);
  glfwWindowHint(GLVers_M, 3);
  glfwWindowHint(GLVers_m, 3);
  glfwWindowHint(Resizable, false);
  GLFWwindow* win = glfwCreateWindow(cfg_W, cfg_H, cfg_Title, nullptr, nullptr);
  if (!win) { err("Failed to create GLFW window"); }
  glfwSetFramebufferSizeCallback(win, cb_resize);
  glfwMakeContextCurrent(win);
  glfwSetKeyCallback(win, nullptr);
  glfwSetCursorPosCallback(win, nullptr);
  glfwSetMouseButtonCallback(win, nullptr);
  glfwSetScrollCallback(win, nullptr);
  while (!glfwWindowShouldClose(win)) {
    glfwPollEvents();
    glClearColor(1.0, 0.3, 0.3, 1.0);
    glClear(ColorBit);
    glfwSwapBuffers(win);
  }
  glfwDestroyWindow(win);
  glfwTerminate();
  return 0;
}
