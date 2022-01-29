tool

extends ColorRect

var parent_stage: Stage setget set_parent_stage
var task_above: Task setget set_task_above
var task_below: Task setget set_task_below
var _default_color: Color = color
var _highlight_color = Color("#dcedc8")

func _ready() -> void:
    connect("mouse_exited", self, "_on_mouse_exited")

#@virtual
func can_drop_data(position: Vector2, task_panel: TaskCard) -> bool:
    if not task_panel or not task_panel is TaskCard:
        return false
    var hovering_task = task_panel.get_task()
    if task_above and hovering_task.id == task_above.id:
        return false
    if task_below and hovering_task.id == task_below.id:
        return false
    color = _highlight_color
    return true

#@virtual
func drop_data(_position: Vector2, task_card: TaskCard) -> void:
    if task_card:
        var dropped_task = task_card.get_task()
        var origin_stage = dropped_task.stage()
        print("%s from %s was dropped on %s between %s and %s" %
        [dropped_task, origin_stage, parent_stage, task_above, task_below])
        var project = parent_stage.project()
        if origin_stage == parent_stage:
            parent_stage.reorder_tasks(dropped_task, task_above, task_below)
            project.save()
            print("[EMIT] ui_reorded_stage_tasks(%s)" % parent_stage)
            Events.emit_signal("ui_reorded_stage_tasks", parent_stage)
        else:
            parent_stage.reorder_tasks(dropped_task, task_above, task_below)
            origin_stage.remove_task(dropped_task)
            project.save()
            print("[EMIT] ui_reorded_stage_tasks(%s)" % parent_stage)
            Events.emit_signal("ui_reorded_stage_tasks", parent_stage)
            print("[EMIT] ui_reorded_stage_tasks(%s)" % origin_stage)
            Events.emit_signal("ui_reorded_stage_tasks", origin_stage)

func set_parent_stage(stage: Stage) -> void:
    parent_stage = stage

func set_task_above(task: Task) -> void:
    task_above = task

func set_task_below(task: Task) -> void:
    task_below = task

func _on_mouse_exited() -> void:
    color = _default_color
