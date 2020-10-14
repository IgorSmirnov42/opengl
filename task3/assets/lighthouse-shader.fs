#version 330 core

in vec2 TexCoord;
uniform sampler2D tex;

void main()
{
    gl_FragColor = vec4(texture(tex, TexCoord).rgb, 1.0);
}