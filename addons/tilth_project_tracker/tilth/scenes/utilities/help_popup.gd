tool

extends PopupPanel


func _ready() -> void:
	$Padding/Text.connect("meta_clicked", self, "_on_meta_clicked")


func _on_meta_clicked(meta):
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at run-time.
	OS.shell_open(str(meta))
