extends "res://space_actors/enemies/asteroid/Asteroid.gd"


# Code to make the asteroid explode
func explode() -> void:
	emit_explosion_particles()
