shader_type canvas_item;
render_mode unshaded;

uniform float title_sway : hint_range(0.0, 2.0, 0.05) = 1.0;
uniform bool petals_enabled = true;
uniform float vegetation_sway : hint_range(0.0, 2.0, 0.05) = 1.0;
// -1 为正常播放；非负值供编辑器定格查看。
uniform float preview_time = -1.0;

float seeded(float value) {
    return fract(sin(value * 71.23 + 14.17) * 13758.73);
}

// 花草根部保持不动，越靠近顶端越容易随风摆；边界柔和回到原画面。
float plant_tip(vec2 uv, vec4 bounds) {
    float across = smoothstep(bounds.x, bounds.x + 0.014, uv.x)
        * (1.0 - smoothstep(bounds.z - 0.014, bounds.z, uv.x));
    float within = smoothstep(bounds.y, bounds.y + 0.014, uv.y)
        * (1.0 - smoothstep(bounds.w - 0.014, bounds.w, uv.y));
    return across * within * (1.0 - smoothstep(bounds.y, bounds.w, uv.y));
}

// 四片原花瓣的带边距取样区域；顺序为上方、右侧、中间、下方。
vec4 original_petal_rect(int index) {
    vec4 pixels = vec4(861.0, 137.0, 46.0, 47.0);
    if (index == 1) {
        pixels = vec4(1090.0, 307.0, 47.0, 52.0);
    } else if (index == 2) {
        pixels = vec4(756.0, 403.0, 49.0, 49.0);
    } else if (index == 3) {
        pixels = vec4(636.0, 530.0, 46.0, 45.0);
    }
    return pixels / vec4(1448.0, 1086.0, 1448.0, 1086.0);
}

// 在片元里直接取样，避免将 Godot 内置 TEXTURE 跨自定义函数传递导致部分渲染器报错。
// 宏只展开取样表达式；保留当地天空的低频色彩，配合邻近纸纹覆盖浅色描边。
#define SOFT_SKY(coord) (texture(TEXTURE, (coord)).rgb * 0.4 + texture(TEXTURE, (coord) + vec2(6.0 / 1448.0, 0.0)).rgb * 0.15 + texture(TEXTURE, (coord) - vec2(6.0 / 1448.0, 0.0)).rgb * 0.15 + texture(TEXTURE, (coord) + vec2(0.0, 6.0 / 1086.0)).rgb * 0.15 + texture(TEXTURE, (coord) - vec2(0.0, 6.0 / 1086.0)).rgb * 0.15)

void fragment() {
    float seconds = preview_time < 0.0 ? TIME : preview_time;
    float title_area = smoothstep(0.015, 0.045, UV.x)
        * (1.0 - smoothstep(0.595, 0.635, UV.x))
        * smoothstep(0.100, 0.135, UV.y)
        * (1.0 - smoothstep(0.330, 0.365, UV.y));
    vec2 pivot = vec2(0.318, 0.235);
    vec2 relative = (UV - pivot) * vec2(1.0, 0.75);
    float angle = sin(seconds * 0.83) * 0.0045 * title_sway;
    vec2 rotated = vec2(
        cos(angle) * relative.x - sin(angle) * relative.y,
        sin(angle) * relative.x + cos(angle) * relative.y
    ) / vec2(1.0, 0.75) + pivot;
    rotated.y += sin(seconds * 1.05 + UV.x * 6.0) * 0.0030 * title_sway;
    vec2 cover_uv = mix(UV, rotated, title_area);

    // 动作留在前景草尖和三处花朵周围，不拉动上方动物。前景底边同样固定。
    float front_grass = smoothstep(0.845, 0.900, UV.y)
        * (1.0 - smoothstep(0.975, 1.0, UV.y));
    vec3 ground_color = texture(TEXTURE, UV).rgb;
    front_grass *= smoothstep(-0.015, 0.045, ground_color.g - ground_color.r);
    float flower_left = plant_tip(UV, vec4(0.020, 0.835, 0.122, 0.965));
    float flower_middle = plant_tip(UV, vec4(0.340, 0.715, 0.405, 0.848));
    float flower_right = plant_tip(UV, vec4(0.930, 0.710, 0.998, 0.850));
    float plant_area = max(front_grass * 0.72, max(flower_left, max(flower_middle, flower_right)));
    float breeze = sin(seconds * 0.88 + UV.x * 4.0) * 0.78
        + sin(seconds * 1.31 + UV.x * 6.0) * 0.22;
    cover_uv.x += breeze * plant_area * vegetation_sway * (2.2 / 768.0);
    vec4 painted = texture(TEXTURE, cover_uv);

    if (petals_enabled) {
        // 原 PNG 不改动；只补四片原花瓣的局部天空。
        for (int index = 0; index < 4; index++) {
            vec4 source_rect = original_petal_rect(index);
            vec2 padding = vec2(12.0 / 1448.0, 12.0 / 1086.0);
            vec2 low = source_rect.xy - padding;
            vec2 high = source_rect.xy + source_rect.zw + padding;
            if (cover_uv.x > low.x && cover_uv.x < high.x && cover_uv.y > low.y && cover_uv.y < high.y) {
                vec2 unit = (cover_uv - low) / (high - low);
                vec3 left = SOFT_SKY(vec2(low.x, cover_uv.y));
                vec3 right = SOFT_SKY(vec2(high.x, cover_uv.y));
                vec3 top = SOFT_SKY(vec2(cover_uv.x, low.y));
                vec3 bottom = SOFT_SKY(vec2(cover_uv.x, high.y));
                vec3 corners_top = mix(SOFT_SKY(low),
                    SOFT_SKY(vec2(high.x, low.y)), unit.x);
                vec3 corners_bottom = mix(SOFT_SKY(vec2(low.x, high.y)),
                    SOFT_SKY(high), unit.x);
                vec3 sky = mix(left, right, unit.x) + mix(top, bottom, unit.y)
                    - mix(corners_top, corners_bottom, unit.y);
                vec2 grain_uv = cover_uv + (index < 2 ? vec2(0.0, 0.08) : vec2(-0.08, -0.01));
                sky += (texture(TEXTURE, grain_uv).rgb - SOFT_SKY(grain_uv)) * 0.8;
                float edge = 1.0 - smoothstep(0.68, 0.98,
                    max(abs(unit.x - 0.5), abs(unit.y - 0.5)) * 2.0);
                painted.rgb = mix(painted.rgb, sky, edge);
            }
        }
        // 七个等间隔位置使用同一周期，持续错开补充，避免原花瓣集中落完后出现长空档。
        for (int i = 0; i < 7; i++) {
            float index = float(i);
            float seed = seeded(index + 1.0);
            vec4 source = original_petal_rect(i % 4);
            float age = fract(seconds / 26.0 + index / 7.0 + 0.19);
            float vertical = -0.07 + age * 1.18;
            float horizontal = 0.57 + seed * 0.40 - age * (0.17 + seed * 0.10)
                + sin(seconds * 0.57 + seed * 8.0) * 0.018;
            // 取样框大小只影响取样，不决定显示尺寸；所有花瓣使用相同的 20×21 基准。
            vec2 petal_size = vec2(20.0 / 768.0, 21.0 / 576.0);
            vec2 local = (UV - vec2(horizontal, vertical)) / petal_size;
            float roll = sin(seconds * 0.66 + seed * 7.0) * 0.25;
            vec2 turned = vec2(
                cos(roll) * local.x - sin(roll) * local.y,
                sin(roll) * local.x + cos(roll) * local.y
            );
            turned.x /= 0.94 + cos(seconds * 0.81 + seed * 4.0) * 0.06;
            vec2 stamp_uv = turned + vec2(0.5);
            if (stamp_uv.x >= 0.0 && stamp_uv.x <= 1.0
                    && stamp_uv.y >= 0.0 && stamp_uv.y <= 1.0) {
                vec4 stamp = texture(TEXTURE, source.xy + stamp_uv * source.zw);
                float pink = smoothstep(0.01, 0.060, stamp.r - stamp.g)
                    * smoothstep(0.005, 0.055, stamp.r - stamp.b);
                float fade = smoothstep(0.01, 0.06, age)
                    * (1.0 - smoothstep(0.89, 0.99, age));
                painted.rgb = mix(painted.rgb, stamp.rgb, pink * fade);
            }
        }
    }
    COLOR = painted;
}
