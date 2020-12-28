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
#include "libs/tiny_obj_loader.h"

// Include glfw3.h after our OpenGL definitions
#include <GLFW/glfw3.h>

// Math constant and routines for OpenGL interop
#include <glm/gtc/constants.hpp>
#include <glm/gtx/transform.hpp>
#include <glm/glm.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <cmath>
#include <unordered_map>

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

void create_water(GLuint &vbo, GLuint &vao, GLuint &ebo, float borders)
{
//    float vertices[] = {
//        0, -20, 0, 1,
//        1,  0, 0, 0,
//        0, 0, 1, 0,
//        -1, 0, 0, 0,
//        0, 0, -1, 0,
//    };
//    uint triangles[] = {
//        0, 2, 3,
//        0, 3, 4,
//        0, 4, 1,
//        0, 1, 2,
//        5, 1, 2,
//        5, 4, 1,
//        5, 2, 3
//    };
    float vertices[] = {
        -borders, -20, -borders, 1,
        -borders, -20, borders, 1,
        borders, -20, borders, 1,
        borders, -20, -borders, 1,
    };
    uint triangles[] = {
        0, 1, 3,
        1, 3, 2,
    };
    glGenVertexArrays(1, &vao);
    glGenBuffers(1, &vbo);
    glGenBuffers(1, &ebo);
    glBindVertexArray(vao);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(triangles), triangles, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), nullptr);
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
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

struct RenderingObject {
    GLuint texture = 0;
    GLuint vao = 0;
    GLuint vbo = 0;
    GLuint ebo = 0;
    uint trianglesN = 0;
};

struct Object {
    std::vector<RenderingObject> objects;

    void render(shader_t &shader, glm::mat4 model, glm::mat4 mvp) {
        for (const auto &object : objects) {
            shader.use();
            shader.set_uniform("mvp", glm::value_ptr(mvp));
            shader.set_uniform("model", glm::value_ptr(model));
            shader.set_uniform("tex", 0);
            glBindVertexArray(object.vao);
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, object.texture);
            glDrawArrays(GL_TRIANGLES, 0, object.trianglesN * 3);
            glBindVertexArray(0);
        }
    }

    void stupidRender(shader_t &shader, glm::mat4 mvp) {
        for (const auto &object : objects) {
            shader.use();
            shader.set_uniform("mvp", glm::value_ptr(mvp));
            glBindVertexArray(object.vao);
            glDrawArrays(GL_TRIANGLES, 0, object.trianglesN * 3);
            glBindVertexArray(0);
        }
    }
};

GLuint load_texture(const std::string& path) {
    std::cerr << "Loading texture by path " << path << std::endl;
    int width, height, nrChannels;
    unsigned char *data = stbi_load(path.c_str(), &width, &height, &nrChannels, 0);
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data);
    glGenerateMipmap(GL_TEXTURE_2D);
    stbi_image_free(data);
    return texture;
}

Object load_object_with_materials(const std::string &base_path, const std::string &path, float scale,
                                  float center_x, float center_z, float low_y) {
    std::cerr << "Loading object " << path << std::endl;
    const std::string& inputfile = base_path + path;
    tinyobj::attrib_t attrib;
    std::vector<tinyobj::shape_t> shapes;
    std::vector<tinyobj::material_t> materials;

    std::string err;
    std::string warn;

    bool ret = tinyobj::LoadObj(&attrib, &shapes, &materials, &warn, &err, inputfile.c_str(), base_path.c_str());
    if (!err.empty()) {
        std::cerr << err << std::endl;
    }
    if (!warn.empty()) {
        std::cerr << warn << std::endl;
    }

    if (!ret) {
        exit(1);
    }

    std::cerr << "Materials: " << materials.size() << std::endl;
    std::cerr << "Shapes: " << shapes.size() << std::endl;

    std::unordered_map<int, std::vector<float>> material_to_array;
    std::unordered_map<int, std::vector<uint>> material_to_triangles;

    float min_x = 1e9, max_x = -1e9;
    float min_y = 1e9, max_y = -1e9;
    float min_z = 1e9, max_z = -1e9;

    for (auto & shape : shapes) {
//        std::cerr << "shape " << s << std::endl;
//        std::cerr << "Materials: " << shapes[s].mesh.material_ids.size() << std::endl;
//        std::cerr << "Faces: " << shapes[s].mesh.num_face_vertices.size() << std::endl;
        // Loop over faces(polygon)
        size_t index_offset = 0;
        for (size_t f = 0; f < shape.mesh.num_face_vertices.size(); f++) {
            int fv = shape.mesh.num_face_vertices[f];
            int material_id = shape.mesh.material_ids[f];
            std::vector<float> &array = material_to_array[material_id];
            std::vector<uint> &triangles = material_to_triangles[material_id];

            assert(fv == 3);
            // Loop over vertices in the face.
            for (size_t v = 0; v < fv; v++) {
                // access to vertex
                tinyobj::index_t idx = shape.mesh.indices[index_offset + v];
                tinyobj::real_t vx = attrib.vertices[3*idx.vertex_index+0];
                min_x = std::min(min_x, vx);
                max_x = std::max(max_x, vx);
                tinyobj::real_t vy = attrib.vertices[3*idx.vertex_index+1];
                min_y = std::min(min_y, vy);
                max_y = std::max(max_y, vy);
                tinyobj::real_t vz = attrib.vertices[3*idx.vertex_index+2];
                min_z = std::min(min_z, vz);
                max_z = std::max(max_z, vz);
                array.push_back(vx);
                array.push_back(vy);
                array.push_back(vz);
                tinyobj::real_t nx = attrib.normals[3*idx.normal_index+0];
                tinyobj::real_t ny = attrib.normals[3*idx.normal_index+1];
                tinyobj::real_t nz = attrib.normals[3*idx.normal_index+2];
                array.push_back(nx);
                array.push_back(ny);
                array.push_back(nz);
                tinyobj::real_t tx = attrib.texcoords[2*idx.texcoord_index+0];
                tinyobj::real_t ty = attrib.texcoords[2*idx.texcoord_index+1];
                array.push_back(tx);
                array.push_back(ty);
                triangles.push_back(triangles.size());
            }
            index_offset += fv;
        }
    }

    std::vector<RenderingObject> objects;
    for (auto [material_id, array] : material_to_array) {
        std::vector<uint> triangles = material_to_triangles[material_id];

        for (uint i = 0; i < array.size(); i += 8) {
            array[i + 0] = (array[i + 0] - min_x - (max_x - min_x) / 2) * scale + center_x;
            array[i + 1] = (array[i + 1] - min_y) * scale + low_y;
            array[i + 2] = (array[i + 2] - min_z - (max_z - min_z) / 2) * scale + center_z;
        }

        RenderingObject object;

        object.texture = load_texture(base_path + materials[material_id].diffuse_texname);

        glGenVertexArrays(1, &object.vao);
        glGenBuffers(1, &object.vbo);
        glGenBuffers(1, &object.ebo);
        glBindVertexArray(object.vao);
        glBindBuffer(GL_ARRAY_BUFFER, object.vbo);
        glBufferData(GL_ARRAY_BUFFER, array.size() * sizeof(float), &array[0], GL_STATIC_DRAW);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, object.ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, triangles.size() * sizeof(unsigned int), &triangles[0], GL_STATIC_DRAW);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void *) nullptr);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void *) (3 * sizeof(float)));
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float), (void *) (6 * sizeof(float)));
        glEnableVertexAttribArray(2);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArray(0);

        object.trianglesN = triangles.size() / 3;
        std::cerr << "Triangles " << object.trianglesN << std::endl;

        objects.push_back(object);
    }

    std::cerr << "Object is loaded!" << std::endl;
    return Object{objects};
}

void initReflectTexture(GLuint &texColorBuffer, int width, int height) {
    glGenTextures(1, &texColorBuffer);
    glBindTexture(GL_TEXTURE_2D, texColorBuffer);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glBindTexture(GL_TEXTURE_2D, 0);

    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texColorBuffer, 0);
}

float sign(float x) {
    if (x > 0) return 1;
    if (x < 0) return -1;
    return 0;
}

const unsigned int WAVES_WIDTH = 4096, WAVES_HEIGHT = 4096;

void generateHeightmapTexture(GLuint &heightmapFBO, GLuint &heightmapTexture) {
    glGenFramebuffers(1, &heightmapFBO);
    glGenTextures(1, &heightmapTexture);
    glBindTexture(GL_TEXTURE_2D, heightmapTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, WAVES_WIDTH, WAVES_HEIGHT, 0, GL_RGB, GL_UNSIGNED_BYTE, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    GLuint depthrenderbuffer;
    glGenRenderbuffers(1, &depthrenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthrenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, WAVES_WIDTH, WAVES_HEIGHT);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthrenderbuffer);

    glBindFramebuffer(GL_FRAMEBUFFER, heightmapFBO);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, heightmapFBO, 0);
    glDrawBuffer(GL_COLOR_ATTACHMENT0);
   // glReadBuffer(GL_COLOR_ATTACHMENT0);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        assert(false);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

struct Particle {
    float x;
    float y;
    long time;
    float metersPerSecond;
    float lifetime;

    long finishTime() const {
        return time + (long) (lifetime * 1000) + 1;
    }

    long mostIntensiveTime() const {
        return time + (long) (lifetime * 1000 / 2) + 1;
    }

    float intensity(long currentTime) const {
        long middle = mostIntensiveTime();
        if (currentTime > middle) {
            return (float) (finishTime() - currentTime) / (float) (finishTime() - middle);
        }
        else {
            return (float) (currentTime - time) / (float) (middle - time);
        }
    }

    float distance(long currentTime) const {
        return metersPerSecond / 1000 * (float) (currentTime - time);
    }
};

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
    GLFWwindow *window = glfwCreateWindow(1280, 720, "3D Scene", nullptr, nullptr);

    if (window == nullptr)
        return 1;
    glfwMakeContextCurrent(window);
    glfwSwapInterval(1); // Enable vsync

    // Initialize GLEW, i.e. fill all possible function pointers for current OpenGL context
    if (glewInit() != GLEW_OK)
    {
        std::cerr << "Failed to initialize OpenGL loader!\n";
        return 1;
    }

    GLuint heightmapFBO, heightmapTexture;
    generateHeightmapTexture(heightmapFBO, heightmapTexture);

    // create our geometries
    GLuint cubemapVBO, cubemapVAO;
    create_cubemap(cubemapVBO, cubemapVAO);
    auto boat = load_object_with_materials(
            "../obj/gondol/",
           "gondol.obj",
           5,
           0, 0, -21);

    GLuint cubemapTexture = load_cubemap("../Teide");

    const float borders = 150.0;
    GLuint waterVBO, waterVAO, waterEBO;
    create_water(waterVBO, waterVAO, waterEBO, borders);
    GLuint waterDuDv = load_texture("../obj/water/dudv.png");

    GLuint reflectBuffer;
    glGenFramebuffers(1, &reflectBuffer);

    // init shader
    shader_t cubemapShader("cubemap-shader.vs", "cubemap-shader.fs");
    shader_t boatShader("boat-shader.vs", "boat-shader.fs");
    shader_t objectPreshader("object-preshader.vs", "object-preshader.fs");
    shader_t waterPreshader("water-preshader.vs", "object-preshader.fs");
    shader_t waterShader("water-shader.vs", "water-shader.fs");
    shader_t wavesShader("heightmap-shader.vs", "heightmap-shader.fs");

    // Setup GUI context
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO &io = ImGui::GetIO();
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init(glsl_version);
    ImGui::StyleColorsDark();

    glEnable(GL_DEPTH_TEST);

    auto currentRotation = glm::mat4(1.0);
    auto newCurrentRotation = glm::mat4(1.0);

    auto cameraPos = glm::vec3(30, 0, -30);

    auto start = std::chrono::system_clock::now();

    std::vector<Particle> activeParticles;

    auto prevTime = start;
    double perMeterParticles = 0;
    double perSecondParticles = 0;

    float fps = 0;
    long msperframe = 0;

    while (!glfwWindowShouldClose(window))
    {
        glfwPollEvents();

        // Get windows size
        int display_w, display_h;
        glfwGetFramebufferSize(window, &display_w, &display_h);

        // Set viewport to fill the whole window area
        glViewport(0, 0, display_w, display_h);

        // Fill background with solid color

        // Gui start new frame
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        // GUI
        ImGui::Begin("Settings");
        static float boatRadius = 20;
        ImGui::SliderFloat("Boat radius", &boatRadius, 0, 100);
        static float particlesPerMeterIntensity = 1;
        ImGui::SliderFloat("Particles per meter", &particlesPerMeterIntensity, 0, 5);
        static float particlesPerSecondIntensity = 2;
        ImGui::SliderFloat("Particles per second", &particlesPerSecondIntensity, 0, 20);
        static float waveSpeed = 1.5;
        ImGui::SliderFloat("wave speed (meters per second)", &waveSpeed, 0.5, 20.0);
        static float waveLifetime = 7.0;
        ImGui::SliderFloat("Wave lifetime (seconds)", &waveLifetime, 1.0, 20.0);
        static float particleWidth = -3;
        ImGui::SliderFloat("Particle width", &particleWidth, -5, -2);
        static int pomSteps = 20;
        ImGui::SliderInt("POM steps", &pomSteps, 1, 100);
        static float waveHeight = 0.15;
        ImGui::SliderFloat("Wave height", &waveHeight, 0, 0.5);
        static bool pomOn = true;
        ImGui::Checkbox("POM on", &pomOn);
        static bool pomOpt = true;
        ImGui::Checkbox("POM optimization", &pomOpt);

        ImGui::Text("FPS: %f", fps);
        ImGui::Text("ms per frame: %ld", msperframe);
        ImGui::Text("Active particles: %zu", activeParticles.size());

        ImVec2 delta = ImGui::GetMouseDragDelta();
        ImGui::ResetMouseDragDelta();

        float y_rotation = -delta.x / 40.0f;
        float x_rotation = delta.y / 40.0f;
        if (ImGui::IsWindowFocused(1)) {
            y_rotation = 0;
            x_rotation = 0;
        }
        float mouse_wheel = io.MouseWheel;

        ImGui::End();

        auto rotationX = glm::rotate(glm::mat4(1.0), glm::radians(x_rotation * 60), glm::vec3(1, 0, 0));
        auto rotationY = glm::rotate(glm::mat4(1.0), glm::radians(y_rotation * 60), glm::vec3(0, 1, 0));
        auto rotated = currentRotation * rotationX * rotationY;

        currentRotation = rotated;

        auto viewVector = glm::vec3(rotated * glm::vec4(0, 0 , 1, 1));
        cameraPos += viewVector * float(1) * mouse_wheel;
        auto objectModel = glm::mat4(1.0f);
        auto objectView = glm::lookAt<float>(
                cameraPos,
                cameraPos + viewVector,
                glm::vec3(glm::vec4(0, 1 , 0, 1)));
        auto projection = glm::perspective<float>(glm::radians(45.0f), float(display_w) / float(display_h), 0.001, 10000);
        auto objectVP = projection * objectView;

        glDepthFunc(GL_LESS);
        auto end = std::chrono::system_clock::now();
        long millisecondsPassed = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
        long fromPrevPassed = std::chrono::duration_cast<std::chrono::milliseconds>(end - prevTime).count();
        prevTime = end;
        double elapsedTime = (double) millisecondsPassed * 1e-4;
        double elapsedFromPrev = (double) fromPrevPassed * 1e-4;
        fps = (float) 1000 / (float) fromPrevPassed;
        msperframe = fromPrevPassed;

        auto circleRadius = boatRadius;
        auto metersPassed = 2 * M_PI * circleRadius * (elapsedFromPrev / (2 * M_PI));

        perMeterParticles += metersPassed * particlesPerMeterIntensity;
        perSecondParticles += (double) fromPrevPassed / 1000.0 * particlesPerSecondIntensity;

        int addParticles = int(perSecondParticles) + int(perMeterParticles);
        perMeterParticles -= int(perMeterParticles);
        perSecondParticles -= int(perSecondParticles);

        auto startX = circleRadius * sin(elapsedTime);
        auto startZ = circleRadius * cos(elapsedTime);

        for (int i = 0; i < addParticles; ++i) {
            activeParticles.push_back(
                    Particle{(float) startX, (float) startZ, millisecondsPassed, waveSpeed, waveLifetime}
            );
        }

        for (int i = 0; i < activeParticles.size(); ++i) {
            if (activeParticles[i].finishTime() + 1000 < millisecondsPassed) {
                std::swap(activeParticles[i],activeParticles.back());
                activeParticles.pop_back();
                --i;
            }
        }

        auto boatModel =
                glm::mat4x4(
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        startX, 0, startZ, 1
                ) *
                objectModel *
                glm::rotate(glm::mat4(1.0), float(elapsedTime + M_PI / 2), glm::vec3(0, 1, 0));

        auto boatMVP = objectVP * boatModel;

        auto cubemapView = glm::mat4(glm::mat3(objectView));
        auto cubemapVP = projection * cubemapView;


        { // draw waves height map
            glViewport(0, 0, WAVES_WIDTH, WAVES_HEIGHT);
            glBindFramebuffer(GL_FRAMEBUFFER, heightmapFBO);
            glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            glEnable(GL_DEPTH_TEST);

            std::sort(activeParticles.begin(), activeParticles.end(), [&](const Particle &a, const Particle &b) {
                return a.intensity(millisecondsPassed) > b.intensity(millisecondsPassed);
            });

            std::vector<uint> triangles;
            std::vector<float> data;

            for (const auto &particle : activeParticles) {
                float dist = particle.distance(millisecondsPassed) + 2;
                std::vector<std::vector<float>> points = {
                        {particle.x - dist, particle.y - dist, 0},
                        {particle.x - dist, particle.y + dist, 0},
                        {particle.x + dist, particle.y + dist, 0},
                        {particle.x - dist, particle.y - dist, 0},
                        {particle.x + dist, particle.y + dist, 0},
                        {particle.x + dist, particle.y - dist, 0}
                };
                for (auto point : points) {
                    triangles.push_back(triangles.size());
                    data.push_back(point[0] / borders);
                    data.push_back(point[1] / borders);
                    data.push_back(point[2] / borders);
                    data.push_back(particle.x);
                    data.push_back(particle.y);
                    data.push_back(particle.distance(millisecondsPassed));
                    data.push_back(particle.intensity(millisecondsPassed));
                }
            }

            GLuint vao, vbo, ebo;
            glGenVertexArrays(1, &vao);
            glGenBuffers(1, &vbo);
            glGenBuffers(1, &ebo);
            glBindVertexArray(vao);
            glBindBuffer(GL_ARRAY_BUFFER, vbo);
            glBufferData(GL_ARRAY_BUFFER, data.size() * sizeof(float), &data[0], GL_STATIC_DRAW);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, triangles.size() * sizeof(unsigned int), &triangles[0], GL_STATIC_DRAW);
            glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(float), (void *) nullptr);
            glEnableVertexAttribArray(0);
            glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 7 * sizeof(float), (void *) (3 * sizeof(float)));
            glEnableVertexAttribArray(1);
            glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, 7 * sizeof(float), (void *) (5 * sizeof(float)));
            glEnableVertexAttribArray(2);
            glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, 7 * sizeof(float), (void *) (6 * sizeof(float)));
            glEnableVertexAttribArray(3);
            glBindBuffer(GL_ARRAY_BUFFER, 0);
            glBindVertexArray(0);

            wavesShader.use();
            wavesShader.set_uniform("eps", (float) pow(10, particleWidth));
            wavesShader.set_uniform("border", borders);

            glBindVertexArray(vao);
            glDrawElements(GL_TRIANGLES, triangles.size(), GL_UNSIGNED_INT, nullptr);
            glBindVertexArray(0);
            glDeleteVertexArrays(1, &vao);
            glDeleteBuffers(1, &vbo);
            glDeleteBuffers(1, &ebo);
        }

        glViewport(0, 0, display_w, display_h);

        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glClearColor(0.0f, 1.0f, 0.0f, 1.00f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        boat.render(boatShader, boatModel, boatMVP);

        glDepthFunc(GL_LEQUAL);
        waterShader.use();
        waterShader.set_uniform("cameraPos", cameraPos.x, cameraPos.y, cameraPos.z);
        waterShader.set_uniform("model", glm::value_ptr(objectModel));
        waterShader.set_uniform("vp", glm::value_ptr(objectVP));
        waterShader.set_uniform("cubeMap", 0);
        waterShader.set_uniform("wavesTexture", 1);
        waterShader.set_uniform("pomSteps", pomSteps);
        waterShader.set_uniform("waveHeight", waveHeight);
        waterShader.set_uniform("pomOn", pomOn);
        waterShader.set_uniform("pomOpt", pomOpt);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, heightmapTexture);
        glBindVertexArray(waterVAO);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nullptr);
        glBindVertexArray(0);

        glDepthFunc(GL_LEQUAL);

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
