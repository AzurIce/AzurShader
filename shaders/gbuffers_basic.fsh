#version 460 compatibility

// const int noiseTextureResolution = 256;

in vec4 color;

/* DRAWBUFFERS:0 */

void main() {
    gl_FragData[0] = color;
}