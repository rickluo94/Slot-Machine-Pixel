shader_type canvas_item;

/* ================= 設定 ================= */

// 故障（glitch）效果發生的機率
uniform float glitch_chance : hint_range(0.0, 1.0) = 1;

// 故障狀態切換的速度
uniform float glitch_speed = 7.0;

// 水平切片的數量
uniform float slice_density = 14.0;

// 切片水平位移的強度
uniform float slice_strength = 0.38;

// 整體畫面抖動強度
uniform float shake_strength = 0.02;

// 色差分離（RGB 偏移）強度
uniform float chroma_offset = 0.1;

// 數位雜訊強度
uniform float noise_strength = 0.2;

// 顏色閃爍強度
uniform float color_flash_strength = 0.4;

// 掃描線掉落效果強度
uniform float scanline_strength = 0.18;

// 區域性扭曲變形強度
uniform float local_warp_strength = 0.14;

// 切片水平翻轉的機率
uniform float flip_chance : hint_range(0.0,1.0) = 0;

/* ================= RANDOM FUNCTIONS ================= */

float rand(float x) { 
	return fract(sin(x * 143758.5453) * 43758.5453); 
}

float rand2(vec2 p) { 
	return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453); 
}

/* ================= FRAGMENT SHADER ================= */

void fragment() {
	vec2 uv = UV;

	// Determine if glitch should happen this frame
	float glitch = step(1.0 - glitch_chance, rand(floor(TIME * glitch_speed)));

	/* ----- SLICES EFFECT ----- */
	float slice_id = floor(uv.y * slice_density + rand(floor(TIME)));
	float slice_rand = rand(slice_id + floor(TIME * glitch_speed));
	float slice_mask = step(0.5, slice_rand) * glitch;

	// Randomly flip some slices horizontally
	if(rand(slice_id * TIME) < flip_chance) {
		uv.x = 1.0 - uv.x;
	}

	// Apply horizontal displacement for this slice
	uv.x += (slice_rand - 0.5) * slice_strength * slice_mask;

	/* ----- MICRO JITTER ----- */
	// Small random jitters to add chaos
	float jitter = step(0.85, rand(TIME * 12.0)) * glitch;
	uv.x += (rand(TIME * 3.0) - 0.5) * 0.08 * jitter;

	/* ----- LOCAL WARP ----- */
	// Random local distortion in some slices
	float warp_zone = step(0.65, rand2(vec2(slice_id, TIME)));
	uv += (vec2(rand2(uv + TIME), rand2(uv - TIME)) - 0.5) * local_warp_strength * warp_zone * glitch;

	/* ----- GLOBAL SHAKE ----- */
	uv += vec2(
		rand(TIME * 1.3) - 0.5,
		rand(TIME * 1.7) - 0.5
	) * shake_strength * glitch;

	/* ----- COLOR SPLIT ----- */
	vec4 base = texture(TEXTURE, uv);
	float r = texture(TEXTURE, uv + vec2(chroma_offset * glitch, 0.0)).r;
	float b = texture(TEXTURE, uv - vec2(chroma_offset * glitch, 0.0)).b;
	vec3 color = vec3(r, base.g, b);

	/* ----- DIGITAL NOISE ----- */
	color += (rand2(uv * TIME * 1.5) - 0.5) * noise_strength * glitch;

	/* ----- SCANLINE DROP ----- */
	float scan = step(0.9, rand(uv.y * 100.0 + TIME * 10.0));
	color *= 1.0 - scan * scanline_strength * glitch;

	/* ----- COLOR FLASH ----- */
	vec3 flash_color = vec3(
		step(0.5, rand(TIME + 0.1)),
		step(0.5, rand(TIME + 3.1)),
		step(0.5, rand(TIME + 6.1))
	);
	color = mix(color, flash_color, rand(TIME * 4.0) * color_flash_strength * glitch);

	COLOR = vec4(color, base.a);
}