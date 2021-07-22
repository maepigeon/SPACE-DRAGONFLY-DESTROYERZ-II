extends Wave
class_name WavePrototype2

# The fly_field creates a bunch of flies based on a bunch of parameters.
onready var fly_field : Node= preload("res://spawn_patterns/fly_field/FlyField.tscn")\
	.instance() as FlyField
	
	
# For testing purposes, this runs the wave.
func _ready():
	start_wave(self)


func start_wave(_spawn_target):
	$SpawnPatterns.add_child(fly_field)
	.start_wave(_spawn_target)
	fly_field.position = Vector2(960, 0)
	fly_field.initialize_pattern(Vector2(4, 2), Vector2(600, 300),\
		Vector2.DOWN*500, false)
	fly_field.start_pattern(_spawn_target)
