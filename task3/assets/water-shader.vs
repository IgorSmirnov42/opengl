#version 330 core

layout (location = 0) in vec4 in_position;

out vec3 Normal;
out vec4 Position;

uniform mat4 model;
uniform mat4 vp;

void main()
{
    vec3 in_normal = vec3(0, 1, 0);
    Normal = mat3(transpose(inverse(model))) * in_normal;
    Position = model * in_position;
    gl_Position = vp * model * in_position;
}