#version 330 core

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec2 in_particle_center;
layout (location = 2) in float in_distance;
layout (location = 3) in float in_intensity;

out vec2 Position;
out vec2 ParticleCenter;
out float Distance;
out float Intensity;

uniform float border;

void main()
{
    Position = in_position.xy;
    ParticleCenter = in_particle_center / border;
    Distance = in_distance / border;
    Intensity = in_intensity;
    gl_Position = vec4(in_position, 1.0);
}