tool

extends PanelContainer

onready var _project_rows: VBoxContainer = $VLayout/Padding/VertLayout/ProjectListRows
onready var _project_crud_popup: WindowDialog = $ProjectCrudPopup

export(int) var create_project_window_width = 600
export(int) var create_project_window_height = 600


var project_panel: PackedScene = preload("res://addons/tilth_project_tracker/tilth/scenes/project/project_list_item.tscn")


func _ready() -> void:
	set_theme(AppSettings.get_current_theme_resource())
	OS.set_window_title("%s - %s" %
		[ProjectSettings.get_setting("application/config/name"),
		 ProjectSettings.get_setting("application/config/version")])
	Events.connect("project_deleted", self, "_on_project_deleted")
	Events.connect("project_created", self, "_on_project_created")
	Events.connect("app_settings_changed", self, "_on_app_settings_changed")
	_load_project_list()

func _on_project_deleted(project_id: String) -> void:
	_load_project_list()

func _on_project_created(project: Project) -> void:
	_load_project_list()

func _load_project_list() -> void:
	for row in _project_rows.get_children():
		row.queue_free()
	var project_repo = ResourceRepository.new()
	project_repo.init("Project", AppSettings.resource_store_path)
	var projects = project_repo.load_all_resources(true) # skip cache
	for project in projects:
		var panel := project_panel.instance()
		panel.set_project(project)
		panel.set_root_container(self)
		_project_rows.add_child(panel)

func _on_app_settings_changed():
	set_theme(AppSettings.get_current_theme_resource())
