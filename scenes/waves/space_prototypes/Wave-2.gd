extends Wave
class_name WavePrototype2

# The fly_field creates a bunch of flies based on a bunch of parameters.
onready var fly_field : Node= preload("res://spawn_patterns/fly_field/FlyField.tscn")\
	.instance() as FlyField
onready var fly_spawner : Node= preload("res://spawn_patterns/fly_field/FlySpawner.tscn")\
	.instance() as FlySpawner
	
	
#For testing purposes, this runs the wave.
#func _ready():
#	start_wave(self)


func start_wave(_spawn_target):
	.start_wave(_spawn_target)
	
	$SpawnPatterns.add_child(fly_field)
	fly_field.position = Vector2(960, -200)
	fly_field.initialize_pattern(Vector2(4, 2), Vector2(600, 300),\
		Vector2.DOWN*500, false)
	fly_field.start_pattern(_spawn_target)
	
	
	$SpawnPatterns.add_child(fly_spawner)
	fly_spawner.position = Vector2(960, 0)
	fly_spawner.initialize_pattern(200, 90.0, 1920.0, 15.0, 200.0, 340.0, 30.0)
	fly_spawner.start_pattern(_spawn_target)
