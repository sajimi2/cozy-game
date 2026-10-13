# cozy-autumn

Game made for Cozy Autumn Jam :]

## 绒绒公园开始页与结尾画页（2026-10-11）

当前默认启动封面开始页，使用用户人工微调的插画。提供“开始游玩”和声音开关，支持鼠标与键盘；“怎么玩”入口已移除。标题轻微晃动，统一大小的花瓣持续错开飘落，底部花草随风小幅摆动。若编辑器先前已打开，请重新打开工程后按 F5。

集齐朋友进入谷仓后，与中央书架交互可翻看结尾合照。读图时暂停角色，点击“收好这张画”或按 Esc/X/Tab 恢复游戏；可原地再次翻看。“原作致谢”按钮保留原作者名单入口。

插画与文字清晰显示，玩法仍为 192×144 像素整数缩放。原生 UI 场景、主题与动态材质在 src/ui/illustrated/，图片在 art/ui/。UI 使用荆南字坊的[荆南麦圆体](https://github.com/maoken-fonts/KNMaiyuan)，字体许可与作者说明保存在 fonts/ui/KNMaiyuan-OFL.txt 和 KNMaiyuan-AUTHORS.txt。

开始页、画页开关与像素显示的相关实际运行检查通过；完整通关与最终观感由用户试玩验收。

## 水井与按键提示（2026-10-13）

水井使用新的 32×44 像素素材，井沿、内壁和水面更清楚；井底新增淡淡的像素接地阴影，原有位置与碰撞半径保留。开始区域的 Z / 空格键提示改用浅色键帽，继续交替按下、回弹。

正式素材分别为 `sprites/stacked/WellSpring_v2.png` 和 `sprites/ui/symbols/KeyPressSpring_v2.png`，源图、配色与完整提示词在 `art/pixel_polish_20261013/`。相关实际运行显示和标牌 Z 键交互检查通过。

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

迁移参照：[Godot 官方升级说明](https://docs.godotengine.org/en/stable/tutorials/migrating/upgrading_to_godot_4.html)。
