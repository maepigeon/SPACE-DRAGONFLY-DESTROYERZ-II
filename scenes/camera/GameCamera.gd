extends Camera2D

class_name GameCamera

# Screen-shake related variables
export var decay = 0.7  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(120, 80)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.2  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	CameraEffects.camera = self

func _process(delta):
	if trauma > 0:
		trauma = max(trauma - decay * delta, 0)
		shake()

# Updates the zoom amount. 200% = zoomed out A LOT.
func set_zoom_percent(percent : float) -> void:
	return

# Shakes the screen (run on each frame where there is trauma)
func shake() -> void:
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	# Using noise
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	
# Adds screenshake
func add_trauma(amount) -> void:
	trauma = min(trauma + amount, 1.0)
