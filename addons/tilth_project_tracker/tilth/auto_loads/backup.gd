tool

extends Node

var _timer:Timer

var _mutated_projects_in_this_period: Array = []
var backup_dir_path: String setget set_backup_dir_path, get_backup_dir_path
var _max_number_backup_files: int = 20

var _safe_file_name = RegEx.new()
var ensure_dir = Directory.new()

func _ready() -> void:
    set_backup_dir_path(AppSettings.resource_store_path.plus_file("_backups"))
    Events.connect("project_state_changed", self, "_on_project_state_changed")
    Events.connect("app_settings_changed", self, "_on_app_settings_changed")

func set_backup_dir_path(path: String) -> void:
    if not ensure_dir.dir_exists(path):
        print("back up dir did not exist, creating dir: " + path)
        ensure_dir.make_dir_recursive(path)
    print("Updated backup dir path to: " + path)
    backup_dir_path = path

func _on_app_settings_changed() -> void:
    set_backup_dir_path(AppSettings.resource_store_path.plus_file("_backups"))

func get_backup_dir_path() -> String:
    return backup_dir_path

func start_backup_timer(frequency_in_sec: int) -> void:
    print("Starting backup timer with %s sec frequency" % frequency_in_sec)
    _timer = Timer.new()
    add_child(_timer)
    _timer.connect("timeout", self, "_on_backup_period_elapsed")
    _timer.set_wait_time(frequency_in_sec)
    _timer.set_one_shot(false)
    _timer.start()

func _on_project_state_changed(project: Project) -> void:
    var _index = _mutated_projects_in_this_period.find(project)
    if _index != -1:
        _mutated_projects_in_this_period.remove(_index)
    _mutated_projects_in_this_period.append(project)


func _on_backup_period_elapsed() -> void:
    """
    Tilth Studio
    └── backups
        └── next_game
            └── 2021-12-25T21.04.17
                └── save_project-61b1f407-ddc4-4dec-950b-d1b5260b7e15.tres
    """
    print("Backup period elapsed")
    if _mutated_projects_in_this_period:
        var copier = Directory.new()
        for project in _mutated_projects_in_this_period:
            var backup_path = _backup_project(project, copier)
            print("Project %s backed up to %s" % [project.name, backup_path])
        _mutated_projects_in_this_period = []

func _backup_project(project: Project, copier: Directory) -> String:
    print("%s state changed, running backup" % project)
    var safe_project_name = _file_safe_name(project.name)
    var datetime_folder_name = DateTime.get_datetime_file_path_string()
    var project_file_path = project.get_save_file_path()
    var dest_dir_path = "%s/%s/%s" % [
        backup_dir_path,
        safe_project_name,
        datetime_folder_name
    ]
    copier.make_dir_recursive(dest_dir_path)
    var dest_file_path = "%s/%s" % [dest_dir_path, project_file_path.get_file()]
    var result = copier.copy(project_file_path, dest_file_path)
    if result != OK:
        print("[ERROR] Copy failed: %s to %s. Code: %s" % [project_file_path, dest_file_path, result])
        return ""
    return dest_file_path

func _file_safe_name(name: String) -> String:
    _safe_file_name.compile("\\W")
    return _safe_file_name.sub(name, "_", true)




