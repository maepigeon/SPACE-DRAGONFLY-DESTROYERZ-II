extends SpawnPattern
class_name WormholePair
# Spawns a worm and two portals. The worm will go from portal 1 to 2.

var rng = RandomNumberGenerator.new()

var start_pos : Vector2
var end_pos : Vector2
var initialized : bool = false

# Run on start
func _ready() -> void:
	rng.randomize()
	
# initialize all the properties for the Asteroid Field
func initialize_pattern(var start : Vector2, var end : Vector2):
	initialized = true
	start_pos = start
	end_pos = end
	
# Start the pattern. Spawns a worm and two wormholes at random location.
func start_pattern(_spawn_target):
	.start_pattern(_spawn_target)
	var viewport_size : Vector2 = get_viewport().size
	if not initialized:
		start_pos = Vector2(rng.randf_range(0.0, viewport_size.x), \
			rng.randf_range(0.0, viewport_size.y))
		end_pos = Vector2(rng.randf_range(0.0, viewport_size.x), \
			rng.randf_range(0.0, viewport_size.y))
	var worm : Worm = $EnemyFactory.instance_enemy("Worm", self)
	worm.start(start_pos, end_pos)
	
