#version 330 core

layout (location = 0) in vec3 in_position;
out vec3 TexCoords;
uniform mat4 vp;

void main()
{
    TexCoords = in_position;
    vec4 pos = vp * vec4(in_position, 1.0);
    gl_Position = pos.xyww;
}
