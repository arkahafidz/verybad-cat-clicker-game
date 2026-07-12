# upg.gd
extends Control

@onready var upg1_txt : Label = $Upgrade1TXT
@onready var upg2_txt : Label = $Upgrade2TXT
@onready var buy1_btn : Button = $Buy1 
@onready var buy2_btn : Button = $Buy2
@onready var coins_txt : Label = $"../CanvasLayer/CoinsTXT"

func _ready() -> void:
	# Menyambungkan sinyal klik tombol belanja dan memperbarui tampilan teks harga di awal game
	buy1_btn.pressed.connect(_on_buy1_pressed)
	buy2_btn.pressed.connect(_on_buy2_pressed)
	update_upgrade_ui()

func update_upgrade_ui() -> void:
	# Memperbarui informasi visual teks harga upgrade serta menonaktifkan tombol secara otomatis jika koin kurang
	upg1_txt.text = "Coin per click Cost: " + str(globalvar.upgcost1)
	upg2_txt.text = "autoclicker Cost: " + str(globalvar.upgcost2)
	
	buy1_btn.disabled = globalvar.coins < globalvar.upgcost1
	buy2_btn.disabled = globalvar.coins < globalvar.upgcost2

func _on_buy1_pressed() -> void:
	# Memproses pembelian Upgrade 1 untuk meningkatkan kekuatan klik (cpc) dan menaikkan harga produk berikutnya
	if globalvar.coins >= globalvar.upgcost1:
		globalvar.coins -= globalvar.upgcost1
		globalvar.cpc += 1 
		globalvar.upgcost1 = int(globalvar.upgcost1 * 1.5) 
		_post_purchase_update()

func _on_buy2_pressed() -> void:
	# Memproses pembelian Upgrade 2 untuk meningkatkan status autoclick pasif dan menaikkan skala harga berikutnya
	if globalvar.coins >= globalvar.upgcost2:
		globalvar.coins -= globalvar.upgcost2
		globalvar.autoclick += 1 
		globalvar.upgcost2 = int(globalvar.upgcost2 * 1.6) 
		_post_purchase_update()

func _post_purchase_update() -> void:
	# Mensinkronisasikan ulang seluruh data visual UI menu upgrade dan teks koin utama agar tidak terjadi lag visual
	update_upgrade_ui()
	if coins_txt:
		coins_txt.text = str(globalvar.coins)
