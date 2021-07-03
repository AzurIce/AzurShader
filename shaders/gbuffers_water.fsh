#version 460 compatibility

const int noiseTextureResolution = 512;

uniform sampler2D texture;
uniform sampler2D lightmap;

in vec4 color;
in vec4 texcoord;
in vec4 lmcoord;

in float blockId;

in float cosine;

/* DRAWBUFFERS:0 */

bool isEqual (float x, int y){
    return y-0.5 < x && x < y+0.5;
}

void main() {
    float factor = pow(1 - cosine, 4);

    vec4 tex = texture2D(texture, texcoord.st);
    vec4 lit = texture2D(lightmap, lmcoord.st);
    if (isEqual(blockId, 8)) {
        gl_FragData[0] = lit * (vec4(mix(color.xyz * 0.3, color.xyz, factor), 0.75) * 0.8 + tex * 0.2 );
    } else {
        gl_FragData[0] = tex * lit * color;
    }

    // gl_FragData[0] = color;
    
}