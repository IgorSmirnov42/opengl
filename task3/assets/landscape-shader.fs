#version 330 core

in vec3 Position;
in vec3 Normal;

uniform sampler2D lowTexture;
uniform sampler2D middleTexture;
uniform sampler2D highTexture;
uniform vec3 heights;

void main()
{
    float textureRepeat = 20.0;
    float height = Position.y;
    vec2 newTexCoords = vec2(Position.x + height, Position.z + height);
    vec2 texCoords = (newTexCoords - int(newTexCoords / textureRepeat) * textureRepeat) / textureRepeat;
    vec4 lowColor = vec4(texture(lowTexture, texCoords).rgb, 1.0);
    vec4 middleColor = vec4(texture(middleTexture, texCoords).rgb, 1.0);
    vec4 highColor = vec4(texture(highTexture, texCoords).rgb, 1.0);
    float alphaA = min((height - heights.x) / (heights.y - heights.x), 1);
    float alphaB = max((height - heights.y) / (heights.z - heights.y), 0);
    vec4 result = mix(mix(lowColor, middleColor, alphaA), highColor, alphaB);
    gl_FragColor = result;
}