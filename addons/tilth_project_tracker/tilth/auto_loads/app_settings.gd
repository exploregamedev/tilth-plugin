tool

extends Node

const THEME_PATH := "res://addons/tilth_project_tracker/tilth/themes/"
const THEME_MAP = {
	"light": "light/theme_light.tres",
# @TODO enable dark theme
#       Will need process to not only select main theme file but also apply
#       theme specific tweaks to components in specific contexts based on the
#       overall theme.
#	"dark": "dark/theme_dark.tres"
}
const THEME_DEFAULT = "dark"

var _settings: Dictionary = {
	"create_timestamp": OS.get_unix_time(),
	"resource_store_path": OS.get_user_data_dir(),
	"current_theme": "light",
}

var _current_theme_resource: Theme

var _save_path: String = OS.get_user_data_dir().plus_file("app_settings.json")

func _init() -> void:
	_load_state()
	_build_theme_resource()

func get_themes_list() -> Array:
	var themes = THEME_MAP.keys()
	themes.erase(_settings["current_theme"])
	themes.insert(0, _settings["current_theme"])
	return themes

func get_current_theme_resource() -> Theme:
	return _current_theme_resource

func _get(property: String):
	if not property in _settings:
		printerr("[ERROR] AppSettings has no property: %s" % property)
		return null
	return _settings[property]

func _set(property: String, value) -> bool:
	if not property in _settings:
		printerr("[ERROR] AppSettings has no property: %s" % property)
		return false
	if property == "current_theme":
		_settings[property] = value.to_lower()
		_build_theme_resource()
	_settings[property] = value
	_save_state()
	print("[EMIT] app_settings_changed")
	Events.emit_signal("app_settings_changed")
	return true

func _save_state() -> bool:
	print("saving AppSettings")
	var file = File.new()
	file.open(_save_path, File.WRITE)
	file.store_line(to_json(_settings))
	file.close()
	return true

func _load_state() -> bool:
	print("loading AppSettings")
	var file = File.new()
	if not file.file_exists(_save_path):
		print("AppSetting file not found at: %s ,creating initial copy" % _save_path)
		_save_state()
		return true
	var loaded = file.open(_save_path, file.READ)
	if loaded != OK:
		print("There was an error loading settings from file: %s" % _save_path)
		return false
	var text = file.get_as_text()
	file.close()
	_settings = parse_json(text)
	_settings["create_timestamp"] = int(_settings["create_timestamp"])
	return true

func _to_string() -> String:
	return str(_settings)

func _build_theme_resource() -> bool:
	var theme_name = _settings["current_theme"].to_lower()
	if not theme_name in THEME_MAP:
		printerr("Unknown theme: " + theme_name + ". Building default theme: " + THEME_DEFAULT)
		theme_name = THEME_DEFAULT
	var theme_path = "%s/%s" % [THEME_PATH, THEME_MAP[theme_name]]
	var new_theme: Theme = ResourceLoader.load(theme_path)
	if not new_theme:
		printerr("Unable to load theme: " + theme_path)
		return false
	print("[AppTheme] Instanciated theme: " + theme_path)
	_current_theme_resource = new_theme
	_settings["current_theme"] = theme_name
	return true
