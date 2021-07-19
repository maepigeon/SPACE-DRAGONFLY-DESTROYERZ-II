shader_type canvas_item;

uniform sampler2D noise_img;
uniform float speed = 0.2;
uniform float aspect_ratio = 0.5625;
uniform vec3 cloud_color = vec3(0.6, 0.7, 1.0);

void fragment() {
	vec2 uv = vec2(UV.x, UV.y * aspect_ratio - TIME * speed);
	float noise_r = cloud_color.r * texture(noise_img, uv).r;
	float noise_g = cloud_color.g * texture(noise_img, uv).g;
	float noise_b = cloud_color.b * texture(noise_img, uv).b;
	
	vec3 color = vec3(noise_r, noise_g, noise_b);
	float new_alpha = noise_r * noise_g * noise_b;
	
	COLOR.rgb = color;
	COLOR.a = (COLOR.r + COLOR.g + COLOR.b)/3.0;
	COLOR.a = COLOR.a * COLOR.a;
}