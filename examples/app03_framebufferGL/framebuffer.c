/// stdlib dependencies
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
/// External dependencies
#include <epoxy/gl.h>
#include <epoxy/glx.h>
#include <GLFW/glfw3.h>
/// Types
typedef uint8_t byte;
typedef int32_t i32;
typedef uint32_t u32;
typedef char* str;
typedef char const* cstr;
/// GLFW: Aliases
// namespace glfw
extern const/*comptime*/ i32 ClientApi; const/*comptime*/ i32 ClientApi = GLFW_CLIENT_API;
extern const/*comptime*/ i32 NoApi; const/*comptime*/ i32 NoApi = GLFW_NO_API;
extern const/*comptime*/ i32 Resizable; const/*comptime*/ i32 Resizable = GLFW_RESIZABLE;
extern const/*comptime*/ i32 GLVers_M; const/*comptime*/ i32 GLVers_M = GLFW_CONTEXT_VERSION_MAJOR;
extern const/*comptime*/ i32 GLVers_m; const/*comptime*/ i32 GLVers_m = GLFW_CONTEXT_VERSION_MINOR;
extern const/*comptime*/ i32 OpenGLProf; const/*comptime*/ i32 OpenGLProf = GLFW_OPENGL_PROFILE;
extern const/*comptime*/ i32 OpenGLCore; const/*comptime*/ i32 OpenGLCore = GLFW_OPENGL_CORE_PROFILE;
extern const/*comptime*/ i32 ColorBit; const/*comptime*/ i32 ColorBit = GL_COLOR_BUFFER_BIT;
extern const/*comptime*/ i32 glfw_KeyEscape; const/*comptime*/ i32 glfw_KeyEscape = GLFW_KEY_ESCAPE;
extern const/*comptime*/ i32 glfw_Press; const/*comptime*/ i32 glfw_Press = GLFW_PRESS;
// namespace _
/// OpenGL: Aliases
// namespace gl
extern const/*comptime*/ i32 gl_Rgba; const/*comptime*/ i32 gl_Rgba = GL_RGBA;
extern const/*comptime*/ i32 gl_Rgba8; const/*comptime*/ i32 gl_Rgba8 = GL_RGBA8;
extern const/*comptime*/ i32 gl_UnsignedByte; const/*comptime*/ i32 gl_UnsignedByte = GL_UNSIGNED_BYTE;
extern const/*comptime*/ i32 gl_Tex2D; const/*comptime*/ i32 gl_Tex2D = GL_TEXTURE_2D;
extern const/*comptime*/ i32 gl_Repeat; const/*comptime*/ i32 gl_Repeat = GL_REPEAT;
extern const/*comptime*/ i32 gl_Nearest; const/*comptime*/ i32 gl_Nearest = GL_NEAREST;
extern const/*comptime*/ i32 gl_WrapS; const/*comptime*/ i32 gl_WrapS = GL_TEXTURE_WRAP_S;
extern const/*comptime*/ i32 gl_WrapT; const/*comptime*/ i32 gl_WrapT = GL_TEXTURE_WRAP_T;
extern const/*comptime*/ i32 gl_FilterMin; const/*comptime*/ i32 gl_FilterMin = GL_TEXTURE_MIN_FILTER;
extern const/*comptime*/ i32 gl_FilterMag; const/*comptime*/ i32 gl_FilterMag = GL_TEXTURE_MAG_FILTER;
// namespace _
/// OpenGL: Configuration
// namespace gl
extern const/*comptime*/ i32 InfoMsgLen; const/*comptime*/ i32 InfoMsgLen = 512;
// namespace _
/// Input Manager
// namespace i
static void i_key (GLFWwindow* win, i32 key, i32 code, i32 action, i32 mods) {
  (void)mods; //discard
  (void)code; //discard
  if (key == glfw_KeyEscape && action == glfw_Press) {
    glfwSetWindowShouldClose(win, true);
  }
}
// namespace _
/// Callbacks
// namespace cb
static void cb_resize (GLFWwindow* win, i32 W, i32 H) {
  /// GLFW resize Callback
  glViewport(0, 0, W, H);
  (void)win; //discard
}
static void cb_error (i32 code, cstr descr) {
  /// GLFW error callback
  printf("GLFW.Error:%d %s\n", code, descr);
}
// namespace _
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
  "// Hardcoded Fullscreen triangle in NDC coordinates |\n"
  "// UVs flipped vertically, so that 0,0 is topleft   |\n"
  "//__________________________________________________|\n"
  "#version 330 core\n"
  "out vec2 vUV;\n"
  "void main() { \n"
  "  vec2 vertices[3] = vec2[3](\n"
  "    vec2(-1,-1),\n"
  "    vec2( 3,-1),\n"
  "    vec2(-1, 3));\n"
  "  gl_Position = vec4(vertices[gl_VertexID],0,1);\n"
  "  vUV   = 0.5 * gl_Position.xy + vec2(0.5);\n"
  "\n"
  "  // vUV.flipVertical(), so that (0,0) is at topleft (OpenGL wants 0,0 at bottomleft)\n"
  "  // TODO: Flip the triangle vertices instead, and figure out backface drawing\n"
  "  // remember:  glClipControl(GL_UPPER_LEFT)  core@gl4.5\n"
  "  //            ARB_clip_control extension:  https://registry.khronos.org/OpenGL/extensions/ARB/ARB_clip_control.txt\n"
  "  vUV.y = 1-vUV.y;\n"
  "}";
const/*comptime*/ static cstr TriFrag =
  "//:_____________________________________________________\n"
  "//  hello  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :\n"
  "//:_____________________________________________________\n"
  "#version 330 core\n"
  "uniform sampler2D pixels;\n"
  "in vec2 vUV;\n"
  "out vec4 fColor;\n"
  "void main() { fColor = texture(pixels, vUV); }\n"
  "";
/// Image: Tools
extern const/*comptime*/ i32 R; const/*comptime*/ i32 R = 1;
extern const/*comptime*/ i32 RG; const/*comptime*/ i32 RG = 2;
extern const/*comptime*/ i32 RGB; const/*comptime*/ i32 RGB = 3;
extern const/*comptime*/ i32 RGBA; const/*comptime*/ i32 RGBA = 4;
/// Configuration
const/*comptime*/ static str cfg_Title = "MinC | Hello Triangle";
const/*comptime*/ static i32 cfg_W = 960;
const/*comptime*/ static i32 cfg_H = 540;
/// Framebuffer
// namespace fb
const/*comptime*/ static u32 fb_Size = cfg_W * cfg_H * RGBA;
static byte* fb_pixels = NULL;
// namespace _
/// Software Renderer
// namespace msr
static void msr_update (byte* const pix, u32 const size) {
  memset(pix, 255, size);
}
// namespace _
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
  glfwSetKeyCallback(win, i_key);
  glfwSetCursorPosCallback(win, NULL);
  glfwSetMouseButtonCallback(win, NULL);
  glfwSetScrollCallback(win, NULL);
  u32 triID = 0;
  glGenVertexArrays(1, &triID);
  fb_pixels = calloc(fb_Size, sizeof(byte));
  memset(fb_pixels, 128, fb_Size);
  u32 texID = 0;
  glGenTextures(1, &texID);
  glBindTexture(gl_Tex2D, texID);
  glTexParameteri(gl_Tex2D, gl_WrapS, gl_Repeat);
  glTexParameteri(gl_Tex2D, gl_WrapT, gl_Repeat);
  glTexParameteri(gl_Tex2D, gl_FilterMin, gl_Nearest);
  glTexParameteri(gl_Tex2D, gl_FilterMag, gl_Nearest);
  glTexImage2D(gl_Tex2D, 0, gl_Rgba8, cfg_W, cfg_H, 0, gl_Rgba, gl_UnsignedByte, fb_pixels);
  glBindTexture(gl_Tex2D, 0);
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
    msr_update(fb_pixels, fb_Size);
    glClearColor(1.0, 0.3, 0.3, 1.0);
    glClear(ColorBit);
    glBindTexture(gl_Tex2D, texID);
    glTexImage2D(gl_Tex2D, 0, gl_Rgba8, cfg_W, cfg_H, 0, gl_Rgba, gl_UnsignedByte, fb_pixels);
    glBindTexture(gl_Tex2D, 0);
    glUseProgram(shader);
    glBindTexture(gl_Tex2D, texID);
    glBindVertexArray(triID);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glBindTexture(gl_Tex2D, 0);
    glBindVertexArray(0);
    glUseProgram(0);
    glfwSwapBuffers(win);
  }
  glfwDestroyWindow(win);
  glfwTerminate();
  return 0;
}

