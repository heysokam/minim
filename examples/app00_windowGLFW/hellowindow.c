#include <stdbool.h>
#include <GLFW/glfw3.h>
/// GLFW Aliases
static const int ClientApi = GLFW_CLIENT_API;
static const int NoApi = GLFW_NO_API;
static const int Resizable = GLFW_RESIZABLE;
/// Callbacks
static void resize (GLFWwindow* win, int W, int H) {
  /// GLFW resize Callback
  (void)win; //discard
  (void)W; //discard
  (void)H; //discard
}
/// Entry Point
int main (void) {
  glfwInit();
  glfwWindowHint(ClientApi, NoApi);
  glfwWindowHint(Resizable, false);
  GLFWwindow* win = glfwCreateWindow(960, 540, "MinC | Hello GLFW", NULL, NULL);
  glfwSetFramebufferSizeCallback(win, resize);
  glfwSetKeyCallback(win, NULL);
  glfwSetCursorPosCallback(win, NULL);
  glfwSetMouseButtonCallback(win, NULL);
  glfwSetScrollCallback(win, NULL);
  while (!glfwWindowShouldClose(win)) {
    glfwPollEvents();
  }
  glfwDestroyWindow(win);
  glfwTerminate();
  return 0;
}

