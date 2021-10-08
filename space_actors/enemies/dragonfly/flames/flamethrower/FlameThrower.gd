extends Node2D
onready var emitting : bool setget enable_flames

func enable_flames(is_emitting : bool):
	emitting = is_emitting
	$Flames.set_emitting(emitting)
	$Sparks.set_emitting(emitting)
