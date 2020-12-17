#version 330 core

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec3 in_normal;

out vec3 Position;
out vec3 Normal;
out vec4 SunSpaceCoords;
out vec4 ProjectorSpaceCoords;

uniform mat4 model;
uniform mat4 vp;
uniform mat4 sunVP;
uniform mat4 projectVP;

void main()
{
    Normal = normalize(mat3(transpose(inverse(model))) * in_normal);
    Position = vec3(model * vec4(in_position, 1.0));
    ProjectorSpaceCoords = projectVP * model * vec4(in_position, 1.0);
    SunSpaceCoords = sunVP * model * vec4(in_position, 1.0);
    gl_Position = vp * model * vec4(in_position, 1.0);
}