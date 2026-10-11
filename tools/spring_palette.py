"""把秋天的配色换成春天（樱花＋嫩绿），直接改写 sprites/ 下的图片。

只换植物、地面和落叶；谷仓、动物、主角、草垛、蘑菇、谷仓室内保持原样。
每张图只按自己那张换色表替换“秋天的源颜色”，目标颜色不会再被当成源颜色，
所以重复运行不会把颜色换两次。

用法（仓库根目录）：python3 tools/spring_palette.py
"""
from PIL import Image
import os

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')

GRASS = (134, 176, 96)
SAND = (192, 170, 122)

GREEN_FOLIAGE = {
    (64, 33, 47): (40, 70, 60),      # 最暗的阴影
    (112, 47, 62): (66, 112, 74),    # 暗部
    (145, 68, 68): (92, 146, 84),    # 中间色
    (156, 96, 65): (136, 180, 98),   # 亮部
    (158, 99, 51): (152, 192, 104),
    (110, 52, 52): (74, 124, 76),    # 灌木底色
}
BLOSSOM = {
    (64, 33, 47): (112, 72, 92),
    (112, 47, 62): (204, 132, 158),
    (145, 68, 68): (232, 172, 192),
    (156, 96, 65): (250, 214, 222),
    (158, 99, 51): (255, 232, 236),
    (110, 52, 52): (186, 114, 144),
}
YOUNG_WHEAT = {
    (204, 161, 98): (146, 186, 98),
    (217, 186, 139): (186, 216, 138),
    (153, 135, 95): (108, 150, 80),
}
GROUND = {
    (161, 126, 103): SAND,           # 土路 → 偏暗的沙色小路
    (189, 147, 83): GRASS,           # 贴图边缘的草地
    (204, 161, 98): GRASS,           # 玉米迷宫的田地
    (153, 121, 81): (170, 150, 106),
    (179, 149, 125): (208, 188, 142),
}
PETALS = {
    (117, 64, 64): (238, 186, 200),
    (112, 47, 62): (250, 236, 240),
    (145, 68, 68): (244, 206, 216),
}

FILES = {
    'stacked/Tree_1.png': BLOSSOM,
    'stacked/Tree_2.png': GREEN_FOLIAGE,
    'stacked/Tree_3.png': BLOSSOM,
    'stacked/Bush_1.png': GREEN_FOLIAGE,
    'stacked/RoundBush.png': GREEN_FOLIAGE,
    'stacked/Wheat_1.png': YOUNG_WHEAT,
    'stacked/Wheat_3.png': YOUNG_WHEAT,
    'stacked/Wheat_4.png': YOUNG_WHEAT,
    'stacked/Wheat_5.png': YOUNG_WHEAT,
    'main_area/Path.png': GROUND,
    'etc/Path.png': GROUND,
    'starting_area/GrassifiedPath.png': GROUND,
    'starting_area/DirtPath.png': GROUND,
    'areas/LeftPath.png': GROUND,
    'areas/NorthPath.png': GROUND,
    'areas/Lake.png': GROUND,
    'minigames/Maze.png': GROUND,
    'effects/Leaf_1.png': PETALS,
    'effects/Leaf_2.png': PETALS,
    'effects/Leaf_3.png': PETALS,
}


def recolor(rel, table):
    path = os.path.join(ROOT, 'sprites', rel)
    im = Image.open(path).convert('RGBA')
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if a and (r, g, b) in table:
                px[x, y] = table[(r, g, b)] + (a,)
    im.save(path)


if __name__ == '__main__':
    for rel, table in FILES.items():
        recolor(rel, table)
        print(rel)
