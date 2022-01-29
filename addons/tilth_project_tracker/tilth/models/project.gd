tool

extends Resource
class_name Project
# https://github.com/godotengine/godot/issues/21789
const classname = "Project"

# Only **exported** attributes are saved to .tres file
export(String) var id
export(String) var name := ""
export(String) var description := ""
export(int) var create_timestamp: int
export(int) var start_timestamp: int
export(int) var completed_timestamp: int
export var next_task_id: int = 0

"""
If use export(Array, Task) get: 'The export hint isnt a resource type'
https://github.com/godotengine/godot-proposals/issues/18
"""
export(Array, Resource) var stages

var _repository: ResourceRepository


func _init() -> void:
	if not _repository:
		_repository = ResourceRepository.new()
		_repository.init("Project")

"""
Note: id and create_date are set on Project.save()
"""
func save():
	if not id:
		id = Uuid.v4()
		create_timestamp = OS.get_unix_time()
		_repository.save_resource(self)
		print("[EMIT] project_created")
		Events.emit_signal("project_created", self)
	else:
		_repository.save_resource(self)
		print("[EMIT] project_state_changed")
		Events.emit_signal("project_state_changed", self)

func _to_string() -> String:
	return "Project[%s]" % id

func new_stage() -> Stage:
	var stage := Stage.new()
	stage.set_parent_project(self)
	stage.id = Uuid.v4()
	stage.create_timestamp = OS.get_unix_time()
	stages.append(stage)
	print("New %s added to %s" % [stage, self])
	return stage

func remove_stage(stage_to_remove: Stage) -> void:
	for stage in stages:
		if stage.id == stage_to_remove.id:
			stages.erase(stage_to_remove)
			print("Deleted %s" % stage)
			break

func delete():
	_repository.delete_resource(id)

func reorder_stages(item_to_move: Stage, add_after: Stage, add_before: Stage):
	stages.erase(item_to_move)
	if add_after:
		var target = stages.find(add_after)
		stages.insert(target+1, item_to_move)
	elif add_before:
		var target = stages.find(add_before)
		stages.insert(target, item_to_move)

func next_task_id() -> int:
	next_task_id += 1
	return next_task_id

# used by Backup
func get_save_file_path() -> String:
	return _repository._get_file_path(id)
