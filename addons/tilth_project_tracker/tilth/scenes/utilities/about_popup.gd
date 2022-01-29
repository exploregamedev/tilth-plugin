tool

extends PopupPanel


func _ready() -> void:
	var app_version = AppSettings.app_version
	$VLayout/HeaderPanel/Padding/HLayout/VersionLabel.text = app_version
	$VLayout/BodyPanel/Padding/VLayout/MoreDetailsLink.connect("meta_clicked", self, "_on_meta_clicked")
	$VLayout/BodyPanel/Padding/VLayout/Developer.connect("meta_clicked", self, "_on_meta_clicked")


func _on_meta_clicked(meta):
	OS.shell_open(str(meta))
