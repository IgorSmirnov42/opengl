#version 330 core

in vec3 TexCoords;
uniform samplerCube cubemap;

void main()
{
    gl_FragColor = texture(cubemap, TexCoords);
}
