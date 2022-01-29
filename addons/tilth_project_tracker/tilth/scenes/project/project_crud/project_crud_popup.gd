tool

extends WindowDialog


onready var id_field: LineEdit = $PanelBorder/VLayout/BodyContainer/Padding/VBoxContainer/IdContainer/IdField
onready var name_field: LineEdit = $PanelBorder/VLayout/BodyContainer/Padding/VBoxContainer/NameContainer/NameField
onready var desc_field: TextEdit = $PanelBorder/VLayout/BodyContainer/Padding/VBoxContainer/DescContainer/DescField
onready var save_button: Button = $PanelBorder/VLayout/ControlsContainer/Padding/HBoxContainer/SaveButton
onready var delete_button: Button = $PanelBorder/VLayout/ControlsContainer/Padding/HBoxContainer/DeleteButton

var _project: Project setget set_project

func _ready() -> void:
	window_title = "Create project"
	save_button.connect("pressed", self, "on_save_pressed")
	delete_button.connect("pressed", self, "on_delete_pressed")
	delete_button.visible = false

func set_project(project: Project) -> void:
	window_title = "Edit project"
	_project = project
	populate_fields()

func populate_fields() -> void:
	"""
	Populate the project form fields
	"""
	id_field.text = _project.id
	name_field.text = _project.name
	desc_field.text = _project.description

func populate_from_fields(project: Project) -> void:
	project.id = id_field.text
	project.name = name_field.text
	project.description = desc_field.text

func on_save_pressed() -> void:
	"""
	Persist the project values
	"""
	if _project:
		populate_from_fields(_project)
		_project.save()
	else:
		var project = Project.new()
		populate_from_fields(project)
		project.save()
	visible = false

func on_delete_pressed() -> void:
	"""
	Delete the project from persistence
	"""
	_project.delete()



