"""按主角乌鸦脚部的 4 帧规律，给叠片动物生成走路帧，输出到 sprites/stacked/walk/。
每帧是一整张和原图格式相同的叠片图，美术可以直接打开修改。

帧序：0 = A 腿在前、B 腿在后；1 = 两腿并拢；2 = 与 0 相反；3 = 两腿并拢。
两条腿的动物按左右分 A/B，四条腿的按对角分（左前+右后、右前+左后）。
画面中“上”(-y) 是动物的正前方。

用法（仓库根目录）：python3 tools/gen_walk.py
"""
from PIL import Image
from collections import Counter
import os

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
OUT = os.path.join(ROOT, 'sprites/stacked/walk')
ANIMALS = {
    # 名称: (图片, 层数, 腿的最高层, 步幅, 分组方式, 第 0 层是否为影子, 细腿是否加宽)
    'chicken': ('sprites/stacked/WhiteChicken.png', 14, 3, 2, 'biped', False, True),
    'dodo':    ('sprites/player/Dodo.png', 16, 3, 3, 'biped', False, False),
    'ostrich': ('sprites/stacked/Ostrich.png', 22, 6, 3, 'biped', False, False),
    'sheep':   ('sprites/stacked/Sheep.png', 12, 3, 1, 'quad', True, False),
}
# 每帧 (A 腿脚的位移, B 腿脚的位移)，负数是往前。
# 不抬脚：抬脚会让脚离开地面那一层，斜着看像腿断开了。迈步的起伏交给游戏里身体上下 1 像素。
def pattern(s):
    return [(-s, s), (0, 0), (s, -s), (0, 0)]

def split_layers(im, n):
    w = im.width // n
    return [im.crop((i * w, 0, i * w + w, im.height)) for i in range(n)], w

def leg_group(x, y, w, h, mode):
    cx = w / 2
    if mode == 'biped':
        return 'A' if x < cx else 'B'
    # 四足：对角成组（左前+右后 = A，右前+左后 = B）；前腿在上半部
    front = y < h / 2
    left = x < cx
    return 'A' if front == left else 'B'

def generate(name):
    path, n, top, s, mode, shadow, thicken = ANIMALS[name]
    sheet = Image.open(os.path.join(ROOT, path)).convert('RGBA')
    layers, w = split_layers(sheet, n)
    h = sheet.height
    # 影子层（小羊第 0 层）：半透明影子上画着蹄印，只移动蹄印
    shadow_color = None
    if shadow:
        shadow_color = Counter(p for p in layers[0].get_flattened_data() if p[3]).most_common(1)[0][0]
    # 收集腿部像素：(层, x, y, 颜色, 组)
    pixels = []
    for li in range(top + 1):
        for y in range(h):
            for x in range(w):
                p = layers[li].getpixel((x, y))
                if p[3] == 0 or (shadow and li == 0 and p == shadow_color):
                    continue
                pixels.append((li, x, y, p, leg_group(x, y, w, h, mode)))
    # 身体最底下一层的轮廓（外扩 1 像素）：腿摆动时不能比原画更伸出这个轮廓，否则斜着看会和身体断开
    body = layers[top + 1]
    footprint = set()
    for y in range(h):
        for x in range(w):
            if body.getpixel((x, y))[3]:
                for dx in (-1, 0, 1):
                    for dy in (-1, 0, 1):
                        footprint.add((x + dx, y + dy))
    def outside(y_list, x_list):
        return sum(1 for x, y in zip(x_list, y_list) if (x, y) not in footprint)
    groups = {}
    for li, x, y, p, g in pixels:
        groups.setdefault((g, li), []).append((x, y, p))
    frames = []
    for a_dy, b_dy in pattern(s):
        new = [l.copy() for l in layers]
        # 清掉原来的腿
        for li, x, y, p, g in pixels:
            new[li].putpixel((x, y), shadow_color if (shadow and li == 0) else (0, 0, 0, 0))
        for g, dy_foot in (('A', a_dy), ('B', b_dy)):
            # 腿以髋部为轴摆动：从髋部往下逐层决定位移，相邻两层最多差 1 像素
            prev = 0
            offsets = {}
            for li in range(top, -1, -1):
                want = round(dy_foot * (top - li) / max(top, 1))
                want = max(prev - 1, min(prev + 1, want))
                pts = groups.get((g, li), [])
                xs = [x for x, y, p in pts]; ys = [y for x, y, p in pts]
                base = outside(ys, xs)
                dy = want
                # 往 0 收，直到伸出身体轮廓的像素不比原画多
                while dy != 0 and outside([y + dy for y in ys], xs) > base:
                    dy += 1 if dy < 0 else -1
                prev = dy
                offsets[li] = (dy, pts)
            # 画腿。叠片每往上一层在屏幕上高 1 像素，腿斜着摆时，相邻两层错开的 1 像素转到某些角度
            # 会和“往上叠”的方向叠加成 2 像素的空隙。所以在下一层的位置也补一个像素，把腿连成一段斜线。
            for li, (dy, pts) in offsets.items():
                below = offsets.get(li - 1, (dy, None))[0]
                # 只有 1 像素宽的腿，转到某些角度会在采样时整个被跳过，按需往身体中线一侧加宽 1 像素
                thin = thicken and 0 < li < top and len(pts) <= 2
                for x, y, p in pts:
                    xs = [x, x + (1 if x < w / 2 else -1)] if thin else [x]
                    for xx in xs:
                        for d in sorted({dy, below}):
                            if 0 <= y + d < h:
                                new[li].putpixel((xx, y + d), p)
        out = Image.new('RGBA', sheet.size)
        for i, l in enumerate(new):
            out.paste(l, (i * w, 0))
        frames.append(out)
    return frames

if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    for name in ANIMALS:
        for i, f in enumerate(generate(name)):
            f.save(os.path.join(OUT, '%s_walk_%d.png' % (name, i)))
        print(name, 'ok')
