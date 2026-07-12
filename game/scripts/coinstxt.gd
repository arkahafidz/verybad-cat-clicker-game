extends Label

func _process(_delta: float) -> void:
	text = "Coins: " + str(globalvar.coins)


func _on_home_ui_pressed() -> void:
	pass


func _on_upg_ui_pressed() -> void:
	pass
