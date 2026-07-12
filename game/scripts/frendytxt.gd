# FrenzyTXT.gd
extends Label

var time_left : float = 0.0
var multiplier : int = 1

func _ready() -> void:
	# Sembunyikan teks di awal game karena frenzy belum aktif
	text = ""

func _process(delta: float) -> void:
	# Mengurangi waktu mundur setiap frame dan memperbarui visual teks jika frenzy aktif
	if time_left > 0:
		time_left -= delta
		text = str(multiplier) + "X (" + str(snapped(time_left, 0.1)) + "s)"
		
		# Efek teks berkedip warna orange-kuning agar terlihat heboh
		add_theme_color_override("font_color", Color.ORANGE if Engine.get_frames_drawn() % 10 < 5 else Color.YELLOW)
		
		if time_left <= 0:
			text = "" 
			remove_theme_color_override("font_color") # Bersihkan warna override saat Frenzy selesai

func start_frenzy_countdown(duration: float, mult: int) -> void:
	# Menginisialisasi waktu dan multiplier baru saat mode frenzy dipicu
	time_left = duration
	multiplier = mult
