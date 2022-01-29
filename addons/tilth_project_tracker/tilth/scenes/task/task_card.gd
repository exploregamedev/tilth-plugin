tool

extends PanelContainer
class_name TaskCard

export(int) var detail_window_width = 1000
export(int) var detail_window_height = 1000

var _task: Task setget set_task, get_task
onready var edit_button: Button = $VBoxContainer/HeaderPanelContainer/Padding/HLayout/EditButton
onready var task_detail_popup: Popup = $TaskDetail

var _task_detail_has_been_built: bool = false

#@virtual
func _ready() -> void:
	Events.connect("ui_deleted_task", self, "_on_ui_deleted_task")
	Events.connect("ui_updated_task", self, "_on_ui_updated_task")
	edit_button.connect("pressed", self, "_on_edit_task_pressed")


func set_task(task: Task) -> void:
	_task = task
	_update_task_ui()

func get_task() -> Task:
	return _task

func _on_ui_deleted_task(task: Task) -> void:
	if task.id == _task.id:
		queue_free()

func _on_ui_updated_task(task: Task) -> void:
	if task.id == _task.id:
		_task = task
		_update_task_ui()

func _on_edit_task_pressed() -> void:
	task_detail_popup.popup_centered_minsize(Vector2(detail_window_width, detail_window_height))
	if not _task_detail_has_been_built:
		task_detail_popup.set_task(_task)
	_task_detail_has_been_built = true

func _update_task_ui():
	$VBoxContainer/HeaderPanelContainer/Padding/HLayout/TitleLabel.text = _task.name
	$VBoxContainer/HeaderPanelContainer/Padding/HLayout/IdLabel.text = "#%s" % _task.id
	$VBoxContainer/PanelContainer/Padding/ScrollContainer/DescLabel.text = _task.description

#@virtual
func get_drag_data(position: Vector2) -> PanelContainer:
	var drag_placeholder = ColorRect.new()
	drag_placeholder.color =  Color(.75, .75, .75, .75)
	drag_placeholder.rect_size = Vector2(50, 50)
	set_drag_preview(drag_placeholder)
	return self
