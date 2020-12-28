#version 330 core

in vec4 Position;
in vec4 ClipCoords;

uniform samplerCube cubeMap;
uniform vec3 cameraPos;
uniform sampler2D wavesTexture;
uniform int pomSteps;
uniform float waveHeight;
uniform bool pomOn;
uniform bool pomOpt;

float getHeight(vec2 coords) {
    return texture(wavesTexture, clamp(coords, 0.001, 0.999)).r * waveHeight;
}

vec3 normalMap(vec2 texCoords) {
    float d = 1.0f / (150 * 2);
    vec3 c0;
    c0.x = getHeight(texCoords + vec2(-d, -d));
    c0.y = getHeight(texCoords + vec2(0, -d));
    c0.z = getHeight(texCoords + vec2(d, -d));
    vec3 c1;
    c1.x = getHeight(texCoords + vec2(-d, 0));
    c1.y = getHeight(texCoords + vec2(0, 0));
    c1.z = getHeight(texCoords + vec2(d, 0));
    vec3 c2;
    c2.x = getHeight(texCoords + vec2(-d, d));
    c2.y = getHeight(texCoords + vec2(0, d));
    c2.z = getHeight(texCoords + vec2(d, d));

    float x = c0.x - c0.z + 2 * c1.x - 2 * c1.z + c2.x - c2.z;
    float y = c0.x + 2 * c0.y + c0.z - c2.x - 2 * c2.y - c2.z;
    float z = sqrt(1 - (x * x + y * y));
    return normalize(vec3(x, z, y));
}

vec2 xyToUV(vec2 xy) {
    return clamp((xy + vec2(150, 150)) / 300, 0.001, 0.999);
}

vec2 pom(vec2 initXY, vec3 I) {
    vec2 curXY = initXY;
    float curHeight = 0;
    float realHeight = getHeight(xyToUV(curXY));
    float heightDelta = waveHeight / pomSteps;
    vec2 stepDelta = heightDelta / I.y * I.xz;
    for (int step_i = 0; step_i < pomSteps; ++step_i) {
        if (curHeight < realHeight) {
            curHeight += heightDelta;
            curXY += stepDelta;
            realHeight = getHeight(xyToUV(curXY));
        }
    }
    vec2 xy;
    if (pomOpt) {
        vec2 prevXY = curXY - stepDelta;
        float prevHeight = curHeight - heightDelta;
        float prevRealHeight = getHeight(xyToUV(prevXY));
        float x = (prevHeight - prevRealHeight) / (realHeight - prevRealHeight - curHeight + prevHeight);
        if (x > 1 || x < 0) x = 0.5;
        xy = (1 - x) * curXY + x * prevXY;
    }
    else {
        xy = curXY;
    }
    return xyToUV(xy);
}

void main()
{
    vec3 pos = Position.xyz / Position.w;
    vec3 I = normalize(pos - cameraPos);
    vec2 normalUV;
    if (pomOn) {
        normalUV = pom(pos.xz, -I);
    }
    else {
        normalUV = xyToUV(pos.xz);
    }
    vec3 normal = normalMap(normalUV);
    vec3 t = reflect(I, normal);
    vec4 waterColor = vec4(texture(cubeMap, t).rgb, 1.0);
    gl_FragColor = waterColor;
}