/// stdlib dependencies
#include <stdio.h>
#include <stdlib.h>
/// External dependencies
#include <epoxy/gl.h>
#include <epoxy/glx.h>
#include <GLFW/glfw3.h>
/// Types
typedef char* str;
typedef const char* cstr;
/// GLFW Aliases
extern int const ClientApi  ; int const ClientApi  = GLFW_CLIENT_API;
extern int const NoApi      ; int const NoApi      = GLFW_NO_API;
extern int const Resizable  ; int const Resizable  = GLFW_RESIZABLE;
extern int const GLVers_M   ; int const GLVers_M   = GLFW_CONTEXT_VERSION_MAJOR;
extern int const GLVers_m   ; int const GLVers_m   = GLFW_CONTEXT_VERSION_MINOR;
extern int const OpenGLProf ; int const OpenGLProf = GLFW_OPENGL_PROFILE;
extern int const OpenGLCore ; int const OpenGLCore = GLFW_OPENGL_CORE_PROFILE;
extern int const ColorBit   ; int const ColorBit   = GL_COLOR_BUFFER_BIT;
/// Callbacks
static void cb_resize (GLFWwindow* win, int W, int H) {
  /// GLFW resize Callback
  glViewport(0, 0, W, H);
  (void)win; //discard
}
static void cb_error (int code, cstr descr) {
  /// GLFW error callback
  printf("GLFW.Error:%d %s\n", code, descr);
}
/// Helpers
static void echo (const cstr msg) {
  printf("%s\n", msg);
}
__attribute__((noreturn)) static void err (cstr const msg) {
  echo(msg);
  exit(-1);
}
/// Configuration
static str const cfg_Title = "MinC | Hello OpenGL 3.3";
static int const cfg_W = 960;
static int const cfg_H = 540;
/// _______________________________________
int main (void) {
  /// Application Entry Point
  echo(cfg_Title);
  glfwSetErrorCallback(cb_error);
  glfwInit();
  glfwWindowHint(OpenGLProf, OpenGLCore);
  glfwWindowHint(GLVers_M, 3);
  glfwWindowHint(GLVers_m, 3);
  glfwWindowHint(Resizable, false);
  GLFWwindow* win = glfwCreateWindow(cfg_W, cfg_H, cfg_Title, NULL, NULL);
  if (!win) {
    err("Failed to create GLFW window");
  }
  glfwSetFramebufferSizeCallback(win, cb_resize);
  glfwMakeContextCurrent(win);
  glfwSetKeyCallback(win, NULL);
  glfwSetCursorPosCallback(win, NULL);
  glfwSetMouseButtonCallback(win, NULL);
  glfwSetScrollCallback(win, NULL);
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

