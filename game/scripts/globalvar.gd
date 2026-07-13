# globalvar.gd
extends Node

var coins: int = 0
var cpc: int = 1
var autoclick: int = 0

var upgcost1: int = 50
var upgcost2: int = 100

const SAVE_PATH = "user://savegame.json"
const WEB_STORAGE_KEY = "very_bad_cat_clicker_save"

func _ready() -> void:
	load_game()
	
	var auto_save_timer = Timer.new()
	auto_save_timer.wait_time = 10.0
	auto_save_timer.autostart = true
	auto_save_timer.timeout.connect(save_game)
	add_child(auto_save_timer)

func add_coins(amount: int) -> void:
	coins += amount

func save_game() -> void:
	var save_data = {
		"coins": coins,
		"cpc": cpc,
		"autoclick": autoclick,
		"upgcost1": upgcost1,
		"upgcost2": upgcost2
	}
	
	var json_string = JSON.stringify(save_data)
	
	if OS.has_feature("web"):
		var window = JavaScriptBridge.get_interface("window")
		if window:
			window.localStorage.setItem(WEB_STORAGE_KEY, json_string)
			print("success (web auto-save)")
			return

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("success")

func load_game() -> void:
	var json_string = ""
	
	if OS.has_feature("web"):
		var window = JavaScriptBridge.get_interface("window")
		if window:
			var web_data = window.localStorage.getItem(WEB_STORAGE_KEY)
			if web_data:
				json_string = web_data
			else:
				print("none")
				return
	else:
		if not FileAccess.file_exists(SAVE_PATH):
			print("none")
			return
			
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			json_string = file.get_as_text()
			file.close()
		
	if json_string != "":
		var json = JSON.new()
		var error = json.parse(json_string)
		
		if error == OK:
			var data = json.get_data()
			if "coins" in data: coins = int(data["coins"])
			if "cpc" in data: cpc = int(data["cpc"])
			if "autoclick" in data: autoclick = int(data["autoclick"])
			if "upgcost1" in data: upgcost1 = int(data["upgcost1"])
			if "upgcost2" in data: upgcost2 = int(data["upgcost2"])
			print("success")
		else:
			print("error")
