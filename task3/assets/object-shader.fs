#version 330 core

in vec2 TexCoord;
uniform sampler2D boatTexture;

void main()
{
    gl_FragColor = vec4(texture(boatTexture, TexCoord).rgb, 1.0);
}