#version 330 core

in vec4 Position;
in vec4 ClipCoords;
in vec4 SunSpaceCoords;

uniform sampler2D reflection;
uniform sampler2D shadowMap;
uniform vec3 cameraPos;
uniform sampler2D dudv;
uniform float time;
uniform float waterSpeed;
uniform float tileSize;
uniform float dudvStrength;

float shadow(vec4 coords)
{
    vec3 position = coords.xyz / coords.w * 0.5 + 0.5;
    float dep = texture(shadowMap, clamp(position.xy, 0.001, 0.999)).r;
    float sh = (position.z - 0.005) > dep ? 0.5 : 0.0;
    return sh;
}

void main()
{
    vec3 pos = Position.xyz / Position.w;
    vec2 bumpMapTexcoords = pos.xz / tileSize + vec2(time, -time) * waterSpeed;
    bumpMapTexcoords = mod(mod(bumpMapTexcoords, 1.0) + 1.0, 1.0);
    vec2 bumpMap = (texture(dudv, bumpMapTexcoords).rg * 2.0 - 1.0) * dudvStrength;
    vec3 I = normalize(pos - cameraPos);
    vec2 texCoords = ClipCoords.xy / ClipCoords.w / 2 + 0.5;
    texCoords.x *= -1;
    texCoords = mod(mod(texCoords, 1.0) + 1.0, 1.0);
    texCoords += bumpMap;
    texCoords = clamp(texCoords, 0.001, 0.999);
    //gl_FragColor = vec4(dep, dep, dep, 1.0);
    vec4 waterColor = vec4(texture(reflection, texCoords).rgb, 1.0);
    gl_FragColor = waterColor;
}