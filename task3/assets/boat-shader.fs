#version 330 core

in vec2 TexCoord;
in vec3 Normal;
in vec4 SunSpaceCoords;

struct Light {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform float ambientStrength;
uniform Light light;
uniform sampler2D tex;
uniform vec3 sunlight;
uniform sampler2D shadowMap;

float shadow(vec4 coords)
{
    vec3 position = coords.xyz / coords.w * 0.5 + 0.5;
    float dep = texture(shadowMap, position.xy).r;
    float sh = (position.z - 0.005) > dep ? 1.0 : 0.0;
    return sh;
}

void main()
{
    vec4 col = vec4(texture(tex, TexCoord).rgb, 1.0);

    vec4 ambient = vec4(light.ambient, 1.0) * (ambientStrength * col);
    float diff = max(dot(Normal, normalize(sunlight)), 0.0);
    vec4 diffuse = vec4(light.diffuse, 1.0) * (diff * col);

    gl_FragColor = ambient + (1 - shadow(SunSpaceCoords)) * diffuse;
}