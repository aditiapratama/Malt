//Copyright (c) 2020 BlenderNPR and contributors. MIT license.

#ifndef BLUR_GLSL
#define BLUR_GLSL

vec4 box_blur(sampler2D input_texture, vec2 uv, float radius, bool circular)
{
    vec2 resolution = textureSize(input_texture, 0);

    vec4 result = vec4(0);
    float total_weight = 0.0;

    for(float x = -radius; x <= radius; x++)
    {
        for(float y = -radius; y <= radius; y++)
        {
            vec2 offset = vec2(x,y);
            if(!circular || length(offset) <= radius)
            {
                result += texture(input_texture, uv + offset / resolution);
                total_weight += 1.0;
            }
        }   
    }

    return result / total_weight;
}

float gaussian_weight(float x, float sigma)
{
    float sigma2 = sigma * sigma;

    return (1.0 / sqrt(2*PI*sigma2)) * exp(-(x*x, 2.0*sigma2));
}

float gaussian_weight_2d(vec2 v, float sigma)
{
    float sigma2 = sigma * sigma;

    return (1.0 / (2*PI*sigma2)) * exp(-(dot(v,v) / (2.0*sigma2)));
}

vec4 gaussian_blur(sampler2D input_texture, vec2 uv, float radius, float sigma)
{
    vec2 resolution = textureSize(input_texture, 0);

    vec4 result = vec4(0);
    float total_weight = 0.0;

    for(float x = -radius; x <= radius; x++)
    {
        for(float y = -radius; y <= radius; y++)
        {
            vec2 offset = vec2(x,y);
            float weight = gaussian_weight_2d(offset, sigma);
            result += texture(input_texture, uv + offset / resolution) * weight;
            total_weight += weight;
        }   
    }

    return result / total_weight;
}


#endif //BLUR_GLSL

