tool

extends FileDialog

func _ready() -> void:
	"""
	@hack Bring back the window title bar
		  https://github.com/godotengine/godot/issues/40267#issuecomment-656887073
	"""
	var bg_panel: StyleBox = get_stylebox("panel")
	bg_panel.expand_margin_top = 25

	set_resizable(true)

	current_dir = AppSettings.resource_store_path
	set_filters(PoolStringArray(["*.tres ; Resource files"]))


