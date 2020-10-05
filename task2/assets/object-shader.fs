#version 330 core

in vec3 Position;
in vec3 Normal;
uniform samplerCube cubemap;
uniform float cf;
uniform vec3 cameraPos;

void main()
{
    float ratio = 1.00 / cf;
    vec3 I = normalize(Position - cameraPos);
    vec3 R = refract(I, normalize(Normal), ratio);
    gl_FragColor = vec4(texture(cubemap, R).rgb, 1.0);
}