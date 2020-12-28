#version 330 core

layout(location = 0) out vec3 color;

in vec2 Position;
in vec2 ParticleCenter;
in float Distance;
in float Intensity;

uniform float eps;

void main()
{
    float dist = distance(Position, ParticleCenter);

    if (abs(dist - Distance) > eps)
        discard;

    float dst = ((Distance - dist) / eps + 1) / 2 * 3.14159265389;
    float intens = sin(dst) * Intensity;

    color = vec3(intens, intens, intens);
    gl_FragDepth = -intens;
}