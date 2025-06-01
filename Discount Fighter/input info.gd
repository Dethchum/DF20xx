extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	if Input.is_anything_pressed():
		set_text("input")
	
