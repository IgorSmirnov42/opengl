#version 330 core

layout (location = 0) in vec4 in_position;

out vec4 Position;
out vec4 ClipCoords;

uniform mat4 model;
uniform mat4 vp;

void main()
{
    Position = model * in_position;
    ClipCoords = vp * model * in_position;

    gl_Position = ClipCoords;
}