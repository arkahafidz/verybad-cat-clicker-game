# uipagecntrl.gd
extends HBoxContainer

@onready var home_page: Control = $"../Control/home"
# Catatan: Silakan sesuaikan path di bawah jika nanti kamu sudah membuat node halaman upgrade-mu sendiri
@onready var upgrade_page: Control = $"../Control/upg"

func _ready() -> void:
	# Mengatur halaman awal agar hanya halaman home yang muncul saat game dimulai
	show_page("home")

func show_page(page_name: String) -> void:
	# Mengatur visibilitas halaman berdasarkan nama halaman yang dipanggil untuk mencegah misklik
	if home_page:
		home_page.visible = (page_name == "home")
	if upgrade_page:
		upgrade_page.visible = (page_name == "upgrade")

func _on_home_ui_pressed() -> void:
	# Fungsi signal saat tombol HomeUI diklik untuk memunculkan halaman utama kucing
	show_page("home")

func _on_upg_ui_pressed() -> void:
	# Fungsi signal saat tombol UpgUI diklik untuk memindahkan layar ke halaman toko upgrade
	show_page("upgrade")
