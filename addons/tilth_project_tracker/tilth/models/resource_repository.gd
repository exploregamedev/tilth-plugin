tool

extends Resource
class_name ResourceRepository

"""
There is an open issue with using res:// for custom
resources.  The Inspector will revert to old values
https://github.com/godotengine/godot/issues/24646
"""

var persist_dir: Directory
var persist_dir_path: String setget , get_persist_path
var _model_name: String

const SAVE_NAME_PREFIX := "save-"
const SAVE_NAME_TEMPLATE := "%s{identifier}.tres" % SAVE_NAME_PREFIX

# initialize this class (Godot doesn't have constructors)
func init(model_name: String) -> void:
    _model_name = model_name.to_lower()
    persist_dir_path =  AppSettings.resource_store_path.plus_file("_datastore")
    persist_dir = Directory.new()
    print("Resource [%s] persist dir: %s" % [_model_name, persist_dir_path])
    if not persist_dir.dir_exists(persist_dir_path):
        persist_dir.make_dir_recursive(persist_dir_path)

func get_persist_path() -> String:
    return persist_dir_path

"""
Save and load insired by https://www.youtube.com/watch?v=ML-hiNytIqE
"""
func save_resource(resource: Resource):
    print("saving %s %s" % [_model_name, resource.id])
    var save_path = _get_file_path(resource.id)
    var result: int = ResourceSaver.save(save_path, resource)
    if result != OK:
        print("There was an error writing the save %s to %s" % [resource.id, save_path])
    print("[EMIT] %s_saved" % _model_name)
    Events.emit_signal(_model_name + "_saved", resource)

func delete_resource(identifier: String):
    var file_path = _get_file_path(identifier)
    var file := File.new()
    if not file.file_exists(file_path):
        print("File for Resource to delete not found: %s" % file_path)
        return
    var dir = Directory.new()
    dir.remove(file_path)
    print("deleted file: %s" % file_path)
    print("[EMIT] %s_deleted" % _model_name)
    Events.emit_signal("%s_deleted" % _model_name, identifier)

"""
Save and load insired by https://www.youtube.com/watch?v=ML-hiNytIqE
"""
func load_resource(identifier: String, skip_cache: bool = false) -> Resource:
    print("loading Project %s" % identifier)
    var save_path = _get_file_path(identifier)
    return load_from_file(save_path)

func load_from_file(file_path: String, skip_cache: bool = false) -> Resource:
    var file := File.new()
    if not file.file_exists(file_path):
        print("Save file path %s does not exist")
        return null
    var resource: Resource = ResourceLoader.load(file_path, "", skip_cache)
    print("[EMIT] %s_loaded" % _model_name)
    Events.emit_signal("%s_loaded" % _model_name, resource)
    print("loaded Resource %s" % resource)
    return resource

func load_all_resources(skip_cache: bool = false) -> Array:
    var resources = []
    persist_dir.open(persist_dir_path)
    persist_dir.list_dir_begin()
    while true:
        var file: String = persist_dir.get_next()
        if file == "":
            break
        elif file.begins_with(SAVE_NAME_PREFIX):
            var resource_path = persist_dir_path.plus_file(file)
            print("Found %s file: %s" % [_model_name, resource_path])
            var resource: Resource = ResourceLoader.load(resource_path, "", skip_cache)
            if resource == null:
                print("Unable to load %s at path: %s" % [_model_name, resource_path])
            else:
                resources.append(resource)
    persist_dir.list_dir_end()
    return resources

func _get_file_path(identifier: String) -> String:
    var save_filename: String = SAVE_NAME_TEMPLATE.replace("{identifier}", identifier)
    return persist_dir_path.plus_file(save_filename)
