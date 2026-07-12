extends Label

func _process(_delta: float) -> void:
	text = "Koin: " + str(globalvar.coins)
