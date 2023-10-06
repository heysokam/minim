/// stdlib dependencies
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
/// External dependencies
#include <epoxy/gl.h>
#include <epoxy/glx.h>
#include <GLFW/glfw3.h>
/// Types
typedef int32_t i32;
typedef uint32_t u32;
typedef char* str;
typedef char const* cstr;
/// GLFW Aliases
extern const/*comptime*/ i32 ClientApi; const/*comptime*/ i32 ClientApi = GLFW_CLIENT_API;
extern const/*comptime*/ i32 NoApi; const/*comptime*/ i32 NoApi = GLFW_NO_API;
extern const/*comptime*/ i32 Resizable; const/*comptime*/ i32 Resizable = GLFW_RESIZABLE;
extern const/*comptime*/ i32 GLVers_M; const/*comptime*/ i32 GLVers_M = GLFW_CONTEXT_VERSION_MAJOR;
extern const/*comptime*/ i32 GLVers_m; const/*comptime*/ i32 GLVers_m = GLFW_CONTEXT_VERSION_MINOR;
extern const/*comptime*/ i32 OpenGLProf; const/*comptime*/ i32 OpenGLProf = GLFW_OPENGL_PROFILE;
extern const/*comptime*/ i32 OpenGLCore; const/*comptime*/ i32 OpenGLCore = GLFW_OPENGL_CORE_PROFILE;
extern const/*comptime*/ i32 ColorBit; const/*comptime*/ i32 ColorBit = GL_COLOR_BUFFER_BIT;
/// OpenGL Configuration
extern const/*comptime*/ i32 InfoMsgLen; const/*comptime*/ i32 InfoMsgLen = 512;
/// Callbacks
static void cb_resize (GLFWwindow* win, i32 W, i32 H) {
  /// GLFW resize Callback
  glViewport(0, 0, W, H);
  (void)win; //discard
}
static void cb_error (i32 code, cstr descr) {
  /// GLFW error callback
  printf("GLFW.Error:%d %s\n", code, descr);
}
/// Helpers
static void echo (cstr const msg) {
  printf("%s\n", msg);
}
[[noreturn]] static void err (cstr const msg) {
  echo(msg);
  exit(-1);
}
/// Shaders: Code
const/*comptime*/ static cstr TriVert =
  "//:_____________________________________________________\n"
  "//  hello  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :\n"
  "//:_____________________________________________________\n"
  "// Hardcoded triangle in NDC coordinates            |\n"
  "// UVs flipped vertically, so that 0,0 is topleft   |\n"
  "//__________________________________________________|\n"
  "#version 330 core\n"
  "out vec2 vUV;\n"
  "void main() { \n"
  "  vec2 vertices[3] = vec2[3](\n"
  "    vec2(-0.5,-0.5),\n"
  "    vec2( 0.5,-0.5),\n"
  "    vec2(-0.5, 0.5));\n"
  "  gl_Position = vec4(vertices[gl_VertexID],0,1);\n"
  "  vUV   = 0.5 * gl_Position.xy + vec2(0.5);\n"
  "  vUV.y = 1-vUV.y;  // vUV.flipVertical(), so that (0,0) is at topleft (OpenGL wants 0,0 at bottomleft)\n"
  "}";
const/*comptime*/ static cstr TriFrag =
  "//:_____________________________________________________\n"
  "//  hello  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :\n"
  "//:_____________________________________________________\n"
  "#version 330 core\n"
  "uniform sampler2D pixels;\n"
  "in vec2 vUV;\n"
  "out vec4 fColor;\n"
  "void main() { fColor = texture(pixels, vUV); }";
/// Configuration
const/*comptime*/ static str cfg_Title = "MinC | Hello Triangle";
const/*comptime*/ static i32 cfg_W = 960;
const/*comptime*/ static i32 cfg_H = 540;
/// _______________________________________
i32 main (void) {
  /// Application Entry Point
  echo(cfg_Title);
  glfwSetErrorCallback(cb_error);
  i32 ok = glfwInit();
  if (!ok) {
    err("Failed to Initialize GLFW");
  }
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
  u32 triID = 0;
  glGenVertexArrays(1, &triID);
  char infoLog[InfoMsgLen];
  u32 const vertID = glCreateShader(GL_VERTEX_SHADER);
  glShaderSource(vertID, 1, &TriVert, NULL);
  glCompileShader(vertID);
  glGetShaderiv(vertID, GL_COMPILE_STATUS, &ok);
  if (!ok) {
    glGetShaderInfoLog(vertID, InfoMsgLen, NULL, infoLog);
    echo("Failed to compile the Vertex Shader:");
    err(infoLog);
  }
  u32 const fragID = glCreateShader(GL_FRAGMENT_SHADER);
  glShaderSource(fragID, 1, &TriFrag, NULL);
  glCompileShader(fragID);
  glGetShaderiv(fragID, GL_COMPILE_STATUS, &ok);
  if (!ok) {
    glGetShaderInfoLog(fragID, InfoMsgLen, NULL, infoLog);
    echo("Failed to compile the Fragment Shader:");
    err(infoLog);
  }
  u32 const shader = glCreateProgram();
  glAttachShader(shader, vertID);
  glAttachShader(shader, fragID);
  glLinkProgram(shader);
  glGetProgramiv(shader, GL_LINK_STATUS, &ok);
  if (!ok) {
    glGetProgramInfoLog(shader, InfoMsgLen, NULL, infoLog);
    echo("Failed to link the Shader Program:");
    err(infoLog);
  }
  glDeleteShader(vertID);
  glDeleteShader(fragID);
  while (!glfwWindowShouldClose(win)) {
    glfwPollEvents();
    glClearColor(1.0, 0.3, 0.3, 1.0);
    glClear(ColorBit);
    glUseProgram(shader);
    glBindVertexArray(triID);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glBindVertexArray(0);
    glUseProgram(0);
    glfwSwapBuffers(win);
  }
  glfwDestroyWindow(win);
  glfwTerminate();
  return 0;
}

