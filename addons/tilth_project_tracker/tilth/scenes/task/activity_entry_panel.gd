tool

extends PanelContainer


var _activity_entry: ActivityEntry


func set_activity_entry(activity: ActivityEntry) -> void:
    _activity_entry = activity
    _update_ui()

func _update_ui() -> void:
    var datetime = DateTime.str_from_timestamp(_activity_entry.create_timestamp)
    $Padding/ActivityContainer/When.text = datetime
    $Padding/ActivityContainer/Copy.text = _activity_entry.text
