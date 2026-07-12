# ClickableSprite.gd
extends Sprite2D

@export var wobble_strength : float = 0.05
@export var wobble_duration : float = 0.4
@export var coin_per_click : int = 1

@onready var base_scale : Vector2 = Vector2(0.297, 0.297)

func _input(event: InputEvent) -> void:
	# Mendeteksi klik mouse kiri tepat di dalam area gambar sprite kucing
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_rect().has_point(to_local(event.position)):
			trigger_click_effect(event.position)

func trigger_click_effect(click_pos: Vector2) -> void:
	# Menambahkan koin ke global data dan menjalankan animasi membal (wobble) pada sprite
	globalvar.add_coins(coin_per_click)
	
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var target_squash = Vector2(base_scale.x + wobble_strength, base_scale.y - wobble_strength)
	
	tween.tween_property(self, "scale", target_squash, wobble_duration * 0.2)
	tween.tween_property(self, "scale", base_scale, wobble_duration * 0.8)
	
	spawn_floating_text(click_pos)

func spawn_floating_text(pos: Vector2) -> void:
	# Membuat teks angka melayang dan memaksanya berada di lapisan paling depan di dalam hierarki UI
	var label = Label.new()
	label.text = "+" + str(coin_per_click)
	label.z_index = 100
	label.add_theme_color_override("font_color", Color.BLACK)
	
	var ui_layer = get_tree().current_scene.get_node_or_null("UI")
	if ui_layer:
		ui_layer.add_child(label)
		ui_layer.move_child(label, -1) # BUG FIX: Memaksa label pindah ke urutan paling bawah (paling depan di layar) di dalam UI
		label.global_position = pos - Vector2(10, 15)
	else:
		get_tree().current_scene.add_child(label)
		label.position = pos - Vector2(20, 20)
	
	var lifetime: float = 2.0
	var text_tween = create_tween().set_parallel(true)
	
	text_tween.tween_property(label, "position:y", label.position.y - 150, lifetime).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	text_tween.tween_property(label, "modulate:a", 0.0, lifetime)
	text_tween.chain().tween_callback(label.queue_free)
