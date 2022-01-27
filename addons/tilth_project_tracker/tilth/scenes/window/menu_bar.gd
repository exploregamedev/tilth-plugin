tool

extends PanelContainer

var _project_list_scene_path: String = "res://addons/tilth_project_tracker/tilth/scenes/project/projects_list.tscn"
onready var _project_crud_popup: WindowDialog = $ProjectCrudPopup
onready var _preferences_popup: WindowDialog = $PreferencesDialog
onready var _about_popup: Popup = $AboutPopup
onready var _help_popup: Popup = $HelpPopup
onready var _file_dialog: FileDialog = $ProjectFileDialog

export(int) var create_project_window_width = 600
export(int) var create_project_window_height = 600

# Foreach key add a "_on_%s_menu_item_pressed" % key.to_lower() function
var _menus: Dictionary = {
	"Tilth": ["About", "Preferences", "Quit"],
	"Project": ["Projects list", "New project", "Load project from backup"],
	"Help": ["Docs"]
}

func _ready() -> void:
	_file_dialog.connect("file_selected", self, "_on_file_selected")
	for menu_name in _menus:
		var menu_node = get_node("Padding/HLayout/%s" % menu_name)
		menu_node.set_switch_on_hover(true)
		menu_node.get_popup().connect(
			"id_pressed", self, "_on_%s_menu_item_pressed" % menu_name.to_lower())
		for menu_item in _menus[menu_name]:
			menu_node.get_popup().add_item(menu_item)

func _on_tilth_menu_item_pressed(menu_item: int):
	match menu_item:
		0: # About
			var window_size = Vector2(600, 500)
			_about_popup.popup_centered(window_size)
		1: # Preferences
			var window_size = Vector2(800, 600)
			_preferences_popup.popup_centered(window_size)
		2: # Quit
			get_tree().quit()

func _on_project_menu_item_pressed(menu_item: int):
	match menu_item:
		0: # Projects list
			SceneChanger.change_scene(_project_list_scene_path, 0)
		1: # New project
			var window_size = Vector2(create_project_window_width, create_project_window_height)
			_project_crud_popup.popup_centered(window_size)
		2: # load backup
			var window_size = Vector2(600, 400)
			_file_dialog.popup_centered(window_size)

func _on_help_menu_item_pressed(menu_item: int):
	match menu_item:
		0: # Docs
			var window_size = Vector2(600, 600)
			_help_popup.popup_centered(window_size)

func _on_file_selected(file_path: String) -> void:
	"""
	Example path:
	.../next_game/2021-12-25T21.04.17/save_project-61b1f407-ddc4-4dec-950b-d1b5260b7e15.tres
	- load project from file
	- change project name, give Project a new id
	- save the project
	"""
	var path_parts = file_path.split("/")
	var project_repo = ResourceRepository.new()
	project_repo.init("Project", AppSettings.resource_store_path)
	var project = project_repo.load_from_file(file_path, true) # ignore cache
	project.name = "%s-restored from %s backup" % [project.name, path_parts[-2]]
	project.id = Uuid.v4()
	project.save()
	print("[EMIT] project_created")
	Events.emit_signal("project_created", project)


