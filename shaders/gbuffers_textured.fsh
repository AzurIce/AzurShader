#version 460 compatibility

uniform sampler2D texture;
uniform sampler2D lightmap;

in vec4 color;
in vec4 texcoord;
in vec4 lmcoord;

/* DRAWBUFFERS:0 */

void main() {
    vec4 tex = texture2D(texture, texcoord.st);
    vec4 lit = texture2D(lightmap, lmcoord.st);

    gl_FragData[0] = tex * lit * color;
	// gl_FragData[1] = vec4(0.0, 0.0, (1.0 / 255.0), albedo.a);
}