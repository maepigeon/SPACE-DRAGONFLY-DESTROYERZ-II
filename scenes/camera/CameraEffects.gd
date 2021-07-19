extends Node
# Singleton that provides a quick interface for the camera

# The camera should assign itself to this node.
var camera : Node


func add_trauma(amount : float) -> void:
	if camera:
		camera.add_trauma(amount)
	else:
		print("Warning: Camera not set. Cannot shake the screen.")
