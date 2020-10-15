#version 330 core

in vec4 Position;
in vec3 Normal;

uniform samplerCube cubemap;
uniform vec3 cameraPos;

void main()
{
    vec3 pos = Position.xyz / Position.w;
    vec3 I = normalize(pos - cameraPos);
    vec3 R = reflect(I, normalize(Normal));
    gl_FragColor = vec4(texture(cubemap, R).rgb, 1.0);
}