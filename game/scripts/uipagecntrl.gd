extends HBoxContainer

@onready var home_page: Control = $"../Control/home"
@onready var upgrade_page: Control = $"../Control/upg"

func _ready() -> void:
	show_page("home")

func show_page(page_name: String) -> void:
	if home_page:
		home_page.visible = (page_name == "home")
	if upgrade_page:
		upgrade_page.visible = (page_name == "upgrade")

func _on_home_ui_pressed() -> void:
	show_page("home")

func _on_upg_ui_pressed() -> void:
	show_page("upgrade")
