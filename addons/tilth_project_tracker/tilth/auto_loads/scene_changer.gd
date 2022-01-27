tool

extends EditorPlugin

onready var animation_player = $AnimationPlayer
onready var black = $Control/ColorRect

func change_scene(path: String, delay: float = 0.5):
#	if delay > 0.0:
#		yield(get_tree().create_timer(delay), "timeout")
#	animation_player.play("Fade")
#	yield(animation_player, "animation_finished")
	print("Changing to scene at path: ", path)
#	get_tree().change_scene(path)
	var new_scene = load(path).instance()
#	get_editor_interface().get_editor_viewport().remove_child(root_to_remove)
	get_editor_interface().get_editor_viewport().add_child(new_scene)
#	animation_player.play_backwards("Fade")
#	yield(animation_player,"animation_finished")
#	print("[EMIT] scene_changed")
#	Events.emit_signal("scene_changed")

func change_scene_to_instance(root_to_remove, new_scene_instance, delay: float = 0.5):
	print("root_to_remove: %s" % root_to_remove)
	get_editor_interface().get_editor_viewport().remove_child(root_to_remove)
	get_editor_interface().get_editor_viewport().add_child(new_scene_instance)
	# @TODO fix animation player , not able to find when starting up
#	if delay > 0.0:
#		yield(get_tree().create_timer(delay), "timeout")
#	animation_player.play("Fade")
#	yield(animation_player, "animation_finished")
	# remove the current scene
#	get_tree().root.remove_child(root_to_remove)
#	root_to_remove.call_deferred("free")
	# Add the next scene
#	get_tree().root.add_child(new_scene_instance)
	# reveal the new scene
#	animation_player.play_backwards("Fade")
#	yield(animation_player,"animation_finished")
#	print("[EMIT] scene_changed")
#	Events.emit_signal("scene_changed")



