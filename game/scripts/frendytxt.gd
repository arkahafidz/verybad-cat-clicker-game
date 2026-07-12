extends Label

var time_left : float = 0.0
var multiplier : int = 1

func _ready() -> void:
	text = ""

func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		text = str(multiplier) + "X (" + str(snapped(time_left, 0.1)) + "s)"
		
		add_theme_color_override("font_color", Color.ORANGE if Engine.get_frames_drawn() % 10 < 5 else Color.YELLOW)
		
		if time_left <= 0:
			text = "" 
			remove_theme_color_override("font_color")

func start_frenzy_countdown(duration: float, mult: int) -> void:
	time_left = duration
	multiplier = mult
