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

void create_water(GLuint &vbo, GLuint &vao, GLuint &ebo, float landscapeMaxX, float landscapeMaxZ)
{
    float vertices[] = {
        0, -20, 0, 1,
        1,  0, 0, 0,
        0, 0, 1, 0,
        -1, 0, 0, 0,
        0, 0, -1, 0,
        landscapeMaxX, -20, landscapeMaxZ, 1,
    };
    uint triangles[] = {
        0, 2, 3,
        0, 3, 4,
        0, 4, 1,
        5, 1, 2,
        5, 4, 1,
        5, 2, 3
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

    template<typename T, glm::qualifier Q>
    void render(shader_t &shader, glm::mat<4, 4, T, Q> mvp) {
        for (const auto &object : objects) {
            shader.use();
            shader.set_uniform("mvp", glm::value_ptr(mvp));
            shader.set_uniform("tex", 0);
            glBindVertexArray(object.vao);
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, object.texture);
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
                                  float center_x, float center_y, float center_z) {
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
            array[i + 1] = (array[i + 1] - min_y - (max_y - min_y) / 2) * scale + center_y;
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

struct Landscape {
    GLuint vao = 0;
    GLuint vbo = 0;
    GLuint ebo = 0;
    uint trianglesN = 0;
    std::vector<GLuint> tileTextures;
    glm::vec3 heights = glm::vec3(0.0);

    template<typename T, glm::qualifier Q>
    void render(shader_t &shader, glm::mat<4, 4, T, Q> model, glm::mat<4, 4, T, Q> vp) {
        shader.use();
        shader.set_uniform("model", glm::value_ptr(model));
        shader.set_uniform("vp", glm::value_ptr(vp));
        shader.set_uniform("lowTexture", 0);
        shader.set_uniform("middleTexture", 1);
        shader.set_uniform("highTexture", 2);
        shader.set_uniform("heights", heights.x, heights.y, heights.z);
        glBindVertexArray(vao);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, tileTextures[0]);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, tileTextures[1]);
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, tileTextures[2]);
        glDrawElements(GL_TRIANGLES, trianglesN * 3, GL_UNSIGNED_INT, nullptr);
        glBindVertexArray(0);
    }
};

struct TileInfo {
    std::string filename;
};

std::vector<std::vector<std::vector<unsigned char >>> addBorders(const unsigned char * map, int height, int width) {
    std::vector<std::vector<std::vector<unsigned char >>> result;
    result.resize(height + 2);
    for (int h = 0; h < height + 2; ++h) {
        result[h].resize(width + 2, std::vector<unsigned char >{0, 0, 0});
    }
    for (int h = 0; h < height; ++h) {
        for (int w = 0; w < width; ++w) {
            int i = (h * width + w) * 4;
            result[h + 1][w + 1] = {map[i], map[i + 1], map[i + 2]};
        }
    }
    return result;
}

Landscape load_landscape(const std::string &heightmapFolderPath,
                         const std::vector<TileInfo> &tiles,
                         float pixelLength,
                         glm::vec3 heights,
                         float maxHeight,
                         float &maxX,
                         float &maxZ) {
    static const std::string HEIGHT_MAP_FILEMANE = "hm.png";
    static const std::string HEIGHT_MAP_NORMALS_FILEMANE = "nm.png";
    int heightMapWidth, heightMapHeight, nrChannels;
    unsigned char *heightMapWithoutBorders = stbi_load((heightmapFolderPath + HEIGHT_MAP_FILEMANE).c_str(), &heightMapWidth, &heightMapHeight, &nrChannels, 0);
    std::vector<std::vector<std::vector<unsigned char >>> heightMap = addBorders(heightMapWithoutBorders, heightMapHeight, heightMapWidth);
    stbi_image_free(heightMapWithoutBorders);
    heightMapHeight += 2;
    heightMapWidth += 2;
    maxX = float(heightMapHeight) * pixelLength;
    maxZ = float(heightMapWidth) * pixelLength;
    //unsigned char *heightMapNormals = stbi_load((heightmapFolderPath + HEIGHT_MAP_NORMALS_FILEMANE).c_str(), &width, &height, &nrChannels, 0);
    std::vector<float> array;
    //assert(nrChannels == 4);

    for (int h = 0; h < heightMapHeight; ++h) {
        for (int w = 0; w < heightMapWidth; ++w) {
            unsigned short r = heightMap[h][w][0];
            float curHeight = float(r) / 255 * maxHeight;
            float x = float(0) / 255;
            float y = float(0) / 255;
            float z = float(0) / 255;
            glm::vec3 normal = glm::normalize(glm::vec3(x, y, z));
            glm::vec3 coords = glm::vec3(h * pixelLength, curHeight, w * pixelLength);
            array.push_back(coords.x);
            array.push_back(coords.y);
            array.push_back(coords.z);
            array.push_back(normal.x);
            array.push_back(normal.y);
            array.push_back(normal.z);
        }
    }
    //stbi_image_free(heightMapNormals);

    std::vector<uint> triangles;
    for (int h = 0; h + 1 < heightMapHeight; ++h) {
        for (int w = 0; w + 1 < heightMapWidth; ++w) {
            uint a = h * heightMapWidth + w;
            uint b = a + 1;
            uint c = a + heightMapWidth;
            uint d = c + 1;
            triangles.push_back(c);
            triangles.push_back(a);
            triangles.push_back(b);
            triangles.push_back(c);
            triangles.push_back(b);
            triangles.push_back(d);
        }
    }
    Landscape object;
    object.heights = heights;
    object.trianglesN = triangles.size() / 3;
    glGenVertexArrays(1, &object.vao);
    glGenBuffers(1, &object.vbo);
    glGenBuffers(1, &object.ebo);
    glBindVertexArray(object.vao);
    glBindBuffer(GL_ARRAY_BUFFER, object.vbo);
    glBufferData(GL_ARRAY_BUFFER, array.size() * sizeof(float), &array[0], GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, object.ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, triangles.size() * sizeof(unsigned int), &triangles[0], GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *) nullptr);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void *) (3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);

    object.tileTextures = {
        load_texture(heightmapFolderPath + tiles[0].filename),
        load_texture(heightmapFolderPath + tiles[1].filename),
        load_texture(heightmapFolderPath + tiles[2].filename)
    };

    return object;
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
    GLFWwindow *window = glfwCreateWindow(400, 400, "Dear ImGui - Conan", nullptr, nullptr);

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

    // create our geometries
    GLuint cubemapVBO, cubemapVAO;
    create_cubemap(cubemapVBO, cubemapVAO);
    auto boat = load_object_with_materials(
            "../obj/gondol/",
           "gondol.obj",
           5,
           0, -15, 0);

    auto lighthouse = load_object_with_materials(
            "../obj/lighthouse/",
            "lighthouse.obj",
            1,
            0,0,0);

    uint cubemapTexture = load_cubemap("../Teide");

    glm::vec3 heights = glm::vec3(0.0, 8.0, 30.0);
    std::vector<TileInfo> tileInfos;
    tileInfos.push_back({"SandWhite.jpg"});
    tileInfos.push_back({"SandBlack.jpg"});
    tileInfos.push_back({"Rock.jpg"});
    float landscapeMaxX, landscapeMaxZ;
    Landscape landscape = load_landscape(
            "../obj/heightmap/",
            tileInfos,
            0.1,
            heights,
            heights.z,
            landscapeMaxX,
            landscapeMaxZ);

    GLuint waterVBO, waterVAO, waterEBO;
    create_water(waterVBO, waterVAO, waterEBO, landscapeMaxX, landscapeMaxZ);

    // init shader
    shader_t cubemapShader("cubemap-shader.vs", "cubemap-shader.fs");
    shader_t boatShader("boat-shader.vs", "boat-shader.fs");
    shader_t objectPreshader("object-preshader.vs", "object-preshader.fs");
    shader_t lighthouseShader("lighthouse-shader.vs", "lighthouse-shader.fs");
    shader_t waterShader("water-shader.vs", "water-shader.fs");
    shader_t landscapeShader("landscape-shader.vs", "landscape-shader.fs");

    // Setup GUI context
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO &io = ImGui::GetIO();
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init(glsl_version);
    ImGui::StyleColorsDark();

    glEnable(GL_DEPTH_TEST);

    auto current_rotation = glm::mat4(1.0);

    auto cameraPos = glm::vec3(0, 0, -1);

    auto start = std::chrono::system_clock::now();

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

        static float landHeight;
        ImGui::SliderFloat("land height", &landHeight, -50, -15);

        ImVec2 delta = ImGui::GetMouseDragDelta();
        ImGui::ResetMouseDragDelta();

        float y_rotation = -delta.x / 40.0;
        float x_rotation = delta.y / 40.0;
        float mouse_wheel = io.MouseWheel;
        ImGui::End();


        auto rotationX = glm::rotate(glm::mat4(1.0), glm::radians(x_rotation * 60), glm::vec3(1, 0, 0));
        auto rotationY = glm::rotate(glm::mat4(1.0), glm::radians(y_rotation * 60), glm::vec3(0, 1, 0));
        auto rotated = current_rotation * rotationX * rotationY;

        current_rotation = rotated;

        auto viewVector = glm::vec3(rotated * glm::vec4(0, 0 , 1, 1));
        cameraPos += viewVector * float(1) * mouse_wheel;
        //std::cerr << cameraPos.x << ' ' << cameraPos.y << ' ' << cameraPos.z << std::endl;
        auto objectModel = glm::mat4(1.0f);
        auto objectView = glm::lookAt<float>(
                cameraPos,
                cameraPos + viewVector,
                glm::vec3(rotated * glm::vec4(0, 1 , 0, 1)));
        auto projection = glm::perspective<float>(45, float(display_w) / float(display_h), 0.001, 10000);
        auto objectVP = projection * objectView;
        auto objectMVP = objectVP * objectModel;

//      for (int i = 0; i < vertices.size(); i += 6) {
//          auto point = glm::vec4(vertices[i], vertices[i + 1], vertices[i + 2], 1.0);
//          auto res = vp * objectModel * point;
//          std::cerr << res.x << ' ' << res.y << ' ' << res.z << ' ' << res.w << std::endl;
//      }

      //std::cerr << cameraPos.x << ' ' << cameraPos.y << ' ' << cameraPos.z << std::endl;
        glDepthFunc(GL_LESS);
        auto end = std::chrono::system_clock::now();
        double elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() * 1e-4;

        auto circleRadius = std::max(landscapeMaxX, landscapeMaxZ) / 2 * sqrt(2) + 20;
        auto startX = circleRadius * sin(elapsedTime) + landscapeMaxX / 2;
        auto startZ = circleRadius * cos(elapsedTime) + landscapeMaxZ / 2;
        auto boatMVP = objectVP *
                glm::mat4x4(
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        startX, 0, startZ, 1
                ) *
                objectModel *
                glm::rotate(glm::mat4(1.0), float(elapsedTime + M_PI / 2), glm::vec3(0, 1, 0));
        boat.render(boatShader, boatMVP);
        lighthouse.render(lighthouseShader, objectMVP);

        auto landscapeModel = glm::mat4x4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, -20, 0, 1
        ) * objectModel;
        landscape.render(landscapeShader, landscapeModel, objectVP);

        glDepthFunc(GL_LEQUAL);
        waterShader.use();
        waterShader.set_uniform("cameraPos", cameraPos.x, cameraPos.y, cameraPos.z);
        waterShader.set_uniform("model", glm::value_ptr(objectModel));
        waterShader.set_uniform("vp", glm::value_ptr(objectVP));
        waterShader.set_uniform("cubemap", 0);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
        glBindVertexArray(waterVAO);
        glDrawElements(GL_TRIANGLES, 18, GL_UNSIGNED_INT, nullptr);
        glBindVertexArray(0);

        glDepthFunc(GL_LEQUAL);

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
