#include <iostream>
#include <vector>
#include <chrono>

#include <fmt/format.h>

#include <GL/glew.h>

// Imgui + bindings
#include "imgui.h"

#define STB_IMAGE_IMPLEMENTATION
#include "libs/stb_image.h"
#include "bindings/imgui_impl_glfw.h"
#include "bindings/imgui_impl_opengl3.h"

#define TINYOBJLOADER_IMPLEMENTATION
#include "tiny_obj_loader.h"

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

void create_cubemap(GLuint &vbo, GLuint &vao)
{
    float vertices[] = {
        -1.0f,  1.0f, -1.0f,
        -1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f,  1.0f, -1.0f,
        -1.0f,  1.0f, -1.0f,

        -1.0f, -1.0f,  1.0f,
        -1.0f, -1.0f, -1.0f,
        -1.0f,  1.0f, -1.0f,
        -1.0f,  1.0f, -1.0f,
        -1.0f,  1.0f,  1.0f,
        -1.0f, -1.0f,  1.0f,

        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,

        -1.0f, -1.0f,  1.0f,
        -1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f, -1.0f,  1.0f,
        -1.0f, -1.0f,  1.0f,

        -1.0f,  1.0f, -1.0f,
        1.0f,  1.0f, -1.0f,
        1.0f,  1.0f,  1.0f,
        1.0f,  1.0f,  1.0f,
        -1.0f,  1.0f,  1.0f,
        -1.0f,  1.0f, -1.0f,

        -1.0f, -1.0f, -1.0f,
        -1.0f, -1.0f,  1.0f,
        1.0f, -1.0f, -1.0f,
        1.0f, -1.0f, -1.0f,
        -1.0f, -1.0f,  1.0f,
        1.0f, -1.0f,  1.0f
    };
    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glBindVertexArray(vao);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), &vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), nullptr);
}

unsigned int load_cubemap(const std::string &path)
{
    unsigned int textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_CUBE_MAP, textureID);

    int width, height, nrChannels;
    {
        unsigned char *posx = stbi_load((path + "/posx.jpg").c_str(), &width, &height, &nrChannels, 0);
        assert(posx);
        glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, posx);
        stbi_image_free(posx);
    }
    {
        unsigned char *negx = stbi_load((path + "/negx.jpg").c_str(), &width, &height, &nrChannels, 0);
        glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, negx);
        stbi_image_free(negx);
    }
    {
        unsigned char *posy = stbi_load((path + "/posy.jpg").c_str(), &width, &height, &nrChannels, 0);
        glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, posy);
        stbi_image_free(posy);
    }
    {
        unsigned char *negy = stbi_load((path + "/negy.jpg").c_str(), &width, &height, &nrChannels, 0);
        glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, negy);
        stbi_image_free(negy);
    }
    {
        unsigned char *posz = stbi_load((path + "/posz.jpg").c_str(), &width, &height, &nrChannels, 0);
        glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, posz);
        stbi_image_free(posz);
    }
    {
        unsigned char *negz = stbi_load((path + "/negz.jpg").c_str(), &width, &height, &nrChannels, 0);
        glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, negz);
        stbi_image_free(negz);
    }
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_WRAP_R, GL_CLAMP_TO_EDGE);

    return textureID;
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
   GLuint cubemapVBO, cubemapVAO;
   create_cubemap(cubemapVBO, cubemapVAO);

   // init shader
   shader_t cubemapShader("cubemap-shader.vs", "cubemap-shader.fs");

   // Setup GUI context
   IMGUI_CHECKVERSION();
   ImGui::CreateContext();
   ImGuiIO &io = ImGui::GetIO();
   ImGui_ImplGlfw_InitForOpenGL(window, true);
   ImGui_ImplOpenGL3_Init(glsl_version);
   ImGui::StyleColorsDark();

   unsigned int cubemapTexture = load_cubemap("../Yokohama3");

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
      ImGui::End();

      // Cubemap render
      glDepthMask(GL_FALSE);
      cubemapShader.use();
      glBindVertexArray(cubemapVAO);
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
      glDrawArrays(GL_TRIANGLES, 0, 36);
      glBindVertexArray(0);

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
