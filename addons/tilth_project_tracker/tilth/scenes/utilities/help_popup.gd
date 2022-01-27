tool

extends PopupPanel


func _ready() -> void:
	$VLayout/BodyPanel/Padding/VLayout/Description.connect("meta_clicked", self, "_on_meta_clicked")


func _on_meta_clicked(meta):
	OS.shell_open(str(meta))
