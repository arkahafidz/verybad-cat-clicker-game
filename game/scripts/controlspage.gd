 extends Control

@onready var home_page : Control = $home
@onready var upg_page : Control = $upg

@onready var home_btn : Button = $"../Home"
@onready var upg_btn : Button = $"../Upg"

func _ready() -> void:
	home_btn.pressed.connect(show_home)
	upg_btn.pressed.connect(show_upgrade)
	show_home()

func show_home() -> void:
	home_page.visible = true
	upg_page.visible = false

func show_upgrade() -> void:
	home_page.visible = false
	upg_page.visible = true
	
	if upg_page.has_method("update_upgrade_ui"):
		upg_page.update_upgrade_ui()
