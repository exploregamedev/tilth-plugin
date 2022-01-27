tool

extends PanelContainer

var _project: Project
var _stage_scene: PackedScene = preload("res://addons/tilth_project_tracker/tilth/scenes/stage/stage_column.tscn")
var _stage_separator: PackedScene = preload("res://addons/tilth_project_tracker/tilth/scenes/stage/stage_column_separator.tscn")
onready var stage_columns: HBoxContainer = $VLayout/Scroll/Padding/StageColumns

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if not event.pressed:
				print("Left button was released")
				Events.emit_signal("mouse_drag_ended")

func _ready() -> void:
	print("Project board: _ready()")
	set_theme(AppSettings.get_current_theme_resource())
	# @Standalone
#	OS.set_window_title("%s - %s" %
#		[ProjectSettings.get_setting("application/config/name"),
#		 ProjectSettings.get_setting("application/config/version")])
	Events.connect("ui_added_stage", self, "_on_ui_added_stage")
	Events.connect("ui_deleted_stage", self, "_on_ui_deleted_stage")
	Events.connect("ui_updated_task", self, "_on_ui_updated_task")
	Events.connect("ui_added_task_activity", self, "_on_ui_added_task_activity")
	Events.connect("ui_reorded_project_stages", self, "_on_ui_reorded_project_stages")
	Events.connect("app_settings_changed", self, "_on_app_settings_changed")
	Backup.start_backup_timer(60)
	_reload_board()

func set_project(project: Project) -> void:
	_project = project

func _load_stages(project: Project) -> void:
	"""
	Build a column for each project stage
	In each stage, add its tasks
	"""
	print("stage_columns: %s" % stage_columns)
	stage_columns.add_child(_get_stage_seperator(null, project.stages[0]))
	var stages = project.stages
	print("Project has %s stages" % len(stages))
	for i in len(stages):
		stages[i] = (stages[i] as Stage)
		print("loading stage %s" % stages[i])
		stages[i].set_parent_project(project)
		var stage_panel = _add_stage_panel(stages[i])
		if i == len(stages)-1: # last stage
			stage_columns.add_child(_get_stage_seperator(stages[i], null))
		else:
			stage_columns.add_child(_get_stage_seperator(stages[i], stages[i+1]))
	print("Number of children on stage_columns: %s" % stage_columns.get_child_count())

func _add_stage_panel(stage: Stage) -> PanelContainer:
	var stage_panel = _stage_scene.instance()
	stage_panel.stage = stage
	stage_columns.add_child(stage_panel)
	return stage_panel

func _on_ui_added_stage(stage) -> void:
	_project.save()
	var stage_panel = _add_stage_panel(stage)
	stage_columns.add_child(_get_stage_seperator(stage_panel, null))

func _on_ui_deleted_stage(stage) -> void:
	_project.remove_stage(stage)
	_project.save()
	_reload_board()

func _on_ui_updated_task(_task: Task):
	_project.save()

func _on_ui_added_task_activity(activity: ActivityEntry) -> void:
	_project.save()

func _on_ui_reorded_project_stages(reorded_project: Project) -> void:
	if reorded_project.id == _project.id:
		print("[project_board] acting on ui_reorded_project_stages; re-rendering stages")
		_reload_board()

func _reload_board():
	for stage in stage_columns.get_children():
		stage.queue_free()

	if not _project.stages:
		print("not stages found, creating a Backlog Stage")
		var stage = _project.new_stage()
		stage.name = "backlog"
		stage.description = "Stage all new tasks here"
		_project.save()

	_load_stages(_project)


func _get_stage_seperator(before_stage: Stage, after_stage: Stage) -> Control:
	var stage_separator = _stage_separator.instance()
	stage_separator.parent_project = _project
	stage_separator.stage_before = before_stage
	stage_separator.stage_after = after_stage
	return stage_separator

func _on_app_settings_changed():
	set_theme(AppSettings.get_current_theme_resource())
