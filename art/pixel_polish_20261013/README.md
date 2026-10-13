# 水井与按键像素美术（2026-10-13）

原稿使用内置 image_gen 生成，完整提示词在 prompts.md，原生成稿保存在 source_imagegen/。正式 PNG 已整理为原生像素尺寸、有限配色和 0/255 硬透明。

- sprites/stacked/WellSpring_v2.png：32×44、7 色。井沿、深色内壁与水面分开，石缝收敛为较大的石块。Well.tscn 使用该整张静态 sprite，视觉偏移 (0,-6)，碰撞仍为原来的半径 14。
- Well.tscn 的 GroundShadow 为单独可编辑的 Polygon2D：整数像素阶梯轮廓、位置 (1,9)、约 32×14、20% 透明度，排在井身之前绘制。
- sprites/ui/symbols/KeyPressSpring_v2.png：144×12、5 色，8 个 18×12 横排帧。前 4 帧为 Z 键，后 4 帧为空格键，各有抬起、按下、保持、回弹状态。InteractableSign.tscn 使用该素材，保留原 Z/空格交互。

两个场景均通过 Godot 编辑器更新并保存。符号数组声明为 Array[Texture2D]，使编辑器可按纹理资源挂接；交互逻辑不变。原 Well.png、KeyPress.png 与通用 Interactable.gd 保留原字节。

相关实际运行：新水井正确显示，碰撞半径 14；新按键提示进入范围时出现，8 帧布局正常，Z 键完成标牌交互。运行证据与修改前备份在 D:/vibe coding/CozyGame_Builds/pixel_well_keycaps_20261013/。
