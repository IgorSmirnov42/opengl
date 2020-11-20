#version 330 core

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec3 in_normal;
layout (location = 2) in vec2 in_texcoord;

out vec2 TexCoord;
out vec3 Normal;
out vec4 SunSpaceCoords;

uniform mat4 model;
uniform mat4 mvp;
uniform mat4 sunVP;

void main()
{
    Normal = normalize(mat3(transpose(inverse(model))) * in_normal);
    TexCoord = in_texcoord;
    SunSpaceCoords = sunVP * model * vec4(in_position, 1.0);
    gl_Position = mvp * vec4(in_position, 1.0);
}