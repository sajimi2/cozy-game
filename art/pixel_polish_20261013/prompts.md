# 水井与按键像素美术提示词

使用内置 image_gen；生成原稿保留，正式素材需按原生像素尺寸整理后再挂接。

## 水井

Use case: precise-object-edit.
Asset type: tiny pixel sprite for the existing spring game, native canvas 32 columns x 44 rows.
Input image 1 is the edit target: the in-game stone well. Input image 2 is a supporting palette/geometry reference, the old layered well sprite sheet.
Redesign only the well as one isolated, cohesive sprite on real transparent background. Preserve the low stone well without a roof, its rounded footprint, and the game camera angle. The drawable well should occupy about 28 logical pixels wide by 38 logical pixels tall, with small clear margins.
Use true low-resolution square pixel clusters, a consistent single-pixel logical grid and a small flat-color palette. Form a readable oval well lip, a dark recessed inner wall, and a small calm blue water surface with one restrained highlight. Two or three large staggered stone courses on the front, fewer masonry joints, coherent light from upper left. Slight handmade asymmetry; no noise, tiny cracks, rim decorations, plants, bucket, or rope.
Palette: dark muted violet #454259, cool dark gray #5b6975, stone gray #8f9ba8, light stone #b4c1c8, deeper blue #55718c, water blue #86abc5, water highlight #b3cce6. Transparent outside. At most seven opaque flat colors. No gradients, antialiasing, realistic texture, perspective floor, cast-shadow blur, outline glow, labels, or background scene.
Render as a large integer-upscaled pixel sprite so the intended 32x44 grid remains clearly readable; do not add subpixel detail inside the square blocks.

## 键帽动画

Use case: precise-object-edit.
Asset type: existing eight-frame input-hint sprite sheet, native layout 8 columns x 1 row, each tile 18x12 logical pixels.
Input image is the old KeyPress sprite sheet. Redesign the exact same eight-frame strip with real transparent background and consistent tile alignment. Frames 1-4 show a small Z key; frames 5-8 show a wider spacebar. Preserve the same frame order: released, lowered one logical pixel, held down, released.
The Z should be a clear uppercase block-pixel Z, with readable top and bottom horizontal bars and a diagonal between them. The spacebar has one simple small horizontal bar mark. Cream key face, a tiny top-left highlight, darker bottom bevel, muted violet single-pixel outline. Same restrained visual weight in all frames, no extra symbols, no plus signs, no arrows, no rounded vector lettering, no labels outside key faces.
Native Z key face about 9x8 logical pixels, native spacebar about 15x6 logical pixels, within the same 18x12 tiles. Palette: #454259 outline, #7a6b6e bottom bevel, #cbbba0 side, #f3e7cd face, #fff9e8 highlight. Exactly eight cells in a horizontal strip, all at the same scale, with no divider lines or grid.
Render as a large integer-upscaled pixel sheet; retain simple discrete square clusters suitable for tiny gameplay rendering. No antialiasing, gradients, paper grain, soft shadow, or scene background.
