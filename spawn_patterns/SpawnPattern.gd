extends Node2D
signal pattern_complete
class_name SpawnPattern

# Where Enemies are spawned!
onready var spawn_target : Node = self

# Execute the pattern
func start_pattern(_spawn_target):
	spawn_target = _spawn_target
	pass
	
# Reparents a node
func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	child.set_owner(new_parent)
	
# Execute when the pattern has finished executing.
func pattern_completed():
	emit_signal("pattern_complete")
	print("Spawn pattern finiished executing.")
	pass
