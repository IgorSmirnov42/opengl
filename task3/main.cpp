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
#include <glm/gtx/transform.hpp>
#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
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

std::vector<float> load_object(const std::string &path, GLuint &vbo, GLuint &vao, GLuint &ebo, unsigned int &trianglesN) {
    std::cerr << "Loading object..." << std::endl;
    const std::string& inputfile = path;
    tinyobj::attrib_t attrib;
    std::vector<tinyobj::shape_t> shapes;
    std::vector<tinyobj::material_t> materials;

    std::string err;

    bool ret = tinyobj::LoadObj(&attrib, &shapes, &materials, &err, inputfile.c_str());

    if (!err.empty()) {
        std::cerr << err << std::endl;
    }

    if (!ret) {
        exit(1);
    }

    std::vector<float> vertices;
    std::vector<float> normals;
    std::vector<unsigned int> triangles;

    for (size_t s = 0; s < shapes.size(); s++) {
        // Loop over faces(polygon)
        size_t index_offset = 0;
        for (size_t f = 0; f < shapes[s].mesh.num_face_vertices.size(); f++) {
            int fv = shapes[s].mesh.num_face_vertices[f];
            assert(fv == 3);

            // Loop over vertices in the face.
            for (size_t v = 0; v < fv; v++) {
                // access to vertex
                tinyobj::index_t idx = shapes[s].mesh.indices[index_offset + v];
                tinyobj::real_t vx = attrib.vertices[3*idx.vertex_index+0];
                tinyobj::real_t vy = attrib.vertices[3*idx.vertex_index+1];
                tinyobj::real_t vz = attrib.vertices[3*idx.vertex_index+2];
                vertices.push_back(vx);
                vertices.push_back(vy);
                vertices.push_back(vz);
                tinyobj::real_t nx = attrib.normals[3*idx.normal_index+0];
                tinyobj::real_t ny = attrib.normals[3*idx.normal_index+1];
                tinyobj::real_t nz = attrib.normals[3*idx.normal_index+2];
                vertices.push_back(nx);
                vertices.push_back(ny);
                vertices.push_back(nz);
            }
            index_offset += fv;
            for (int i = 0; i < 3; ++i) {
                triangles.push_back(triangles.size());
            }
        }
    }

    float min_x = 1e9;
    float max_x = -1e9;
    float min_y = 1e9;
    float max_y = -1e9;
    float min_z = 1e9;
    float max_z = -1e9;

    for (int i = 0; i < vertices.size(); i += 6) {
        min_x = std::min(min_x, vertices[i + 0]);
        max_x = std::max(max_x, vertices[i + 0]);
        min_y = std::min(min_y, vertices[i + 1]);
        max_y = std::max(max_y, vertices[i + 1]);
        min_z = std::min(min_z, vertices[i + 2]);
        max_z = std::max(max_z, vertices[i + 2]);
    }

    float div_cf = std::max({max_x - min_x, max_y - min_y, max_z - min_z}) * 3;
    for (int i = 0; i < vertices.size(); i += 6) {
        vertices[i + 0] -= (max_x + min_x) / 2;
        vertices[i + 1] -= (max_y + min_y) / 2;
        vertices[i + 2] -= (max_z + min_z) / 2;
        for (int j = 0; j < 3; ++j) {
            vertices[i + j] /= div_cf;
        }
    }

    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glGenBuffers(1, &ebo);
    glBindVertexArray(vao);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(float), &vertices[0], GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, triangles.size() * sizeof(unsigned int), &triangles[0], GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *)0);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    trianglesN = triangles.size() / 3;
    std::cerr << "Triangles " << trianglesN << std::endl;

    std::cerr << "Object is loaded!" << std::endl;
    return vertices;
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
   GLuint objectVBO, objectVAO, objectEBO;
   unsigned int triangles_number;
   auto vertices = load_object("../obj/f1_high.obj", objectVBO, objectVAO, objectEBO, triangles_number);

   // init shader
   shader_t cubemapShader("cubemap-shader.vs", "cubemap-shader.fs");
   shader_t objectShader("object-shader.vs", "object-shader.fs");
   shader_t objectPreshader("object-preshader.vs", "object-preshader.fs");

   // Setup GUI context
   IMGUI_CHECKVERSION();
   ImGui::CreateContext();
   ImGuiIO &io = ImGui::GetIO();
   ImGui_ImplGlfw_InitForOpenGL(window, true);
   ImGui_ImplOpenGL3_Init(glsl_version);
   ImGui::StyleColorsDark();

   unsigned int cubemapTexture = load_cubemap("../Yokohama3");

   float x_rotation = 0.0;
   float y_rotation = 0.0;
   float scale = 0.25;

   glEnable(GL_DEPTH_TEST);

   auto current_rotation = glm::mat4(1.0);

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
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

      // Gui start new frame
      ImGui_ImplOpenGL3_NewFrame();
      ImGui_ImplGlfw_NewFrame();
      ImGui::NewFrame();

      // GUI
      ImGui::Begin("Settings");

      static float ratio = 1.52;
      ImGui::SliderFloat("ratio", &ratio, 1.0, 3.0);

      ImVec2 delta = ImGui::GetMouseDragDelta();
      ImGui::ResetMouseDragDelta();

      y_rotation = -delta.x / 40.0;
      x_rotation = delta.y / 40.0;
      float mouse_wheel = io.MouseWheel;
      scale /= pow(1.01, mouse_wheel);
      if (scale > 45 || scale <= 0) {
          scale *= pow(1.01, mouse_wheel);
      }
      ImGui::End();


      auto rotationX = glm::rotate(glm::mat4(1.0), glm::radians(x_rotation * 60), glm::vec3(1, 0, 0));
      auto rotationY = glm::rotate(glm::mat4(1.0), glm::radians(y_rotation * 60), glm::vec3(0, 1, 0));
      auto rotated = current_rotation * rotationX * rotationY;

      current_rotation = rotated;
      auto rotatedAndScaled = glm::scale(rotated, glm::vec3(scale));

      auto cameraPos = glm::vec3(rotatedAndScaled * glm::vec4(0, 0 , -1, 1));
      auto objectModel = glm::mat4(1.0f);
      auto objectView = glm::lookAt<float>(
              cameraPos,
              glm::vec3(0, 0, 0),
              glm::vec3(rotated * glm::vec4(0, 1 , 0, 1))
              );
      auto projection = glm::perspective<float>(45, float(display_w) / float(display_h), 0.001, 100);
      auto vp = projection * objectView;
      auto objectMVP = vp * objectModel;

//      for (int i = 0; i < vertices.size(); i += 6) {
//          auto point = glm::vec4(vertices[i], vertices[i + 1], vertices[i + 2], 1.0);
//          auto res = vp * objectModel * point;
//          std::cerr << res.x << ' ' << res.y << ' ' << res.z << ' ' << res.w << std::endl;
//      }

      //std::cerr << cameraPos.x << ' ' << cameraPos.y << ' ' << cameraPos.z << std::endl;

      objectPreshader.use();
      objectPreshader.set_uniform("mvp", glm::value_ptr(objectMVP));
      glBindVertexArray(objectVAO);
      glDrawArrays(GL_TRIANGLES, 0, triangles_number * 3);
      glBindVertexArray(0);

      glDepthFunc(GL_LEQUAL);
      objectShader.use();
      objectShader.set_uniform("model", glm::value_ptr(objectModel));
      objectShader.set_uniform("vp", glm::value_ptr(vp));
      objectShader.set_uniform("cf", ratio);
      objectShader.set_uniform("cameraPos", cameraPos.x, cameraPos.y, cameraPos.z);
      glBindVertexArray(objectVAO);
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
      glDrawArrays(GL_TRIANGLES, 0, triangles_number * 3);
      glBindVertexArray(0);

      auto cubemapView = glm::mat4(glm::mat3(objectView));
      auto cubemapVP = projection * cubemapView;

      // Cubemap render
      cubemapShader.use();
      cubemapShader.set_uniform("vp", glm::value_ptr(cubemapVP));
      glBindVertexArray(cubemapVAO);
      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
      glDrawArrays(GL_TRIANGLES, 0, 36);
      glBindVertexArray(0);
      glDepthFunc(GL_LESS);

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
