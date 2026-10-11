"""画四种小花的叠片图（替换原来的蘑菇），输出 sprites/stacked/Flower_1~4.png。

格式与原蘑菇相同：9 层、每层 16x16，第 0 层在最下面，(8, 8) 是中心。
底下是叶子，中间是茎，顶上 3 层是花头。

用法（仓库根目录）：python3 tools/draw_flowers.py
"""
from PIL import Image
import os

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
LAYERS, SIZE, C = 9, 16, 8

GREEN_D = (66, 112, 74)
GREEN = (92, 146, 84)
GREEN_L = (136, 180, 98)
PINK_D = (204, 132, 158)
PINK = (232, 172, 192)
PINK_L = (250, 214, 222)
WHITE = (255, 251, 232)
WHITE_S = (226, 222, 214)
YELLOW = (250, 226, 110)
YELLOW_D = (214, 170, 70)
PURPLE_D = (103, 82, 122)
PURPLE = (154, 106, 156)
PURPLE_L = (190, 150, 200)


def stem_and_leaves():
    layers = [dict() for _ in range(LAYERS)]
    layers[0].update({(C - 2, C): GREEN_D, (C - 1, C): GREEN, (C, C): GREEN_D, (C + 1, C): GREEN, (C + 2, C): GREEN_D})
    layers[1].update({(C, C): GREEN, (C - 3, C): GREEN_L, (C + 3, C): GREEN_L})
    layers[2].update({(C, C): GREEN, (C + 1, C - 1): GREEN_L})
    for i in (3, 4):
        layers[i][(C, C)] = GREEN
    layers[5].update({(C, C): GREEN_D, (C - 1, C): GREEN, (C + 1, C): GREEN})
    return layers


def square(color, r=1):
    return {(C + dx, C + dy): color for dx in range(-r, r + 1) for dy in range(-r, r + 1)}


def plus(color, r=2):
    cells = {}
    for d in range(1, r + 1):
        for p in ((C + d, C), (C - d, C), (C, C + d), (C, C - d)):
            cells[p] = color
    return cells


def tulip():
    layers = stem_and_leaves()
    layers[6].update(square(PINK_D))
    layers[7].update(square(PINK))
    layers[7][(C, C)] = PINK_D
    layers[8].update({(C - 1, C - 1): PINK_L, (C + 1, C - 1): PINK_L, (C - 1, C + 1): PINK_L, (C + 1, C + 1): PINK_L})
    return layers


def daisy():
    layers = stem_and_leaves()
    layers[6].update({(C, C): GREEN})
    layers[7].update(plus(WHITE, 2))
    layers[7].update({(C - 1, C - 1): WHITE_S, (C + 1, C - 1): WHITE_S, (C - 1, C + 1): WHITE_S, (C + 1, C + 1): WHITE_S})
    layers[7][(C, C)] = YELLOW_D
    layers[8][(C, C)] = YELLOW
    return layers


def buttercup():
    layers = stem_and_leaves()
    layers[6].update(square(YELLOW_D))
    layers[7].update(square(YELLOW))
    layers[7].update(plus(YELLOW, 2))
    layers[7][(C, C)] = YELLOW_D
    layers[8][(C, C)] = WHITE
    return layers


def bellflower():
    layers = stem_and_leaves()
    layers[6].update(square(PURPLE_D))
    layers[7].update(square(PURPLE))
    layers[7].update({(C, C - 2): PURPLE_L, (C - 2, C): PURPLE, (C + 2, C): PURPLE, (C, C + 2): PURPLE})
    layers[8].update({(C, C): PURPLE_L, (C, C - 1): PURPLE_L})
    return layers


def save(layers, name):
    im = Image.new('RGBA', (SIZE * LAYERS, SIZE))
    for i, cells in enumerate(layers):
        for (x, y), color in cells.items():
            im.putpixel((i * SIZE + x, y), color + (255,))
    im.save(os.path.join(ROOT, 'sprites/stacked', name))
    print(name)


if __name__ == '__main__':
    for i, make in enumerate((tulip, daisy, buttercup, bellflower)):
        save(make(), 'Flower_%d.png' % (i + 1))
