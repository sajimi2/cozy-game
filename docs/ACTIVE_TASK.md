# 当前任务

最后核对：2026-10-13。

## 唯一当前目标

已完成：将当前封面、UI、结尾画页、水井及阴影、按键提示的正式资源与逻辑同步到 sajimi2/cozy-game 的 main 分支。

## 已完成及证据

- 功能提交为 2f9b3c137bbaa11bf424b7e80aa86ed85bb82ebb，45 个文件；已推送到 origin/main，并通过远端 refs/heads/main 读回同一提交。
- 开始页使用用户人工微调封面，保留标题轻晃、持续飘落的花瓣与花草微摆；纸片按钮和中文 UI 使用荆南麦圆体，字体许可与作者说明随资源上传。
- 谷仓中央书架可打开结尾合照，暂停玩法并支持关闭、再次打开与查看原作致谢。
- 水井为 32x44 新像素素材，GroundShadow 独立可编辑，位置 (1,9)、20% 透明度、整数像素阶梯轮廓；井的碰撞半径 14 保留。浅色 Z/空格键帽保留 8 帧按下与回弹顺序。
- 核对 68 个提交资源引用，无缺失；从 Git 提交文件生成不含本地缓存的副本，Godot 4.7.2 导入与默认开始页启动均 exit 0，无脚本或资源错误。git diff --cached --check 通过。
- 本轮上传核对证据：D:/vibe coding/CozyGame_Builds/github_sync_20261013/，包含 staged_files.json、project_snapshot/、import.log、startup.log。未重跑自由试玩或完整通关。
- 已有水井阴影实际运行画面保存在 D:/vibe coding/CozyGame_Builds/well_shadow_20261013/；水井和键帽的实际显示与 Z 键交互证据在 D:/vibe coding/CozyGame_Builds/pixel_well_keycaps_20261013/。源图、配色与完整提示词在已上传的 art/pixel_polish_20261013/。

## 实际未完成

- 无本轮游戏版本同步待办。
- 本轮不重新导出 Windows/Web 包。

## 下一步

Claude 后续从 GitHub main 分支继续修改；有新改动后再同步回本地，由用户试玩验收。

## 边界

- 仅修改 Cozy Autumn 工程，没有改动 FantasyARPG。
- StartingArea.tscn 的既有资源 UID/保存格式变化保留在本地，没有作为本轮功能改动提交。
- 历史迁移、上传与玩法优化已完成，不作为本轮待办重做。未做全程通关或六个小游戏的重复回归。
- 旧插画候选稿与已替换字体继续保留本地；当前游戏引用的 art/ui/、荆南麦圆体及许可、原生 UI 资源均已上传。未上传缓存、导出包或个人 MCP 配置。
