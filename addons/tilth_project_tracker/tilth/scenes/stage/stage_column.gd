tool

extends PanelContainer

#var task_scene: PackedScene = preload("res://addons/tilth_project_tracker/tilth/scenes/task/task_card.tscn")
var task_scene: PackedScene = preload("res://addons/tilth_project_tracker/tilth/scenes/task/task_card.tscn")
var _task_separator: PackedScene = preload("res://addons/tilth_project_tracker/tilth/scenes/task/task_separator.tscn")

export(int) var min_column_width = 300

var stage: Stage setget set_stage
onready var task_rows: VBoxContainer = $VLayout/Scroll/Padding/Column/TaskRows
onready var add_task_button: Button = $VLayout/Scroll/Padding/Column/AddTaskContainer/AddTaskButton
onready var add_stage_button: Button = $VLayout/ColumnHeader/Padding/HLayout/AddStageContainer/AddStageButton
onready var save_stage_button: Button = $VLayout/ColumnHeader/Padding/HLayout/SaveStage
onready var delete_stage_button: Button = $VLayout/Scroll/Padding/Column/DeleteStageButton

func _ready() -> void:
	rect_min_size = Vector2(min_column_width,0)
	Events.connect("ui_reorded_stage_tasks", self, "_on_ui_reorded_stage_tasks")
	Events.connect("ui_deleted_stage_task", self, "_on_ui_deleted_stage_task")
	add_task_button.connect("pressed", self, "_on_add_task_pressed")
	add_stage_button.connect("pressed", self, "_on_add_stage_pressed")
	save_stage_button.connect("pressed", self, "_on_save_stage_pressed")
	delete_stage_button.connect("pressed", self, "_on_delete_stage_pressed")
	populate_tasks()

func set_stage(stage_to_add: Stage) -> void:
	stage = stage_to_add
	$VLayout/ColumnHeader.set_stage(stage)
	$VLayout/ColumnHeader/Padding/HLayout/StageTitle.text = stage.name

func populate_tasks():
	for item in task_rows.get_children():
		item.queue_free()
	if not stage.tasks: # drop a taget for tasks drug to this column
		task_rows.add_child(_get_task_seperator(null, null))
	for task_index in len(stage.tasks):
		var task = (stage.tasks[task_index] as Task)
		task.set_parent_stage(stage)
		if task_index == 0: #first task
			task_rows.add_child(_get_task_seperator(null, task))
		_add_task_panel(task)
		if task_index == len(stage.tasks) -1:
			task_rows.add_child(_get_task_seperator(task, null))
		else:
			task_rows.add_child(_get_task_seperator(task, stage.tasks[task_index + 1]))

func _add_task_panel(task: Task) -> void:
	var task_panel = task_scene.instance()
	task_panel.set_task(task)
	task_rows.add_child(task_panel)

func _on_add_task_pressed() -> void:
	var task :Task = stage.new_task()
	task.name = "New Task (#%s)" % task.id
	stage.add_task(task)
	stage.project().save()
	populate_tasks()

func _on_ui_deleted_stage_task(affected_stage: Stage) -> void:
	if affected_stage.id == stage.id:
		print("[stage_column] reacting to ui_deleted_stage_task")
		populate_tasks()

func _on_add_stage_pressed() -> void:
	var new_stage = stage.project().new_stage()
	new_stage.name = "New stage"
	print("[EMIT] ui_added_stage")
	Events.emit_signal("ui_added_stage", new_stage)

func _on_save_stage_pressed() -> void:
	stage.name = $VLayout/ColumnHeader/Padding/HLayout/StageTitle.text
	stage.project().save()

func _on_delete_stage_pressed() -> void:
	print("[EMIT] ui_deleted_stage")
	Events.emit_signal("ui_deleted_stage", stage)
	queue_free()

func _on_ui_reorded_stage_tasks(reordered_stage: Stage) -> void:
	if reordered_stage.id == stage.id:
		print("[stage_column] acting on ui_reorded_stage_tasks; re-rendering tasks")
		populate_tasks()

func _get_task_seperator(above_task: Task, below_task: Task) -> Control:
	var task_separator = _task_separator.instance()
	task_separator.task_above = above_task
	task_separator.task_below = below_task
	task_separator.parent_stage = stage
	return task_separator
