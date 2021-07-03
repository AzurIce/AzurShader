#version 460 compatibility

const int noiseTextureResolution = 512;
uniform sampler2D noisetex;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform int worldTime;

out vec4 color;
out vec4 texcoord;
out vec4 lmcoord;

attribute vec3 mc_Entity;

out float blockId;

out float cosine;

/*
 * @function addBump    : Add bumping effect
 * @inout vertex
*/
void addBump(inout vec4 vertex) {
    vertex.y += sin(worldTime*0.3 +( vertex.z + cameraPosition.z) * 2) * 0.05;
}

const float speedFactor = 1;
vec4 addWave(inout vec4 posInMCCoord) {
    float speed1 = (float(worldTime) / (noiseTextureResolution * 15)) * speedFactor;
    vec4 coord = posInMCCoord / noiseTextureResolution;
    coord.x += speed1 * 1;
    coord.z += speed1 * 0.5;
    float noise1 = texture2D(noisetex, coord.xz).x;

    float speed2 = (float(worldTime) / (noiseTextureResolution * 7)) * speedFactor;
    vec4 coord2 = posInMCCoord / noiseTextureResolution;
    coord2.x -= speed2 * 0.15 + noise1 * 0.05;
    coord2.z -= speed2 * 0.7 + noise1 * 0.05;
    float noise2 = texture2D(noisetex, coord.xz).x;

    posInMCCoord.y += clamp(sin(noise2-0.5), -1, 1) * 0.1;
    return vec4(noise2 * 2);
    // vertex.y += sin(worldTime*0.3 +( vertex.z + cameraPosition.z) * 2) * 0.05;
}

bool isEqual (float x, int y){
    return y-0.5 < x && x < y+0.5;
}

void main() {
	color = gl_Color;
    texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;

    blockId = mc_Entity.x;

    vec4 posInViewCoord = gl_ModelViewMatrix * gl_Vertex;
    vec3 normalInViewCoord = gl_NormalMatrix * gl_Normal;
    cosine = clamp(abs(dot(normalize(posInViewCoord.xyz), normalize(normalInViewCoord))), 0, 1);

    vec4 posInMCCoord = gbufferModelViewInverse * posInViewCoord + vec4(cameraPosition, 1);

    if(isEqual(blockId, 8)) {
        color = color * 0.8 + addWave(posInMCCoord) * 0.2;
    }

    vec4 position = gbufferProjection * gbufferModelView * (posInMCCoord - vec4(cameraPosition, 1));
    gl_Position = position;
}