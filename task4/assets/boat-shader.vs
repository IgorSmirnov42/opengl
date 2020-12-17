#version 330 core

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec3 in_normal;
layout (location = 2) in vec2 in_texcoord;

out vec2 TexCoord;
out vec3 Normal;

uniform mat4 sunVP;
uniform mat4 model;
uniform mat4 mvp;

void main()
{
    Normal = normalize(mat3(transpose(inverse(model))) * in_normal);
    TexCoord = in_texcoord;
    gl_Position = mvp * vec4(in_position, 1.0);
}