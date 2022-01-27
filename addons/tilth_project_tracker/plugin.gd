tool
extends EditorPlugin

#const MainPanel = preload("res://addons/tilth_project_tracker/main_scene.tscn")
const ProjectList = preload("res://addons/tilth_project_tracker/tilth/scenes/project/project_board.tscn")

#var main_panel_instance: Control
var project_list_instance: Control


const Singletons = {
	"Events": "res://addons/tilth_project_tracker/tilth/auto_loads/events.gd",
	"AppSettings":"res://addons/tilth_project_tracker/tilth/auto_loads/app_settings.gd",
	"SceneChanger":"res://addons/tilth_project_tracker/tilth/auto_loads/scene_changer.gd",
	"Backup":"res://addons/tilth_project_tracker/tilth/auto_loads/backup.gd",
}

func _enter_tree() -> void:
	auto_loads("add")
	project_list_instance = ProjectList.instance()
	var project_repo = ResourceRepository.new()
	project_repo.init("Project", AppSettings.resource_store_path)
	var projects = project_repo.load_all_resources(true) # skip cache
	project_list_instance.set_project(projects[0])
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_viewport().add_child(project_list_instance)
	# Hide the main panel. Very much required.
	make_visible(false)


func _exit_tree() -> void:
	auto_loads("remove")
	if project_list_instance:
		project_list_instance.queue_free()

func has_main_screen():
	return true


func make_visible(visible):
	if project_list_instance:
		project_list_instance.visible = visible


func get_plugin_name():
	return "Project Tracker"


func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")


func auto_loads(add_or_remove: String) -> void:

	if add_or_remove.to_lower() == "add":
		for autoload_name in Singletons:
			add_autoload_singleton(autoload_name, Singletons[autoload_name])
	else:
		for autoload_name in Singletons:
			remove_autoload_singleton(autoload_name)



