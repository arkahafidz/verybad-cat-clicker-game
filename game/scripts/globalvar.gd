# globalvar.gd
extends Node

var coins: int = 0
var cpc: int = 1
var autoclick: int = 0

var upgcost1: int = 50
var upgcost2: int = 100


const SAVE_PATH = "user://savegame.json"

func _ready() -> void:
	load_game()

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
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print("success")

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("none")
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
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
