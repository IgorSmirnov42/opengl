#version 330 core

in vec2 TexCoord;
in vec3 Normal;
in vec4 SunSpaceCoords;
in vec4 ProjectorSpaceCoords;

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
uniform sampler2D projectorTexture;
uniform sampler2D projectorDepthMap;

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

    vec4 color = ambient + (1 - shadow(SunSpaceCoords)) * diffuse;
    vec3 projectorSpacePos;
    if (abs(ProjectorSpaceCoords.w) > 1e-3)
    {
        projectorSpacePos = ProjectorSpaceCoords.xyz / ProjectorSpaceCoords.w * 0.5 + 0.5;
    }
    else
    {
       projectorSpacePos = vec3(0, 0, 0);
    }
    float projectorDepth = texture(projectorDepthMap, clamp(projectorSpacePos.xy, 0.001, 0.999)).r;
    float myDepth = projectorSpacePos.z;
    float us = (abs(myDepth - projectorDepth) < 0.001 &&
                clamp(projectorSpacePos.xy, 0.001, 0.999) == projectorSpacePos.xy &&
                length(projectorSpacePos.xy - vec2(0.5)) < 0.5 * 0.8) ? 0.0 : 1.0;
    vec4 projectorTex = vec4(texture(projectorTexture, clamp(projectorSpacePos.xy, 0.001, 0.999)).rgb, 1.0);

    gl_FragColor = color * us + (1 - us) * projectorTex;
}