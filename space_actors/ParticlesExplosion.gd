extends Particles2D
class_name ParticlesExplosion

export var time_alive : float = 5.0; # 5 Seconds
var timer : float = 0
var rng = RandomNumberGenerator.new()

# Runs when the scene is instantiated
func _ready():
	rng.randomize()
	var animation_number = rng.randi_range(1, 3)
	get_node("ExplosionSound"+str(animation_number)).play()

# Runs every frame.
func _process(delta : float):
	timer += delta
	if timer > time_alive:
		free()
