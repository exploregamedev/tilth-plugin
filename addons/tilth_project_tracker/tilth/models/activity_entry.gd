tool

extends Resource
class_name ActivityEntry

# Only **exported** attributes are saved to .tres file
export(String) var id
export(int) var create_timestamp: int
export(String) var text: String

var _task: Resource setget set_parent_task, task

func set_parent_task(task: Resource) -> void:
    _task = task

func task() -> Resource:
    return _task

func _to_string() -> String:
    return "TaskActivity[%s]" % id
