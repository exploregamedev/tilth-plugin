tool

extends PanelContainer


var _stage: Stage setget set_stage

#@virtual
func get_drag_data(position: Vector2) -> Stage:
	var drag_placeholder = ColorRect.new()
	drag_placeholder.color =  Color(.75, .75, .75, .75)
	drag_placeholder.rect_size = Vector2(50, 100)
	set_drag_preview(drag_placeholder)
	return _stage

func set_stage(stage: Stage) -> void:
	_stage = stage
