extends Node
# Godot 4 原生整数缩放，保留原工程的基础分辨率与黑边。
func _ready():
    var window := get_window()
    var base := Vector2i(
        ProjectSettings.get_setting("display/window/integer_resolution_handler/base_width", 192),
        ProjectSettings.get_setting("display/window/integer_resolution_handler/base_height", 144))
    window.min_size = base
    window.content_scale_size = base
    window.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
    window.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
    window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER
