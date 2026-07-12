# pages_control.gd
extends Control

@onready var home_page : Control = $home
@onready var upg_page : Control = $upg

@onready var home_btn : Button = $"../Home" # Sesuaikan jika tipenya Button biasa atau letak nodenya berbeda
@onready var upg_btn : Button = $"../Upg"

func _ready() -> void:
	# Menyambungkan sinyal klik tombol navigasi UI ke fungsi perpindahan halaman saat game dimulai
	home_btn.pressed.connect(show_home)
	upg_btn.pressed.connect(show_upgrade)
	show_home() # Memastikan halaman utama aktif saat pertama kali masuk game

func show_home() -> void:
	# Mengaktifkan halaman home dan menyembunyikan halaman upgrade dari layar
	home_page.visible = true
	upg_page.visible = false

func show_upgrade() -> void:
	# Mengaktifkan halaman upgrade dan menyembunyikan halaman home dari layar
	home_page.visible = false
	upg_page.visible = true
	
	# Opsional: Memicu update UI harga koin terbaru di halaman upgrade saat dibuka
	if upg_page.has_method("update_upgrade_ui"):
		upg_page.update_upgrade_ui()
