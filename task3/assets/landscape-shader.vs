#version 330 core

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec3 in_normal;

out vec3 Position;
out vec3 Normal;

uniform mat4 model;
uniform mat4 vp;

void main()
{
    Normal = mat3(transpose(inverse(model))) * in_normal;
    Position = in_position;
    gl_Position = vp * model * vec4(in_position, 1.0);
}