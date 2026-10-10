extends RefCounted

# 所有中文引导文本集中放在这里，调整措辞只需改这个文件。
# 提示条宽约 14 个汉字，尽量控制在 3 行以内。

const CONTROLS = "方向键/WASD 移动\nZ 键和大家互动"

const SIGN = "木牌上好像写着什么…\n按 Z 读一读。"
const SIGN_DONE = "「公园里的六位朋友遇到了麻烦。帮助他们，谷仓的大门就会打开。」"

const MAIN_AREA = "中央广场。东、西、北三条路通往不同的地方，告示牌可以查看进度。"

const PROGRESS_SIGN = "进度告示牌，按 Z 查看。"
const PROGRESS = "已帮助 %d/6 位朋友，还差：\n%s"
const PROGRESS_DONE = "六位朋友都帮完啦！\n谷仓的大门已经打开了。"

const BARN_LOCKED = "谷仓的门锁着。帮助六位朋友后它就会打开（还差 %d 位）。"

const CHICKEN = "小鸡想和你猜拳，三局两胜。按 Z 时它气泡里的手势，就是它整局要出的拳。"
const CHICKEN_RETRY = "你赢了，小鸡却哭了…\n也许输给它，它才会开心？"
const CHICKEN_DONE = "小鸡赢得很开心！"
const RPS_CONTROLS = "←→ 选择　Z 出拳　X 退出"

const SHEEP = "小羊在想一个数字，就是它气泡里那个。记住它，按 Z 后选出来！"
const SHEEP_RETRY = "按 Z 让小羊重新想一个数字，记住它，再按一次 Z 开始。"
const SHEEP_DONE = "小羊很佩服你的记性！"
const NUMBER_CONTROLS = "←→ 选择　Z 确认　X 退出"

const FROG = "青蛙的无人机停在西边树林里。按 Z 接过遥控器，让它降落到青蛙身边的 X 标记上！"
const DRONE_CONTROLS = "按住 Z 升空，松开下降，飞高后才能用方向键移动。X 放弃"
const FROG_RETRY = "无人机坠毁了…飞太低会撞树或掉进树林，飞太高会被风吹偏。"
const FROG_DONE = "无人机平安降落，青蛙很开心！"

const SCARECROW = "稻草人在打瞌睡。叫醒它会引来一场雷雨，坚持到底部计时条走完就算赢！"
const SCARECROW_CONTROLS = "躲开幽灵和闪电，撑到底部计时条走完！X 放弃"
const SCARECROW_RETRY = "没撑住？稻草人头上的图标会预告下一招：散射、追踪或落雷。"
const SCARECROW_DONE = "稻草人心服口服。"

const EAST_MAZE = "玉米迷宫：从上下两端走出去，会从另一端绕回来。鸵鸟就在最东边。"
const OSTRICH = "鸵鸟在迷宫深处待了好久，好像有点孤单。按 Z 跟它打个招呼吧。"
const OSTRICH_DONE = "鸵鸟不再孤单了。"

const DODO = "渡渡鸟把蛋弄丢了。公园里藏着几颗蛋，找到一颗带回来吧！"
const DODO_HAS_EGG = "你带着蛋！按 Z 交给渡渡鸟。"
const DODO_DONE = "渡渡鸟的蛋回家了。"

const EGG = "一颗蛋！按 Z 捡起来，\n说不定有人正在找它。"
const EGG_PICKED = "捡到了一颗蛋！\n带去西边交给渡渡鸟吧。"

# 进度告示牌列出尚未完成的朋友，顺序与 Globals.get_progress_level 一致。
const FRIEND_NAMES = {
	"chicken": "小鸡(广场)",
	"sheep": "小羊(广场)",
	"frog": "青蛙(西)",
	"dodo": "渡渡鸟(西)",
	"scarecrow": "稻草人(北)",
	"ostrich": "鸵鸟(东)",
}

static func progress_text():
	var remaining = []
	for key in FRIEND_NAMES:
		if !Globals.has_completed(key):
			remaining.push_back(FRIEND_NAMES[key])
	if remaining.is_empty():
		return PROGRESS_DONE
	return PROGRESS % [6 - remaining.size(), wrap_entries(remaining)]

# 按条目手动换行，避免“鸵鸟(东)”这类名字被自动换行拆开。
const CHARACTERS_PER_LINE = 14

static func wrap_entries(entries):
	var lines = [""]
	for entry in entries:
		var line = lines[-1]
		var joined = entry if line == "" else line + "、" + entry
		if line != "" and joined.length() > CHARACTERS_PER_LINE:
			lines[-1] = line + "、"
			lines.push_back(entry)
		else:
			lines[-1] = joined
	return "\n".join(lines)
