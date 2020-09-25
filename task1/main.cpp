#include <iostream>
#include <vector>
#include <chrono>

#include <fmt/format.h>

#include <GL/glew.h>

// Imgui + bindings
#include "imgui.h"
#include "bindings/imgui_impl_glfw.h"
#include "bindings/imgui_impl_opengl3.h"

// Include glfw3.h after our OpenGL definitions
#include <GLFW/glfw3.h>

// Math constant and routines for OpenGL interop
#include <glm/gtc/constants.hpp>
#include <cmath>

#include "opengl_shader.h"

static void glfw_error_callback(int error, const char *description)
{
   std::cerr << fmt::format("Glfw Error {}: {}\n", error, description);
}

void create_rectangle(GLuint &vbo, GLuint &vao, GLuint &ebo)
{
   // create the rectangle
   float vertices[] = {
       -1.0f, -1.0f, 0.0f,	// position vertex 1
       1.0f, 0.0f, 0.0f,	 // color vertex 1

       -1.0f, 1.0f, 0.0f,  // position vertex 1
       0.0f, 1.0f, 0.0f,	 // color vertex 1

       1.0f, -1.0f, 0.0f, // position vertex 1
       0.0f, 0.0f, 1.0f,	 // color vertex 1

       1.0f, 1.0f, 0.0f,
       1.0f, 0.0f, 0.0f
   };
   unsigned int triangle_indices[] = {
       3, 2, 1,
       2, 1, 0
   };
   glGenVertexArrays(1, &vao);
   glGenBuffers(1, &vbo);
   glGenBuffers(1, &ebo);
   glBindVertexArray(vao);
   glBindBuffer(GL_ARRAY_BUFFER, vbo);
   glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
   glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
   glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(triangle_indices), triangle_indices, GL_STATIC_DRAW);
   glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *)0);
   glEnableVertexAttribArray(0);
   glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *)(3 * sizeof(float)));
   glEnableVertexAttribArray(1);
   glBindBuffer(GL_ARRAY_BUFFER, 0);
}

int main(int, char **)
{
   // Use GLFW to create a simple window
   glfwSetErrorCallback(glfw_error_callback);
   if (!glfwInit())
      return 1;


   // GL 3.3 + GLSL 330
   const char *glsl_version = "#version 330";
   glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
   glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
   glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
   //glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);            // 3.0+ only

   // Create window with graphics context
   GLFWwindow *window = glfwCreateWindow(1280, 720, "Dear ImGui - Conan", NULL, NULL);

   if (window == NULL)
      return 1;
   glfwMakeContextCurrent(window);
   glfwSwapInterval(1); // Enable vsync

   // Initialize GLEW, i.e. fill all possible function pointers for current OpenGL context
   if (glewInit() != GLEW_OK)
   {
      std::cerr << "Failed to initialize OpenGL loader!\n";
      return 1;
   }

   // create our geometries
   GLuint vbo, vao, ebo;
   create_rectangle(vbo, vao, ebo);

   // init shader
   shader_t shader("simple-shader.vs", "simple-shader.fs");

   // Setup GUI context
   IMGUI_CHECKVERSION();
   ImGui::CreateContext();
   ImGuiIO &io = ImGui::GetIO();
   ImGui_ImplGlfw_InitForOpenGL(window, true);
   ImGui_ImplOpenGL3_Init(glsl_version);
   ImGui::StyleColorsDark();

   while (!glfwWindowShouldClose(window))
   {
      glfwPollEvents();

      // Get windows size
      int display_w, display_h;
      glfwGetFramebufferSize(window, &display_w, &display_h);

      // Set viewport to fill the whole window area
      glViewport(0, 0, display_w, display_h);

      // Fill background with solid color
      glClearColor(0.0f, 1.0f, 0.0f, 1.00f);
      glClear(GL_COLOR_BUFFER_BIT);

      // Gui start new frame
      ImGui_ImplOpenGL3_NewFrame();
      ImGui_ImplGlfw_NewFrame();
      ImGui::NewFrame();

      // GUI
      ImGui::Begin("Settings");
      static float INF = 50.0;
      ImGui::SliderFloat("INF", &INF, 0, 100.0);
      static int ITERATIONS = 230;
      ImGui::SliderInt("Iterations", &ITERATIONS, 0, 600);
      ImVec2 delta = ImGui::GetMouseDragDelta();
      ImGui::ResetMouseDragDelta();
      static float left_bottom[2] = { -2.0f, -2.0f};
      static float right_up[2] = { 2.0f, 2.0f};
      int height, width;
      glfwGetWindowSize(window, &width, &height);
      float scale_x = (right_up[0] - left_bottom[0]) / (float) width;
      left_bottom[0] -= delta.x * scale_x;
      right_up[0] -= delta.x * scale_x;
      float scale_y = (right_up[1] - left_bottom[1]) / (float) height;
      left_bottom[1] -= delta.y * scale_y;
      right_up[1] -= delta.y * scale_y;

      float mouse_wheel = ImGui::GetIO().MouseWheel;
      ImVec2 screen_pos = ImGui::GetMousePos();
      if (fabs(mouse_wheel) > 1e-5) {
          float const_x = left_bottom[0] + (right_up[0] - left_bottom[0]) * (float) screen_pos.x / width;
          float const_y = left_bottom[1] + (right_up[1] - left_bottom[1]) * (float) screen_pos.y / height;
          //std::cerr << screen_pos.x << ' ' << screen_pos.y << std::endl;
          static const float times_per_one = 1.1;
          float times_change = pow(times_per_one, -mouse_wheel);
          float new_width = (right_up[0] - left_bottom[0]) * times_change;
          left_bottom[0] = const_x - new_width * (const_x - left_bottom[0]) / (right_up[0] - left_bottom[0]);
          right_up[0] = left_bottom[0] + new_width;
          float new_height = (right_up[1] - left_bottom[1]) * times_change;
          left_bottom[1] = const_y - new_height * (const_y - left_bottom[1]) / (right_up[1] - left_bottom[1]);
          right_up[1] = left_bottom[1] + new_height;
      }
      ImGui::End();

      // Pass the parameters to the shader as uniforms
      shader.set_uniform("a", left_bottom[0], left_bottom[1]);
      shader.set_uniform("b", right_up[0], right_up[1]);
      shader.set_uniform("ITERATIONS", ITERATIONS);
      shader.set_uniform("INF", INF);

      // Bind triangle shader
      shader.use();
      // Bind vertex array = buffers + indices
      glBindVertexArray(vao);
      // Execute draw call
      glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
      glBindVertexArray(0);

      glActiveTexture(GL_TEXTURE0);
      GLuint tex;
      glGenTextures(1, &tex);
      glBindTexture(GL_TEXTURE_1D, tex);
      glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
      glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      float pixels[] = {
               0.0f, 0.0f, 0.2f, 1.0f,
               0.7f, 0.7f, 0.0f, 1.0f,
               0.7f, 0.5f, 0.0f, 1.0f,
               0.8f, 0.2f, 0.0f, 1.0f,
               0.0f, 0.0f, 0.0f, 1.0f
      };
      glTexImage1D(
               GL_TEXTURE_1D,
               0,
               GL_RGBA32F,
               5,
               0,
               GL_RGBA,
               GL_FLOAT,
               pixels);

      // Generate gui render commands
      ImGui::Render();

      // Execute gui render commands using OpenGL backend
      ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

      // Swap the backbuffer with the frontbuffer that is used for screen display
      glfwSwapBuffers(window);
   }

   // Cleanup
   ImGui_ImplOpenGL3_Shutdown();
   ImGui_ImplGlfw_Shutdown();
   ImGui::DestroyContext();

   glfwDestroyWindow(window);
   glfwTerminate();

   return 0;
}
