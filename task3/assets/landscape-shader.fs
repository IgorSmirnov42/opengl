#version 330 core

in vec3 Position;
in vec3 Normal;

uniform sampler2D lowTexture;
uniform sampler2D middleTexture;
uniform sampler2D highTexture;
uniform vec3 heights;
uniform float totalLength;

void main()
{
    float textureRepeat = 20.0;
    vec2 texCoords = (Position.xz - int(Position.xz / textureRepeat) * textureRepeat) / textureRepeat;
    float height = Position.y;
    vec4 lowColor = vec4(texture(lowTexture, texCoords).rgb, 1.0);
    vec4 middleColor = vec4(texture(middleTexture, texCoords).rgb, 1.0);
    vec4 highColor = vec4(texture(highTexture, texCoords).rgb, 1.0);
    vec4 result;
    if (height <= heights.y) {
        result = mix(lowColor, middleColor, (height - heights.x) / (heights.y - heights.x));
    }
    else {
        result = mix(middleColor, highColor, (height - heights.y) / (heights.z - heights.y));
    }
    gl_FragColor = vec4(vec3(result), 1.0);
}