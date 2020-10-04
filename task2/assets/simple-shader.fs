#version 330 core

out vec4 o_frag_color;

uniform vec2 a;
uniform vec2 b;
uniform int ITERATIONS;
uniform float INF;
uniform sampler1D tex;

void main()
{
    float total_width = b.x - a.x;
    float total_height = b.y - a.y;
    float c_x = a.x + (gl_PointCoord.x + 1) / 2 * total_width;
    float c_y = b.y - (gl_PointCoord.y + 1) / 2 * total_height;
    float z_x = c_x;
    float z_y = c_y;
    int out_iteration = ITERATIONS;

    for (int i=0; i<ITERATIONS; ++i) {
        z_x = abs(z_x);
        z_y = abs(z_y);
        float nz_x = -z_y * z_y + z_x * z_x + c_x;
        float nz_y = 2 *  z_y * z_x + c_y;
        z_x = nz_x;
        z_y = nz_y;
        if (z_x * z_x + z_y * z_y > INF) {
            out_iteration = i;
            break;
        }
    }

    o_frag_color = texture(tex, 3.0 * out_iteration / ITERATIONS).rgba;
}