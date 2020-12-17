#version 330 core

in vec2 TexCoord;
in vec3 Normal;
uniform sampler2D tex;

void main()
{
    vec4 col = vec4(texture(tex, TexCoord).rgb, 1.0);

    gl_FragColor = col;
}