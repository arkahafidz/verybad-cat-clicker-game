# ClickableSprite.gd
extends Sprite2D

@export var wobble_strength : float = 0.2
@export var wobble_duration : float = 0.4
@export var coin_per_click : int = 1

func _input(event: InputEvent) -> void:
	# Cek klik kiri mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Cek apakah klik berada di dalam area gambar Sprite
		if get_rect().has_point(to_local(event.position)):
			trigger_click_effect(event.position)

func trigger_click_effect(click_pos: Vector2) -> void:

	globalvar.add_coins(coin_per_click)
	
	# 2. Efek Wobble pada Sprite
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# Gepengkan sedikit (Squash and Stretch)
	var target_squash = Vector2(1.0 + wobble_strength, 1.0 - wobble_strength)
	tween.tween_property(self, "scale", target_squash, wobble_duration * 0.2)
	# Kembalikan ke skala semula (1, 1) dengan efek membal
	tween.tween_property(self, "scale", Vector2.ONE, wobble_duration * 0.8)
	
	# 3. Munculkan teks "+1" melayang di posisi mouse
	spawn_floating_text(click_pos)

func spawn_floating_text(pos: Vector2) -> void:
	# Membuat node Label baru secara dinamis lewat kode
	var label = Label.new()
	label.text = "+" + str(coin_per_click)
	label.position = pos - Vector2(20, 20) # Sedikit penyesuaian posisi agar pas di tengah mouse
	
	# Mengatur font/warna teks lewat kode (opsional, bisa dikustomisasi)
	label.add_theme_color_override("font_color", Color.YELLOW)
	
	# Masukkan label ke dalam scene tree utama agar terlihat di layar
	get_tree().current_scene.add_child(label)
	
	# Animasi teks melayang ke atas lalu menghilang
	var text_tween = create_tween()
	text_tween.set_parallel(true) # Membuat animasi jalan barengan
	
	# Terbang ke atas (mengurangi koordinat Y)
	text_tween.tween_property(label, "position:y", label.position.y - 80, 0.6).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Efek memudar (mengubah modulasi opacity/alpha menjadi 0)
	text_tween.tween_property(label, "modulate:a", 0.0, 0.6)
	
	# Hapus node label dari memori jika animasi sudah selesai agar tidak menumpuk (anti-lag)
	text_tween.chain().tween_callback(label.queue_free)
