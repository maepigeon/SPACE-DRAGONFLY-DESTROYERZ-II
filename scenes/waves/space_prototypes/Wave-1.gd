extends Wave
class_name WavePrototype1

# The asteroid field, which creates a bunch of asteroids based on a 
# bunch of parameters.
onready var asteroid_field : Node= preload("res://spawn_patterns/asteroid_field/AsteroidField.tscn")\
	.instance() as AsteroidField

# Starts the wave.
func start_wave(_spawn_target):
	.start_wave(_spawn_target)
	$SpawnPatterns.add_child(asteroid_field)
	asteroid_field.position = Vector2(960, 0)
	asteroid_field.initialize_pattern(200, 90.0, 1920.0, 15.0, 200.0, 340.0, 30.0, 1.0)
	asteroid_field.start_pattern(_spawn_target)
