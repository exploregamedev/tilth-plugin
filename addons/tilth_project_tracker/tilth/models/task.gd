tool

extends Resource
class_name Task

# Only **exported** attributes are saved to .tres file
export(String) var id
export(String) var name := ""
export(String) var description := ""
export(int) var create_timestamp: int
export(int) var start_timestamp: int
export(int) var completed_timestamp: int
export(int) var estimated_time_in_sec: int
export(int) var points: int

var _parent_stage: Resource setget set_parent_stage,stage

"""
If use export(Array, ActivityEntry) get: "The export hint isnt a resource type"
https://github.com/godotengine/godot-proposals/issues/18
"""
export(Array, Resource) var activity_entries

func new_activity_entry() -> ActivityEntry:
    var activity := ActivityEntry.new()
    activity.set_parent_task(self)
    activity.id = Uuid.v4()
    activity.create_timestamp = OS.get_unix_time()
    activity_entries.append(activity)
    print("%s added to %s" % [activity, self])
    return activity

func _to_string() -> String:
    return "Task[%s]" % id

func set_parent_stage(parent_stage) -> void:
    _parent_stage = parent_stage

func stage() -> Resource:
    return _parent_stage
