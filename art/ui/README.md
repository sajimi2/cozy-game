# 绒绒公园界面素材

- title_cover.png：用户人工微调的封面原字节副本。
- ending_gathering.png：已选定 rongrong_ending_v4 的原字节副本。
- ending_credits_crayon.png：使用结尾合照作为风格参考生成的蜡笔涂鸦致谢页；游戏中以线性过滤显示，不使用像素风。
- button_*.svg：简化纸片按钮的正常、悬停、按下状态，可编辑矢量素材。

界面场景与主题位于 src/ui/illustrated/，在 Godot 中可选择、移动和微调节点。
插画界面逻辑尺寸 768×576，以窗口分辨率绘制；进入游戏或收起画页后恢复原 192×144 像素整数缩放。

中文 UI 使用荆南字坊的[荆南麦圆体](https://github.com/maoken-fonts/KNMaiyuan)，字体、SIL OFL 许可与作者说明分别保存在 fonts/ui/KNMaiyuan-Regular.ttf、KNMaiyuan-OFL.txt 和 KNMaiyuan-AUTHORS.txt。

开始页 Cover 挂接原生 StartBreeze.tres 动态材质，标题局部缓慢晃动。花瓣复用原图四种取样，全部采用 20×21 逻辑像素的统一显示基准；七个错开的位置按同一 26 秒周期持续补充，原位置在渲染时补回天空渐变与纸纹。

底部六丛草与三朵花按稍有差异的节奏摆动，风力缓慢起伏，草尖和花头的位移比根部大，另有极小的上下起伏。2026-10-14 根据反馈，将花草摆幅提高为前一版的 1.6 倍。草丛位移主要作用于较深的绿色笔触，减少浅色地面与小路的变形。

上方樱花树冠的三簇花叶也随同一股风轻柔起伏，相位稍有先后；取样边缘略扩，保持花叶轮廓连续，棕色枝干从位移中排除。原 PNG 未改动。在检查器可微调 title_sway、vegetation_sway、canopy_sway，或用 petals_enabled 开关花瓣；preview_time=-1 使用实际时间，非负值仅供定格预览。
