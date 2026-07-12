extends Control

@onready var home_page : Control = $home
@onready var upg_page : Control = $upg

@onready var home_btn : Button = $"../Home"
@onready var upg_btn : Button = $"../Upg"

var clicksfx = preload("res://game/assets/denielcz-immersivecontrol-button-click-sound-463065.mp3")

func playclicksfx() -> void:
	if clicksfx:
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = clicksfx
		add_child(audio_player) 
		audio_player.play()
		audio_player.finished.connect(audio_player.queue_free)

func _ready() -> void:
	home_btn.pressed.connect(show_home)
	upg_btn.pressed.connect(show_upgrade)
	show_home()

func show_home() -> void:
	home_page.visible = true
	upg_page.visible = false
	playclicksfx()

func show_upgrade() -> void:
	home_page.visible = false
	upg_page.visible = true
	playclicksfx()
	
	if upg_page.has_method("update_upgrade_ui"):
		upg_page.update_upgrade_ui()
