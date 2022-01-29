tool

extends Resource
class_name Stage

# Only **exported** attributes are saved to .tres file
export(String) var id
export var name := ""
export var description := ""
export var create_timestamp: int

var _project: Resource  setget set_parent_project, project

"""
If use export(Array, Task) get: "The export hint isnt a resource type"
https://github.com/godotengine/godot-proposals/issues/18
"""
export(Array, Resource) var tasks

func new_task() -> Task:
    var task := Task.new()
    task.set_parent_stage(self)
    task.id = _project.next_task_id()
    task.create_timestamp = OS.get_unix_time()
    tasks.append(task)
    print("%s added to %s" % [task, self])
    return task

func reorder_tasks(item_to_move: Task, add_after: Task, add_before: Task):
    print("Reorded stage tasks")
    if not tasks:
        tasks.append(item_to_move)
        return
    tasks.erase(item_to_move)
    if add_after:
        var target = tasks.find(add_after)
        tasks.insert(target+1, item_to_move)
    elif add_before:
        var target = tasks.find(add_before)
        tasks.insert(target, item_to_move)

func _to_string() -> String:
    return "Stage[%s]" % id

func set_parent_project(project: Resource) -> void:
    _project = project

func project() -> Resource:
    return _project

func add_task(task: Task):
    if not task in tasks:
        tasks.append(task)

func remove_task(task_to_remove: Task) -> void:
    for task in tasks:
        if task.id == task_to_remove.id:
            tasks.erase(task_to_remove)
            print("Deleted task %s" % task)
            break
