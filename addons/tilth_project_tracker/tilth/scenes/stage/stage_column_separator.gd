tool

extends ColorRect

var parent_project: Project setget set_parent_project
var stage_before: Stage setget set_stage_before
var stage_after: Stage setget set_stage_after
var _default_color: Color = color
var _highlight_color = Color("#dcedc8")

func _ready() -> void:
	connect("mouse_exited", self, "_on_mouse_exited")

#@virtual
func can_drop_data(position: Vector2, stage: Stage) -> bool:
	if not stage or not stage is Stage:
		return false
	if stage_before and stage.id == stage_before.id:
		return false
	if stage_after and stage.id == stage_after.id:
		return false
	color = _highlight_color
	return true

#@virtual
func drop_data(position: Vector2, dropped_stage: Stage) -> void:
	if dropped_stage:
		print("%s was dropped after %s and before %s" %
		[dropped_stage, stage_before, stage_after])
		parent_project.reorder_stages(dropped_stage, stage_before, stage_after)
		parent_project.save()
		print("[EMIT] ui_reorded_project_stages(%s)" % parent_project)
		Events.emit_signal("ui_reorded_project_stages", parent_project)

func set_parent_project(project: Project) -> void:
	parent_project = project

func set_stage_before(stage: Stage) -> void:
	stage_before = stage

func set_stage_after(stage: Stage) -> void:
	stage_after = stage

func _on_mouse_exited() -> void:
	color = _default_color
