#version 330 core

layout (location = 0) in vec4 in_position;

out vec4 Position;
out vec4 ClipCoords;
out vec4 SunSpaceCoords;
out vec4 ProjectorSpaceCoords;

uniform mat4 model;
uniform mat4 vp;
uniform mat4 sunVP;
uniform mat4 projectVP;

void main()
{
    Position = model * in_position;
    ClipCoords = vp * model * in_position;
    SunSpaceCoords = sunVP * model * in_position;
    ProjectorSpaceCoords = projectVP * model * in_position;
    gl_Position = ClipCoords;
}