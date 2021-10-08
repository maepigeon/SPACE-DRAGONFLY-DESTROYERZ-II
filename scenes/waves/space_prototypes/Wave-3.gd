extends Wave
class_name WavePrototype3

# The fly_field creates a bunch of flies based on a bunch of parameters.
onready var wormhole : Node= preload("res://spawn_patterns/worm_hole_pair/WormholePair.tscn")\
	.instance() as WormholePair
	
	
#For testing purposes, this runs the wave.
#func _ready():
#	start_wave(self)


func start_wave(_spawn_target):
	.start_wave(_spawn_target)
	
	$SpawnPatterns.add_child(wormhole)
	wormhole.start_pattern(_spawn_target)
