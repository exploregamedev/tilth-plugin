tool

extends WindowDialog

var _project_list_scene_path: String = "res://addons/tilth_project_tracker/tilth/scenes/project/projects_list.tscn"
var _former_projects_persist_dir: String

onready var _data_path_button: Button = $PaneBorder/VBoxLayout/BodyContainer/Padding/VLayout/VBoxContainer2/BrowseButton
onready var _data_path_value: Label = $PaneBorder/VBoxLayout/BodyContainer/Padding/VLayout/VBoxContainer2/PanelContainer/Padding/DataPathValue
onready var _data_path_file_dialog: FileDialog = $DataPathFileDialog
onready var _confirm_copy_project: AcceptDialog = $ConfirmCopyProjects
onready var _theme_items_list: OptionButton = $PaneBorder/VBoxLayout/BodyContainer/Padding/VLayout/ThemeVBoxContainer/PanelContainer/Paddings/ThemeOptions

var _file_dialog_size := Vector2(800, 600)

func _ready() -> void:
    # @standalone
    $PaneBorder/VBoxLayout/BodyContainer/Padding/VLayout/ThemeVBoxContainer.visible = false

    _data_path_button.connect("pressed", self, "_on_browse_data_path_pressed")
    _data_path_file_dialog.connect("dir_selected", self, "_on_data_dir_selected")

    _confirm_copy_project.connect("confirmed", self, "_on_confirm_copy_yes_clicked")
    _confirm_copy_project.connect("custom_action", self, "_on_confirm_copy_no_clicked")

    _data_path_file_dialog.current_path = AppSettings.resource_store_path
    _data_path_value.text = AppSettings.resource_store_path

    _theme_items_list.connect("item_selected", self, "_on_theme_selected")
    for theme_name in AppSettings.get_themes_list(): # returns active theme at index 0
        _theme_items_list.add_item(theme_name.capitalize())
    _theme_items_list.select(0)

func _on_browse_data_path_pressed() -> void:
    _data_path_file_dialog.popup_centered_minsize(_file_dialog_size)

func _on_data_dir_selected(dir_path: String) -> void:
    if dir_path != AppSettings.resource_store_path:
        _former_projects_persist_dir = AppSettings.resource_store_path
        AppSettings.resource_store_path = dir_path
        # don't allow close of window without making choise
        _confirm_copy_project.get_close_button().visible = false
        _confirm_copy_project.add_button("No", false, "no")
        _confirm_copy_project.get_ok().text = "Yes"
        _confirm_copy_project.popup_centered()
        _data_path_value.text = dir_path

func _on_confirm_copy_yes_clicked() -> void:
    Files.copy_dir_contents(_former_projects_persist_dir, AppSettings.resource_store_path)

func _on_confirm_copy_no_clicked(action: String) -> void:
    # No was clicked, do not copy projects to new folder
    pass

func _on_theme_selected(index: int) -> void:
    AppSettings.current_theme = _theme_items_list.get_item_text(index).to_lower()

