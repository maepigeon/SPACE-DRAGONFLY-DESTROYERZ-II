extends Node

var created_enemies : Array

# List of all enemies and their corresponding filepath.
var enemies : Dictionary = {
	"Asteroid": "res://space_actors/enemies/asteroid/Asteroid.tscn"
	}

# Removes specified enemy from list of created enemies.
func remove_enemy_from_stack(enemy : Object):
	created_enemies.erase(enemy)
	

# Returns an instance of an enemy and returns the result, or null if there is none.
func instance_enemy(enemy_name : String, target_parent : Node = null) -> Node:
	var enemy : String = enemies.get(enemy_name)
	
	if enemy == null:
		print("EnemyFactory Warning: Invalid enemy type: "+enemy_name+". Ignoring.")
		return null
		
	# Instantiate the node.
	var enemy_instance : Node = load(enemy).instance()
	if enemy_instance == null:
		print("EnemyFactory Warning: Invalid enemy type: "+enemy_name+". Ignoring.")
		return null
		
	# Set a parent for the node.
	if target_parent != null:
		target_parent.add_child(enemy_instance)
	# If none specified, it is added to this EnemyFactory
	else:
		add_child(enemy_instance)
	
	# Attach a signal from the node to know when it is destroyed and remove from list.
	enemy_instance.connect("destroy", self, "remove_enemy_from_stack")
	
	# Add the node to the list of created enemies.
	created_enemies.push_back(enemy_instance)
	return enemy_instance
