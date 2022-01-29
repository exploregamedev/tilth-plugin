tool

extends PanelContainer

var _project_list_scene_path: String = "res://addons/tilth_project_tracker/tilth/scenes/project/projects_list.tscn"
onready var _project_crud_popup: WindowDialog = $ProjectCrudPopup
onready var _preferences_popup: WindowDialog = $PreferencesDialog
onready var _about_popup: Popup = $AboutPopup
onready var _file_dialog: FileDialog = $ProjectFileDialog

var _popup_open_min_size = Vector2(600,400)

export(String) var help_menu_url = "https://github.com/exploregamedev/tilth-plugin"

var project: Project setget set_project

# Foreach key add a "_on_%s_menu_item_pressed" % key.to_lower() function
var _menus: Dictionary = {
	# @todo turn prefs back on to get back ability to change data storage path
	# #14 : https://github.com/exploregamedev/tilth-plugin/issues/14
	#	"Tilth": ["About", "Preferences"],
	"Tilth": ["About"],
	"Project": ["Edit project"],
	# @todo Backup disabled see: #15 : https://github.com/exploregamedev/tilth-plugin/issues/15
	# "Project": ["Edit project", "Load project from backup"],
	"Help": ["Docs"]
}

func _ready() -> void:
	_file_dialog.connect("file_selected", self, "_on_file_selected")
	_init_menu_items()

func set_project(current_project: Project) -> void:
	project = current_project

func _init_menu_items() -> void:
	for menu_name in _menus:
		var menu_node: MenuButton = get_node("Padding/HLayout/%s" % menu_name)
		var menu_popup: PopupMenu = menu_node.get_popup()
		menu_node.set_switch_on_hover(true)
		menu_popup.connect(
			"id_pressed", self, "_on_%s_menu_item_pressed" % menu_name.to_lower())
		menu_popup.clear()
		for menu_item in _menus[menu_name]:
			menu_popup.add_item(menu_item)

func _on_tilth_menu_item_pressed(menu_item: int):
	match menu_item:
		0: # About
			_about_popup.popup_centered(_popup_open_min_size)
		1: # Preferences
			_preferences_popup.popup_centered(_popup_open_min_size)

func _on_project_menu_item_pressed(menu_item: int):
	match menu_item:
		0: # Edit project
			_project_crud_popup.popup_centered_minsize(_popup_open_min_size)
			_project_crud_popup.set_project(project)
# @todo Backup disabled see: #15 : https://github.com/exploregamedev/tilth-plugin/issues/15
#		1: # load backup
#			var window_size = Vector2(600, 400)
#			_file_dialog.popup_centered(window_size)

func _on_help_menu_item_pressed(menu_item: int):
	match menu_item:
		0: # Docs
			OS.shell_open(help_menu_url)

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
	project_repo.init("Project")
	var project = project_repo.load_from_file(file_path, true) # ignore cache
	project.name = "%s-restored from %s backup" % [project.name, path_parts[-2]]
	project.id = Uuid.v4()
	project.save()
	print("[EMIT] project_created")
	Events.emit_signal("project_created", project)


