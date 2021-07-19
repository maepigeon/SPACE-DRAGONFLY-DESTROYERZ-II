extends Node
class_name Wave
# Base interface for all waves of enemies

# Where the Enemies will spawn (parent node)
onready var spawn_target : Node = self

# Called to start a wave
func start_wave(_spawn_target):
	spawn_target = _spawn_target

# Called to end a wave.
func end_wave():
	pause_wave()
	destroy_wave()
	print("must implement end_wave function")

# Called when the wave is destroyed
func destroy_wave():
	print("need to implement a wave destructor")

# Pause the wave spawning.
func pause_wave():
	print("need to implement a pause_wave function")
	pass
