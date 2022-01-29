tool
extends EditorPlugin

const ProjectBoard = preload("res://addons/tilth_project_tracker/tilth/scenes/project/project_board.tscn")


var project_board_instance: Control


const Singletons = {
    "Events": "res://addons/tilth_project_tracker/tilth/auto_loads/events.gd",
    "AppSettings":"res://addons/tilth_project_tracker/tilth/auto_loads/app_settings.gd",
    # @todo Backup disabled see: #15 : https://github.com/exploregamedev/tilth-plugin/issues/15
    # "Backup":"res://addons/tilth_project_tracker/tilth/auto_loads/backup.gd",
}

func _enter_tree() -> void:
    auto_loads("add")
    project_board_instance = ProjectBoard.instance()
    project_board_instance.app_version = _get_plugin_version()
    # Add the main panel to the editor's main viewport.
    get_editor_interface().get_editor_viewport().add_child(project_board_instance)
    # Hide the main panel. Very much required.
    make_visible(false)


func _exit_tree() -> void:
    auto_loads("remove")
    if project_board_instance:
        project_board_instance.queue_free()

func has_main_screen():
    return true


func make_visible(visible):
    if project_board_instance:
        project_board_instance.visible = visible


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

func _get_plugin_version() -> String:
    var _version_number = ""
    var config = ConfigFile.new()
    var read_result = config.load("res://addons/tilth_project_tracker/plugin.cfg")
    if read_result == OK:
        _version_number = config.get_value("plugin", "version")
    return _version_number
