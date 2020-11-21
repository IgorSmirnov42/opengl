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
        0, 1, 2,
//        5, 1, 2,
//        5, 4, 1,
//        5, 2, 3
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

    void render(shader_t &shader, glm::mat4 model, glm::mat4 mvp, glm::vec3 sunlight,
                glm::vec3 lightAmbient, glm::vec3 lightDiffuse, glm::vec3 lightSpecular,
                float ambientStrength, glm::mat4 lightVP, GLuint shadowMap,
                glm::mat4 projectVP, GLuint projectorTexture, GLuint projectorDepthMap) {
        for (const auto &object : objects) {
            shader.use();
            shader.set_uniform("sunVP", glm::value_ptr(lightVP));
            shader.set_uniform("mvp", glm::value_ptr(mvp));
            shader.set_uniform("model", glm::value_ptr(model));
            shader.set_uniform("tex", 0);
            shader.set_uniform("shadowMap", 1);
            shader.set_uniform("ambientStrength", ambientStrength);
            shader.set_uniform("sunlight", sunlight.x, sunlight.y, sunlight.z);
            shader.set_uniform("light.ambient", lightAmbient.r, lightAmbient.g, lightAmbient.b);
            shader.set_uniform("light.diffuse", lightDiffuse.r, lightDiffuse.g, lightDiffuse.b);
            shader.set_uniform("light.specular", lightSpecular.r, lightSpecular.g, lightSpecular.b);
            shader.set_uniform("projectVP", glm::value_ptr(projectVP));
            shader.set_uniform("projectorTexture", 2);
            shader.set_uniform("projectorDepthMap", 3);
            glBindVertexArray(object.vao);
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, object.texture);
            glActiveTexture(GL_TEXTURE1);
            glBindTexture(GL_TEXTURE_2D, shadowMap);
            glActiveTexture(GL_TEXTURE2);
            glBindTexture(GL_TEXTURE_2D, projectorTexture);
            glActiveTexture(GL_TEXTURE3);
            glBindTexture(GL_TEXTURE_2D, projectorDepthMap);
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

struct Landscape {
    GLuint vao = 0;
    GLuint vbo = 0;
    GLuint ebo = 0;
    uint trianglesN = 0;
    std::vector<GLuint> tileTextures;
    glm::vec3 heights = glm::vec3(0.0);

    void render(shader_t &shader, glm::mat4 model, glm::mat4 vp, glm::vec3 sunlight,
                glm::vec3 lightAmbient, glm::vec3 lightDiffuse, glm::vec3 lightSpecular,
                float ambientStrength, glm::mat4 lightVP, GLuint shadowMap,
                glm::mat4 projectVP, GLuint projectorTexture, GLuint projectorDepthMap) {
        shader.use();
        shader.set_uniform("sunVP", glm::value_ptr(lightVP));
        shader.set_uniform("model", glm::value_ptr(model));
        shader.set_uniform("vp", glm::value_ptr(vp));
        shader.set_uniform("lowTexture", 0);
        shader.set_uniform("middleTexture", 1);
        shader.set_uniform("highTexture", 2);
        shader.set_uniform("shadowMap", 3);
        shader.set_uniform("heights", heights.x, heights.y, heights.z);
        shader.set_uniform("sunlight", sunlight.r, sunlight.g, sunlight.b);
        shader.set_uniform("light.ambient", lightAmbient.r, lightAmbient.g, lightAmbient.b);
        shader.set_uniform("light.diffuse", lightDiffuse.r, lightDiffuse.g, lightDiffuse.b);
        shader.set_uniform("light.specular", lightSpecular.r, lightSpecular.g, lightSpecular.b);
        shader.set_uniform("ambientStrength", ambientStrength);
        shader.set_uniform("projectVP", glm::value_ptr(projectVP));
        shader.set_uniform("projectorTexture", 4);
        shader.set_uniform("projectorDepthMap", 5);
        glBindVertexArray(vao);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, tileTextures[0]);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, tileTextures[1]);
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, tileTextures[2]);
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, shadowMap);
        glActiveTexture(GL_TEXTURE4);
        glBindTexture(GL_TEXTURE_2D, projectorTexture);
        glActiveTexture(GL_TEXTURE5);
        glBindTexture(GL_TEXTURE_2D, projectorDepthMap);
        glDrawElements(GL_TRIANGLES, trianglesN * 3, GL_UNSIGNED_INT, nullptr);
        glBindVertexArray(0);
    }

    void stupidRender(shader_t &shader, glm::mat4 mvp) const {
        shader.use();
        shader.set_uniform("mvp", glm::value_ptr(mvp));
        glBindVertexArray(vao);
        glDrawElements(GL_TRIANGLES, trianglesN * 3, GL_UNSIGNED_INT, nullptr);
        glBindVertexArray(0);
    }
};

struct TileInfo {
    std::string filename;
};

std::vector<std::vector<std::vector<unsigned char>>> addBorders(const unsigned char * map, int height, int width,
                                                                const std::vector<unsigned char>& border) {
    std::vector<std::vector<std::vector<unsigned char>>> result;
    result.resize(height + 2);
    for (int h = 0; h < height + 2; ++h) {
        result[h].resize(width + 2, border);
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
                         float &maxZ,
                         float lighthouseX,
                         float lighthouseZ,
                         float &lighthouseY) {
    static const std::string HEIGHT_MAP_FILEMANE = "hm.png";
    static const std::string HEIGHT_MAP_NORMALS_FILEMANE = "nm.png";
    int heightMapWidth, heightMapHeight, nrChannels;
    unsigned char *heightMapWithoutBorders = stbi_load((heightmapFolderPath + HEIGHT_MAP_FILEMANE).c_str(), &heightMapWidth, &heightMapHeight, &nrChannels, 0);
    std::vector<std::vector<std::vector<unsigned char>>> heightMap = addBorders(heightMapWithoutBorders,
                                                                                 heightMapHeight,
                                                                                 heightMapWidth,
                                                                                 std::vector<unsigned char>{0, 0, 0});
    stbi_image_free(heightMapWithoutBorders);
    heightMapHeight += 2;
    heightMapWidth += 2;
    maxX = float(heightMapHeight - 1) * pixelLength;
    maxZ = float(heightMapWidth - 1) * pixelLength;
    int normalMapHeight, normalMapWidth;
    unsigned char *normalMapWithoutBorders = stbi_load((heightmapFolderPath + HEIGHT_MAP_NORMALS_FILEMANE).c_str(),
                                                &normalMapWidth, &normalMapHeight, &nrChannels, 0);
    std::vector<std::vector<std::vector<unsigned char>>> normalMap = addBorders(normalMapWithoutBorders,
                                                                                 normalMapHeight,
                                                                                 normalMapWidth,
                                                                                 std::vector<unsigned char>{0, 0, 1});
    normalMapHeight += 2;
    normalMapWidth += 2;
    stbi_image_free(normalMapWithoutBorders);
    std::vector<float> array;
    //assert(nrChannels == 4);
    lighthouseY = 0;

    for (int h = 0; h < heightMapHeight; ++h) {
        for (int w = 0; w < heightMapWidth; ++w) {
            unsigned short r = heightMap[h][w][0];
            float curHeight = float(r) / 255 * maxHeight;
            float x = (float) normalMap[h][w][0] / 255.0f;
            float y = (float) normalMap[h][w][1] / 255.0f;
            float z = (float) normalMap[h][w][2] / 255.0f;
            x = x * 2 - 1;
            y = y * 2 - 1;
            z = z * 2 - 1;
            glm::vec3 normal = glm::normalize(glm::vec3(x, z, y));
            glm::vec3 coords = glm::vec3((float) h * pixelLength, curHeight, (float) w * pixelLength);
            if ((float) (h - 1) * pixelLength <= lighthouseX && lighthouseX <= (float) h * pixelLength &&
                    (float) (w - 1) * pixelLength <= lighthouseZ && lighthouseZ <= (float) w * pixelLength) {
                lighthouseY = curHeight;
            }
            array.push_back(coords.x);
            array.push_back(coords.y);
            array.push_back(coords.z);
            array.push_back(normal.x);
            array.push_back(normal.y);
            array.push_back(normal.z);
        }
    }

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
    object.heights -= glm::vec3(25);
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

const unsigned int SHADOW_WIDTH = 1024, SHADOW_HEIGHT = 1024;

void generateDepthTexture(GLuint &depthMapFBO, GLuint &depthTexture) {
    glGenFramebuffers(1, &depthMapFBO);
    glGenTextures(1, &depthTexture);
    glBindTexture(GL_TEXTURE_2D, depthTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT,
                 SHADOW_WIDTH, SHADOW_HEIGHT, 0, GL_DEPTH_COMPONENT, GL_FLOAT, nullptr);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glBindFramebuffer(GL_FRAMEBUFFER, depthMapFBO);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthTexture, 0);
    glDrawBuffer(GL_NONE);
    glReadBuffer(GL_NONE);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
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

    GLuint depthMapFBO, depthTexture;
    generateDepthTexture(depthMapFBO, depthTexture);

    GLuint lighthouseProjectionFBO, lighthouseProjectionDepthMap;
    generateDepthTexture(lighthouseProjectionFBO, lighthouseProjectionDepthMap);

    // create our geometries
    GLuint cubemapVBO, cubemapVAO;
    create_cubemap(cubemapVBO, cubemapVAO);
    auto boat = load_object_with_materials(
            "../obj/gondol/",
           "gondol.obj",
           5,
           0, 0, -21);

    GLuint cubemapTexture = load_cubemap("../Teide");

    glm::vec3 heights = glm::vec3(0.0, 8.0, 30.0);
    std::vector<TileInfo> tileInfos;
    tileInfos.push_back({"SandWhite.jpg"});
    tileInfos.push_back({"SandBlack.jpg"});
    tileInfos.push_back({"Rock.jpg"});
    float landscapeMaxX, landscapeMaxZ;
    float lighthouseX = 20, lighthouseY, lighthouseZ = 20;
    Landscape landscape = load_landscape(
            "../obj/heightmap/",
            tileInfos,
            0.1,
            heights,
            heights.z,
            landscapeMaxX,
            landscapeMaxZ,
            lighthouseX,
            lighthouseZ,
            lighthouseY);

    lighthouseY -= 25;

    auto lighthouse = load_object_with_materials(
            "../obj/lighthouse/",
            "lighthouse.obj",
            1,
            lighthouseX, lighthouseZ, lighthouseY);

    GLuint waterVBO, waterVAO, waterEBO;
    create_water(waterVBO, waterVAO, waterEBO, landscapeMaxX, landscapeMaxZ);
    GLuint waterDuDv = load_texture("../obj/water/dudv.png");
    GLuint catTexture = load_texture("../obj/tex/cat.jpg");

    GLuint reflectBuffer;
    glGenFramebuffers(1, &reflectBuffer);

    // init shader
    shader_t cubemapShader("cubemap-shader.vs", "cubemap-shader.fs");
    shader_t boatShader("boat-shader.vs", "boat-shader.fs");
    shader_t objectPreshader("object-preshader.vs", "object-preshader.fs");
    shader_t waterPreshader("water-preshader.vs", "object-preshader.fs");
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

    auto currentRotation = glm::mat4(1.0);
    auto newCurrentRotation = glm::mat4(1.0);

    auto cameraPos = glm::vec3(30, 0, -30);

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

        // Gui start new frame
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        // GUI
        ImGui::Begin("Settings");
        static float boatRadius = 20;
        ImGui::SliderFloat("Boat radius", &boatRadius, 5, 30);
        static float waterTileSize = 100;
        ImGui::SliderFloat("water tile", &waterTileSize, 10, 1000);
        static float dudvStrength = 0.01;
        ImGui::SliderFloat("dudv strength", &dudvStrength, 0.001, 0.2);
        static float waterSpeed = 0.25;
        ImGui::SliderFloat("water speed", &waterSpeed, 0.001, 1);
        static float sunlightX = -1.0;
        ImGui::SliderFloat("Sunlight x", &sunlightX, -1, 1);
        static float sunlightY = 1.0;
        ImGui::SliderFloat("Sunlight y", &sunlightY, 0.001, 1);
        static float sunlightZ = -1.0;
        ImGui::SliderFloat("Sunlight z", &sunlightZ, -1, 1);
        static float lightAmbient[3] = {0.7, 0.7, 0.7};
        ImGui::ColorEdit3("Light ambient", lightAmbient);
        static float lightDiffuse[3] = {0.9, 0.9, 0.8};
        ImGui::ColorEdit3("Light diffuse", lightDiffuse);
        static float lightSpecular[3] = {1, 1, 1};
        //ImGui::ColorEdit3("Light specular", lightSpecular);
        static float landscapeAmbientStrength = 0.1;
        ImGui::SliderFloat("Landscape ambient strength", &landscapeAmbientStrength, 0.0, 0.5);
        static float boatAmbientStrength = 0.25;
        ImGui::SliderFloat("Boat ambient strength", &boatAmbientStrength, 0.0, 0.5);
        static float lighthouseAmbientStrength = 0.25;
        ImGui::SliderFloat("Lighthouse ambient strength", &lighthouseAmbientStrength, 0.0, 0.5);
        static float projectRadius = 5;
        ImGui::SliderFloat("Project radius", &projectRadius, 2.0, 20.0);
        static float lighthouseProjectionDegree = 20;
        ImGui::SliderFloat("Lighthouse projection degree", &lighthouseProjectionDegree, 1, 45);
        static float projectorHeight = 5;
        ImGui::SliderFloat("Projector height", &projectorHeight, -20, 45);


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

        auto sunlight = glm::vec3(sunlightX, sunlightY, sunlightZ);
        auto sunlightAmbient = glm::vec3(lightAmbient[0], lightAmbient[1], lightAmbient[2]);
        auto sunlightDiffuse = glm::vec3(lightDiffuse[0], lightDiffuse[1], lightDiffuse[2]);
        auto sunlightSpecular = glm::vec3(lightSpecular[0], lightSpecular[1], lightSpecular[2]);
        //auto landscapeAmbientColor = glm::vec3(landscapeAmbient[0], landscapeAmbient[1], landscapeAmbient[2]);

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
        auto objectMVP = objectVP * objectModel;

        glDepthFunc(GL_LESS);
        auto end = std::chrono::system_clock::now();
        double elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() * 1e-4;

        auto circleRadius = std::max(landscapeMaxX, landscapeMaxZ) / 2 * sqrt(2) + boatRadius;
        auto startX = circleRadius * sin(elapsedTime) + landscapeMaxX / 2;
        auto startZ = circleRadius * cos(elapsedTime) + landscapeMaxZ / 2;
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

        auto landscapeModel = glm::mat4x4(
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, -25, 0, 1
        ) * objectModel;

        auto cubemapView = glm::mat4(glm::mat3(objectView));
        auto cubemapVP = projection * cubemapView;

        auto projectorX = projectRadius * sin(elapsedTime) + lighthouseX;
        auto projectorZ = projectRadius * cos(elapsedTime) + lighthouseZ;
        auto projectorCoords = glm::vec3(lighthouseX, projectorHeight, lighthouseZ);
        auto projectorPoint = glm::vec3(projectorX, 0.0f, projectorZ);
        auto projectProjection = glm::perspective<float>(glm::radians(lighthouseProjectionDegree), 1.0, 1, 1000);
        auto projectView = glm::lookAt(projectorCoords,
                                     projectorPoint,
                                     glm::vec3(0, 1, 0));
        auto projectVP = projectProjection * projectView;
        auto projectorDir = projectorPoint - projectorCoords;

//        std::cerr << "Projection\n";
//        for (int i = 0; i < 4; ++i) {
//            std::cerr << projectVP[i].x << ' ' << projectVP[i].y << ' ' << projectVP[i].z << ' ' << projectVP[i].w << '\n';
//        }

        { // lighthouse projection
            glViewport(0, 0, SHADOW_WIDTH, SHADOW_HEIGHT);
            glBindFramebuffer(GL_FRAMEBUFFER, lighthouseProjectionFBO);
            glClear(GL_DEPTH_BUFFER_BIT);
            glEnable(GL_DEPTH_TEST);

            if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
                std::cout << "ERROR::FRAMEBUFFER:: Framebuffer is not complete!" << std::endl;
            }

            boat.stupidRender(objectPreshader, projectVP * boatModel);
            lighthouse.stupidRender(objectPreshader, projectVP * objectModel);
            landscape.stupidRender(objectPreshader, projectVP * landscapeModel);

            auto mvp = projectVP * objectModel;
            waterPreshader.use();
            waterPreshader.set_uniform("mvp", glm::value_ptr(mvp));
            glBindVertexArray(waterVAO);
            glDrawElements(GL_TRIANGLES, 12, GL_UNSIGNED_INT, nullptr);
            glBindVertexArray(0);

            glBindFramebuffer(GL_FRAMEBUFFER, 0);
        }

        auto lightProjection = glm::ortho(-100.0f, 100.0f, -100.0f, 100.0f, 1.0f, 800.0f);
        auto lightView = glm::lookAt(sunlight / sunlight.y * 50.0f,
                                   glm::vec3(0.0f, 0.0f,  0.0f),
                                   glm::vec3(0, 1, 0));

        auto lightVP = lightProjection * lightView;

        { // Shadow maps
            glViewport(0, 0, SHADOW_WIDTH, SHADOW_HEIGHT);
            glBindFramebuffer(GL_FRAMEBUFFER, depthMapFBO);
            glClear(GL_DEPTH_BUFFER_BIT);
            glEnable(GL_DEPTH_TEST);

            if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
                std::cout << "ERROR::FRAMEBUFFER:: Framebuffer is not complete!" << std::endl;
            }

            boat.stupidRender(objectPreshader, lightVP * boatModel);
            lighthouse.stupidRender(objectPreshader, lightVP * objectModel);
            landscape.stupidRender(objectPreshader, lightVP * landscapeModel);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
        }
        glViewport(0, 0, display_w, display_h);
        GLuint reflectionTexture;
        { // draw to reflect buffer
            glBindFramebuffer(GL_FRAMEBUFFER, reflectBuffer);

            unsigned int rbo;
            glGenRenderbuffers(1, &rbo);
            glBindRenderbuffer(GL_RENDERBUFFER, rbo);
            glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8, display_w, display_h);
            glBindRenderbuffer(GL_RENDERBUFFER, 0);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, rbo);

            initReflectTexture(reflectionTexture, display_w, display_h);
            glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
            glEnable(GL_DEPTH_TEST);

            auto newCameraPos = cameraPos;
            newCameraPos.y = -20.0 - (newCameraPos.y + 20.0);

            auto newRotationX = glm::rotate(glm::mat4(1.0), glm::radians(-x_rotation * 60), glm::vec3(1, 0, 0));
            auto newRotationY = glm::rotate(glm::mat4(1.0), glm::radians(y_rotation * 60), glm::vec3(0, 1, 0));
            auto newRotated = newCurrentRotation * newRotationX * newRotationY;
            newCurrentRotation = newRotated;

            auto newViewVector = glm::vec3(newRotated * glm::vec4(0, 0 , 1, 1));

            auto newView = glm::lookAt<float>(
                    newCameraPos,
                    newCameraPos + newViewVector,
                    glm::vec3( glm::vec4(0, -1 , 0, 1)));

            auto waterPlane = glm::vec4(0, -1, 0, -20);
            auto cameraSpaceWaterPlane = glm::inverse(glm::transpose(newView)) * waterPlane;
            if (cameraSpaceWaterPlane.w > 0) {
                cameraSpaceWaterPlane *= -1;
            }
            auto newProjection = projection;

            auto cPrime = glm::transpose(glm::inverse(newProjection)) * cameraSpaceWaterPlane;
            auto qPrime = glm::vec4(sign(cPrime.x), sign(cPrime.y), 1.0, 1.0);
            auto Q = glm::inverse(newProjection) * qPrime;
            newProjection = glm::transpose(newProjection);
            newProjection[2] = -2.0f * Q.z / glm::dot(Q, cameraSpaceWaterPlane) * cameraSpaceWaterPlane +
                    glm::vec4(0.0, 0.0, 1.0, 0.0);

            newProjection = glm::transpose(newProjection);

            if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
                std::cout << "ERROR::FRAMEBUFFER:: Framebuffer is not complete!" << std::endl;
            }

            boat.render(boatShader, boatModel, newProjection * newView * boatModel, sunlight,
                        sunlightAmbient, sunlightDiffuse, sunlightSpecular, boatAmbientStrength,
                        lightVP, depthTexture, projectVP, catTexture, lighthouseProjectionDepthMap);
            lighthouse.render(lighthouseShader, objectModel, newProjection * newView * objectModel, sunlight,
                              sunlightAmbient, sunlightDiffuse, sunlightSpecular, lighthouseAmbientStrength,
                              lightVP, depthTexture, projectVP, catTexture, lighthouseProjectionDepthMap);
            landscape.render(landscapeShader, landscapeModel, newProjection * newView, sunlight,
                             sunlightAmbient, sunlightDiffuse, sunlightSpecular, landscapeAmbientStrength,
                             lightVP, depthTexture, projectVP, catTexture, lighthouseProjectionDepthMap);
            auto newCubemapView = glm::mat4(glm::mat3(newView));
            auto newCubemapVP = newProjection * newCubemapView;

            glDepthFunc(GL_LEQUAL);

            cubemapShader.use();
            cubemapShader.set_uniform("vp", glm::value_ptr(newCubemapVP));
            glBindVertexArray(cubemapVAO);
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_CUBE_MAP, cubemapTexture);
            glDrawArrays(GL_TRIANGLES, 0, 36);
            glBindVertexArray(0);
            glDepthFunc(GL_LESS);

            glDeleteRenderbuffers(1, &rbo);
        }

        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        glClearColor(0.0f, 1.0f, 0.0f, 1.00f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        boat.render(boatShader, boatModel, boatMVP, sunlight,
                    sunlightAmbient, sunlightDiffuse, sunlightSpecular, boatAmbientStrength,
                    lightVP, depthTexture, projectVP, catTexture, lighthouseProjectionDepthMap);
        lighthouse.render(lighthouseShader, objectModel, objectMVP, sunlight,
                          sunlightAmbient, sunlightDiffuse, sunlightSpecular, lighthouseAmbientStrength,
                          lightVP, depthTexture, projectVP, catTexture, lighthouseProjectionDepthMap);
        landscape.render(landscapeShader, landscapeModel, objectVP, sunlight,
                         sunlightAmbient, sunlightDiffuse, sunlightSpecular, landscapeAmbientStrength,
                         lightVP, depthTexture, projectVP, catTexture, lighthouseProjectionDepthMap);

        glDepthFunc(GL_LEQUAL);
        waterShader.use();
        waterShader.set_uniform("cameraPos", cameraPos.x, cameraPos.y, cameraPos.z);
        waterShader.set_uniform("model", glm::value_ptr(objectModel));
        waterShader.set_uniform("vp", glm::value_ptr(objectVP));
        waterShader.set_uniform("reflection", 0);
        waterShader.set_uniform("dudv", 1);
        waterShader.set_uniform("sunVP", glm::value_ptr(lightVP));
        waterShader.set_uniform("shadowMap", 2);
        waterShader.set_uniform("time", (float) elapsedTime);
        waterShader.set_uniform("waterSpeed", waterSpeed);
        waterShader.set_uniform("tileSize", waterTileSize);
        waterShader.set_uniform("dudvStrength", dudvStrength);
        waterShader.set_uniform("projectVP", glm::value_ptr(projectVP));
        waterShader.set_uniform("projectorDepthMap", 3);
        waterShader.set_uniform("projectorTexture", 4);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, reflectionTexture);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, waterDuDv);
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, depthTexture);
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, lighthouseProjectionDepthMap);
        glActiveTexture(GL_TEXTURE4);
        glBindTexture(GL_TEXTURE_2D, catTexture);
        glBindVertexArray(waterVAO);
        glDrawElements(GL_TRIANGLES, 12, GL_UNSIGNED_INT, nullptr);
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

        glDeleteTextures(1, &reflectionTexture);
    }

    // Cleanup
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();

    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}
