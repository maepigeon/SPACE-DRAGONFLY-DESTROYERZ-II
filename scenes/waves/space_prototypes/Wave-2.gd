extends Wave
class_name WavePrototype2

# The fly_field creates a bunch of flies based on a bunch of parameters.
onready var fly_field : Node= preload("res://spawn_patterns/fly_field/FlyField.tscn")\
	.instance() as FlyField


func start_wave(_spawn_target):
	$SpawnPatterns.add_child(fly_field)
	.start_wave(_spawn_target)
	fly_field.position = Vector2(960, 0)
	fly_field.initialize_pattern()
	fly_field.start_pattern(_spawn_target)
