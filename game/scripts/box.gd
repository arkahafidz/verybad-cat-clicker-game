extends Sprite2D

# Variabel untuk mengatur kekuatan goyangan
@export var wobble_strength : float = 0.2 
@export var wobble_duration : float = 0.4 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Memeriksa apakah posisi mouse berada di dalam area gambar Sprite
		if get_rect().has_point(to_local(event.position)):
			trigger_wobble()

func trigger_wobble() -> void:
	# Buat objek Tween baru
	var tween = create_tween()
	
	# Set transisi agar gerakannya terasa membal/karet (Elastic)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# Efek Pertama: Kaget (Gepeng ke samping, meninggi ke atas)
	# Mengubah skala dari (1,1) ke (1.2, 0.8) dengan cepat
	var target_squash = Vector2(1.0 + wobble_strength, 1.0 - wobble_strength)
	tween.tween_property(self, "scale", target_squash, wobble_duration * 0.2)
	
	# Efek Kedua: Kembali ke ukuran semula dengan efek membal elastis
	tween.tween_property(self, "scale", Vector2.ONE, wobble_duration * 0.8)
