/// ᛟ minc  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
/// @deps C stdlib
#include <stdbool.h>
/// @deps External
#include <GLFW/glfw3.h>
/// GLFW Aliases
static /*constexpr*/ int const ClientApi = GLFW_CLIENT_API;
static /*constexpr*/ int const NoApi     = GLFW_NO_API;
static /*constexpr*/ int const Resizable = GLFW_RESIZABLE;
/// Callbacks
static void resize(GLFWwindow* win, int W, int H) {
  /// GLFW resize Callback
  (void)win; /*discard*/
  (void)W;   /*discard*/
  (void)H;   /*discard*/
}
/// Entry Point
int const main(void) {
  glfwInit();
  glfwWindowHint(ClientApi, NoApi);
  glfwWindowHint(Resizable, false);
  GLFWwindow* win = glfwCreateWindow(960, 540, "MinC | Hello GLFW", nullptr, nullptr);
  glfwSetFramebufferSizeCallback(win, resize);
  glfwSetKeyCallback(win, nullptr);
  glfwSetCursorPosCallback(win, nullptr);
  glfwSetMouseButtonCallback(win, nullptr);
  glfwSetScrollCallback(win, nullptr);
  while (!glfwWindowShouldClose(win)) { glfwPollEvents(); }
  glfwDestroyWindow(win);
  glfwTerminate();
  return 0;
}
