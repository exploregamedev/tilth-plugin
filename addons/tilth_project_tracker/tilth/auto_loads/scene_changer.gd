tool

extends Node

var plugin: EditorPlugin setget set_plugin


func set_plugin(editor_plugin: EditorPlugin) -> void:
	plugin = editor_plugin

func change_scene(path: String, delay: float = 0.5):
	print("Changing to scene at path: ", path)
	var new_scene = load(path).instance()
#	get_editor_interface().get_editor_viewport().remove_child(root_to_remove)
	plugin.get_editor_interface().get_editor_viewport().add_child(new_scene)

func change_scene_to_instance(root_to_remove, new_scene_instance, delay: float = 0.5):
	print("root_to_remove: %s" % root_to_remove)
	plugin.get_editor_interface().get_editor_viewport().remove_child(root_to_remove)
	plugin.get_editor_interface().get_editor_viewport().add_child(new_scene_instance)
