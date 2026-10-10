# cozy-autumn

Game made for Cozy Autumn Jam :]

## Godot 4 适配（2026-10-10）

已适配本机 Godot 4.7.2。工程名称为 **Feather Park**，保留原来的 192×144 逻辑分辨率、576×432 初始窗口、整数缩放和像素画素材。

在 Godot 项目管理器中选择「导入」，打开本目录的 `project.godot`，进入编辑器后按 **F5** 运行。无需再次执行 Godot 3 转换。

- 移动：方向键或 WASD。
- 交互/确认：Z、空格或 Enter。
- 取消小游戏：X、Esc 或 Tab。
- 开场有短暂过渡，等待人物恢复移动即可。
- 调试截图快捷键 O 现在保存到 `user://`（Godot 的「打开用户数据文件夹」可查看），不再使用原作者的桌面路径。

本轮修复了旧 Tween、窗口缩放、绘制接口、屏幕纹理着色器、动画资源、场景循环引用及角色朝向等兼容问题。原工程缺少的 `sprites/minigames/Credits.png` 已从[原作者仓库](https://github.com/jontopielski/cozy-autumn/blob/master/sprites/minigames/Credits.png)恢复；原有 218 个图片、音频和字体文件均保持原字节。

已完成：78 个脚本和 90 个场景加载、32 项运行触发检查，以及正常渲染/系统音频环境下的开场检查。运行检查包含模拟按键和直接调用交互回调；完整通关、听感与操作手感仍需用户试玩。

迁移前完整备份、素材校验和检查证据位于 `D:\vibe coding\CozyAutumn_Migration_20261010\`，其中 `before_migration.zip` 保存本轮修改前的工程现状（当时已存在未完成的自动转换）。

## 中文引导（2026-10-10）

原版几乎没有文字，很多胜利条件只能从源码里看出来。现在加入了不打断操作的中文提示条：

- 靠近角色、木牌、蛋或上锁的谷仓门时，底部显示提示；离开后自动收起。
- 小游戏开始后，顶部显示操作说明（猜拳、猜数字常驻；无人机、稻草人 6 秒后收起）。
- 失败一次后，提示会换成更直白的说法，例如小鸡猜拳会提示“也许输给它”。
- 中央广场的告示牌按 Z 后列出还没帮助的朋友和方位。
- 第一次进入起始区、中央广场、东边迷宫时各有一条区域说明。

所有文案集中在 `src/ui/HintText.gd`，改措辞只需改这一个文件；提示条逻辑在 `src/ui/TextBox.gd`。角色脚本只要实现 `get_hint()`，靠近时就会自动显示提示。另外改了一处玩法细节：猜数字失败后再按 Z，小羊只会换一个新数字并展示出来，再按一次才开始，避免新数字一闪而过。

中文使用 [Fusion Pixel 12px](https://github.com/TakWolf/fusion-pixel-font) 简体中文版（SIL OFL 1.1），许可证见 `fonts/FusionPixel-licenses/`。

迁移参照：[Godot 官方升级说明](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.html)。
