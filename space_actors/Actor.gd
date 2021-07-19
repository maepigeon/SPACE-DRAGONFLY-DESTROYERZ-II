extends Node2D

class_name Actor

signal destroy(itself)

export var velocity : Vector2

# Destroys the Actor
func destroy():
	emit_signal("destroy", self)
	queue_free()
	
# Call this function when the Actor exits the viewport.
func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	print("actor exited viewport. need to implement an exited viewport function.")
	
# Sets the velocity property of the Actor.
func set_velocity(_velocity : Vector2) -> void:
	velocity = _velocity


# When the actor collides with anything
func handle_collision(body):
	pass
	# Replace with function body.

# When the Actor dies, do this.
func _on_HPSystem_Dead() -> void:
	destroy()

# Whenever the Actor's HP is updated
func _on_HPSystem_HPUpdated(new_hp : float) -> void:
	pass # Replace with function body.
