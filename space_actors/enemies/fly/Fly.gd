extends Enemy
class_name Fly
# Run when the the Fly Fighter is instantiated.

export var speed : float = 512.0
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var home_position : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.DOWN

func _ready() -> void:
	velocity = Vector2.DOWN * speed
	rng.randomize()
	
# Runs on each frame.
func _physics_process(delta) -> void:
	zigzag_motion(delta)
	

# zigzag_speed is the rate the zigzag changes direction
var zigzag_speed : float = 2
var zigzag_time : float = 0.0
# Handles ZigZag motion when in the zigzag state
func zigzag_motion(delta) -> void:
	zigzag_time += delta * zigzag_speed
	if sin(zigzag_time * 2 * PI) > 0.5:
		direction.x = 1
	else:
		direction.x = -1
	direction = direction.normalized()
	velocity = direction * speed
		
	position += velocity * delta

# Bugs out the Fly's eyes, from 0 (normal) to 3 (about to die)
func bug_out_eyes(amt : int = 0):
	pass
# Call this function when the Actor exits the viewport.
func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	destroy()
