extends AnimatedSprite

func _ready():
	visible = false
	InputManager.cursor = self
	
# Sets the cursor red or orange depending on if you're shooting
func set_is_shooting(is_shooting):
	if is_shooting:
		modulate = Color(.9, .1, .1)
	else:
		modulate = Color(1, 0.5, 0.1)

# Sets the Cursor as enabled or disabled
func set_enabled(enabled):
	visible = enabled
