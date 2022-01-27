tool

extends WindowDialog

var activity_entry_scene: PackedScene = preload("res://addons/tilth_project_tracker/tilth/scenes/task/activity_entry_panel.tscn")

var _task: Task setget set_task
onready var save_button: Button = $PanelBorder/VLayout/ControlsContainer/Padding/TaskButtonsContainer/SaveTaskButton
onready var delete_button: Button = $PanelBorder/VLayout/ControlsContainer/Padding/TaskButtonsContainer/PushRightContainer/DeleteTaskButton
onready var name_field: LineEdit = $PanelBorder/VLayout/BodyContainer/Padding/Rows/NameFields/NameEdit
onready var desc_field: TextEdit = $PanelBorder/VLayout/BodyContainer/Padding/Rows/DescFields/DescEdit
onready var task_id_label: Label = $PanelBorder/VLayout/BodyContainer/Padding/Rows/NameFields/TaskIdLabel
# activity
onready var activity_field: LineEdit = $PanelBorder/VLayout/ActivityContainer/Padding/ActivityFormContainer/ActivityEntry/ActivitEntryField
onready var activity_save: Button = $PanelBorder/VLayout/ActivityContainer/Padding/ActivityFormContainer/ActivityEntry/SaveActivityButton
onready var activity_entry_rows: VBoxContainer = $PanelBorder/VLayout/ActivityContainer/Padding/ActivityFormContainer/ScrollContainer/ActivityEntries


func _ready() -> void:
	save_button.connect("pressed", self, "_on_save_task_pressed")
	delete_button.connect("pressed", self, "_on_delete_task_pressed")
	activity_save.connect("pressed", self, "_on_activity_save_pressed")

func set_task(task: Task) -> void:
	_task = task
	task_id_label.text = "Task #%s" % task.id
	name_field.text = task.name
	desc_field.text = task.description
	_load_activity_entries()

func _on_delete_task_pressed() -> void:
	var stage = _task.stage()
	stage.remove_task(_task)
	stage.project().save()
	print("[EMIT] ui_deleted_stage_task")
	Events.emit_signal("ui_deleted_stage_task", stage)
	visible = false

func _on_save_task_pressed() -> void:
	_task.name = $PanelBorder/VLayout/BodyContainer/Padding/Rows/NameFields/NameEdit.text
	_task.description = $PanelBorder/VLayout/BodyContainer/Padding/Rows/DescFields/DescEdit.text
	print("[EMIT] ui_updated_task")
	Events.emit_signal("ui_updated_task", _task)

func _on_activity_save_pressed() -> void:
	var activity = _task.new_activity_entry()
	activity.text = activity_field.text
	activity_field.text = ""
	print("[EMIT] ui_added_task_activity")
	Events.emit_signal("ui_added_task_activity", activity)
	_add_activity_row(activity)

func _add_activity_row(activity: ActivityEntry) -> void:
	var activity_entry_panel = activity_entry_scene.instance()
	activity_entry_panel.set_activity_entry(activity)
	activity_entry_rows.add_child(activity_entry_panel)

func _load_activity_entries():
	print("Loading %s task activities" % len(_task.activity_entries))
	for activity in _task.activity_entries:
		_add_activity_row(activity)
