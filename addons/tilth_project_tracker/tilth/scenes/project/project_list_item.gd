tool

extends PanelContainer

export(int) var detail_window_width = 600
export(int) var detail_window_height = 600

onready var open_button: Button = $Padding/HLayout/VLayout/OpenButton
onready var edit_button: Button = $Padding/HLayout/VLayout/EditButton
export(String, FILE, "*.tscn") var project_scene
onready var project_crud_popup: Popup = $ProjectCrudPopup

var _project: Project
var _root_container: Control

func _ready() -> void:
	Events.connect("project_state_changed", self, "_on_project_state_changed")
	open_button.connect("pressed",self, "_on_open_project_pressed")
	edit_button.connect("pressed",self, "_on_edit_project_pressed")

func set_project(project: Project) -> void:
	_project = project
	_set_field_values()

func set_root_container(control: Control) -> void:
	_root_container = control

func _set_field_values():
	$Padding/HLayout/Rows/ProjectName.text = _project.name
	$Padding/HLayout/Rows/ProjectDescription.text = _project.description

func _on_open_project_pressed() -> void:
	var project_board_scene = load(project_scene).instance()
	print("project_scene: %s" % project_board_scene)
	project_board_scene.set_project(_project)
	SceneChanger.change_scene_to_instance(_root_container, project_board_scene, 0)

func _on_edit_project_pressed() -> void:
	project_crud_popup.popup_centered(Vector2(detail_window_width, detail_window_height))
	project_crud_popup.set_project(_project)


func _on_project_state_changed(project: Project):
	if(project.id == _project.id):
		set_project(project)
