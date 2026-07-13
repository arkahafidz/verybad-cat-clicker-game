# ClickableSprite.gd
extends Sprite2D

@export var wobble_strength : float = 0.5
@export var wobble_duration : float = 0.4

# Mengambil nilai dasar koin per klik secara dinamis dari cpc globalvar
var base_coin_per_click : int:
	get: return globalvar.cpc

var click_sound = preload("res://game/assets/46268990-funny-cat-meow-246012.mp3") 
var font_ui = preload("res://game/assets/GochiHand-Regular.ttf")

var combo_streak : int = 0
var current_multiplier : int = 1
var combo_timer : SceneTreeTimer = null

@onready var base_scale : Vector2 = Vector2(0.606, 0.606)
@onready var ui_base_scale : Vector2 = Vector2(1.0, 1.0) 

@onready var cointxt : Label = get_tree().current_scene.get_node_or_null("CanvasLayer/CoinsTXT") 
@onready var ui_layer : Node = get_tree().current_scene.get_node_or_null("UI")
@onready var frenzy_txt : Label = get_tree().current_scene.get_node_or_null("CanvasLayer/FrenzyTXT")

func _ready() -> void:
	# Membuat dan mengonfigurasi timer internal untuk memicu fungsi autoclicker setiap detik
	var auto_timer = Timer.new()
	auto_timer.wait_time = 1.0
	auto_timer.autostart = true
	auto_timer.timeout.connect(_on_autoclick_timeout)
	add_child(auto_timer)

func _input(event: InputEvent) -> void:
	# Memproses input klik kiri mouse hanya jika sprite kucing sedang aktif terlihat di layar
	if not is_visible_in_tree(): return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_rect().has_point(to_local(event.position)):
			trigger_click_effect(event.position)

func trigger_click_effect(click_pos: Vector2) -> void:
	# Memicu seluruh efek game mulai dari data koin, audio, animasi sprite, hingga UI koin
	update_combo_multiplier()
	
	var total_gain = base_coin_per_click * current_multiplier
	globalvar.add_coins(total_gain)
	play_click_audio()
	
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var target_squash = Vector2(base_scale.x + wobble_strength, base_scale.y - wobble_strength)
	tween.tween_property(self, "scale", target_squash, wobble_duration * 0.2)
	tween.tween_property(self, "scale", base_scale, wobble_duration * 0.8)
	
	_update_coin_ui()
	spawn_floating_text(click_pos, total_gain)
	
	# Memicu fungsi save data di globalvar setiap kali pemain sukses mengeklik kucing
	globalvar.save_game()

func _on_autoclick_timeout() -> void:
	# Menambahkan koin secara pasif berdasarkan status level autoclick saat ini tanpa memengaruhi combo multiplier
	if "autoclick" in globalvar and globalvar.autoclick > 0:
		var passive_gain = globalvar.autoclick
		globalvar.add_coins(passive_gain)
		
		_update_coin_ui()
		# Memunculkan teks melayang tepat di posisi tengah sprite kucing
		spawn_floating_text(global_position, passive_gain)

func _update_coin_ui() -> void:
	# Memperbarui tampilan teks koin utama di UI berdasarkan data terbaru
	if cointxt and "coins" in globalvar:
		cointxt.text = str(globalvar.coins)

func update_combo_multiplier() -> void:
	# Mengatur kenaikan multiplier secara eksponensial berdasarkan intensitas klik dan memperbarui UI Frenzy
	combo_streak += 1
	
	if combo_streak >= 25:
		current_multiplier = 10
	elif combo_streak >= 12:
		current_multiplier = 6
	elif combo_streak >= 6:
		current_multiplier = 4
	elif combo_streak >= 3:
		current_multiplier = 2
	else:
		current_multiplier = 1
		
	if frenzy_txt and current_multiplier > 1:
		frenzy_txt.start_frenzy_countdown(1.2, current_multiplier)
		
	if combo_timer:
		combo_timer.timeout.disconnect(reset_combo)
		
	combo_timer = get_tree().create_timer(1.2) 
	combo_timer.timeout.connect(reset_combo)

func reset_combo() -> void:
	# Mengembalikan nilai combo streak dan multiplier kembali ke awal (1x) saat pemain berhenti klik
	combo_streak = 0
	current_multiplier = 1

func play_click_audio() -> void:
	# Membuat instansiasi AudioStreamPlayer baru agar suara klik tidak terputus saat di-spam
	if click_sound:
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = click_sound
		add_child(audio_player) 
		audio_player.play()
		audio_player.finished.connect(audio_player.queue_free)

func spawn_floating_text(pos: Vector2, amount: int) -> void:
	# Membuat objek label teks angka melayang berdasarkan jumlah pendapatan koin asli
	var label = Label.new()
	label.text = "+" + str(amount)
	
	if current_multiplier >= 4 and is_visible_in_tree():
		label.add_theme_color_override("font_color", Color.GOLD)
		label.text += " (" + str(current_multiplier) + "x!)"
	else:
		label.add_theme_color_override("font_color", Color.BLACK)
		
	label.z_index = 100
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_font_override("font", font_ui)
	
	if ui_layer:
		ui_layer.add_child(label)
		ui_layer.move_child(label, -1) 
		label.global_position = pos - Vector2(10, 15)
	else:
		get_tree().current_scene.add_child(label)
		label.position = pos - Vector2(20, 20)
	
	var text_tween = create_tween().set_parallel(true)
	text_tween.tween_property(label, "position:y", label.position.y - 150, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	text_tween.tween_property(label, "modulate:a", 0.0, 2.0)
	text_tween.chain().tween_callback(label.queue_free)
