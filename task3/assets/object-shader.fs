#version 330 core

in vec3 Position;
in vec3 Normal;
uniform samplerCube cubemap;
uniform float cf;
uniform vec3 cameraPos;

void main()
{
    float ratio = 1.00 / cf;
    vec3 N = normalize(Normal);
    vec3 I = normalize(Position - cameraPos);
    vec3 R = refract(I, N, ratio);
    vec3 t = reflect(I, N);
    float theta_i = abs(dot(I, N));
    float theta_t = abs(dot(-N, R));
    vec4 res_r = texture(cubemap, R);
    vec4 res_t = texture(cubemap, t);
    float eta1 = 1.0;
    float eta2 = cf;
    float r_perp_sqrt = (eta1 * theta_i - eta2 * theta_t) / (eta1 * theta_i + eta2 * theta_t);
    float r_parr_sqrt = (eta2 * theta_i - eta1 * theta_t) / (eta2 * theta_i + eta1 * theta_t);
    float r_perp = r_perp_sqrt * r_perp_sqrt;
    float r_parr = r_parr_sqrt * r_parr_sqrt;
    float cfr = (r_perp + r_parr) / 2;
    gl_FragColor = vec4(res_r.rgb * (1 - cfr) + res_t.rgb * cfr, 1.0);
}