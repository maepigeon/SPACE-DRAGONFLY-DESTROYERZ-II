extends Enemy
class_name Worm
# Represents a worm enemy. Travels between two points along a random curve.

var length : float = 400 # length in pixels.
var resolution : float = 0.2 # the number of segments per pixel.
var darkness_delta : float  = 0.05 # The difference in darkness between segments

# The start location and the endpoint for the worm.
var start_wormhole : Wormhole
var end_wormhole : Wormhole

var dead : bool = false


# When the worm is angry, it flashes red, speeds up, and chases the player.
export var angry : bool = false

var last_segment_darkness = 0

# A list of all the segments.
var segments : Array = []

var destroy_segment_time_gap = 0.025
var current_destroy_segment_time_gap = destroy_segment_time_gap


# State stuff
enum states {SPAWNING, GOING_TO_WORMHOLE, DYING, GOING_TO_PLAYER, SPLITTING}
var current_state : int

# The worm segment.
var worm_segment_node := preload("res://space_actors/enemies/worm/WormSegment.tscn")

# The path follower.
var path_follower_node := preload("res://space_actors/enemies/worm/WormSegmentPathFollow2D.tscn")

# The explosions particles scene.
var explosion_particles_scene := preload("res://space_actors/enemies/asteroid/ParticlesAsteroidExplosion.tscn")

var rng = RandomNumberGenerator.new()

# Code executed when the scene is loaded
func _ready() -> void:
	rng.randomize()
	set_process(false)
	start(Vector2(100, 800), Vector2(1200, 100))
	
# Spawns the worm and makes it start
func start(start : Vector2, end : Vector2):
	set_state(states.SPAWNING)
	generate_path(start, end)
	set_process(true)
	segments.push_back(spawn_segment(0))

	
# Code executed on every frame.
func _process(delta) -> void:
	match current_state:
		states.SPAWNING:
			if !segments.front() or !segments.back():
				pass
			if segments.front().get_distance() < length  and segments.back().get_distance() > (1.0 / resolution):
				spawn_segment(segments.back().index + 1)
			if segments.front().get_distance() > length:
				set_state(states.GOING_TO_WORMHOLE)
		states.GOING_TO_WORMHOLE:
			pass
		states.DYING:
			if segments.size() == 0:
				queue_free()
			else: 
				current_destroy_segment_time_gap -= delta
				if current_destroy_segment_time_gap <= 0:
					print("destroying")
					destroy_head()
					current_destroy_segment_time_gap = destroy_segment_time_gap
		_:
			print("Worm has invalid state in _process().") 
		
# Sets the current state of the worm. 
func set_state(new_state : int) -> void:
	current_state = new_state
	
# Destroys the head segment and makes the next segment now the head
func destroy_head() -> void:
	if segments.front() and segments.front().has_node("HPSystem"):
		var head_hp : HPSystem = segments.front().get_node("HPSystem")
		head_hp.damage(head_hp.current_hp + 1)
		print("trying to kill segment")
	else:
		print("Weird, no HP sytem on the segment")


# Determine if this is the first segment, middle segment, or last segment
func segment_destroyed(segment : Node2D) -> void:
	var segment_index : int = segments.find(segment)
	print("segment index: " + String(segment_index))

	if segment_index == 0:
		_on_HPSystem_Dead()
		print("head segment destroyed")
	else:
		segments.remove(segment_index)
		print("tail segment destroyed")
	
# Splits the worm at the certain segment index 
func split_at_segment(segment_index : int) -> void:
	pass

# Spawns a single worm segment
func spawn_segment(index: int) -> WormSegment:
	# Create the segment objects.
	var worm_segment : WormSegment = worm_segment_node.instance()
	var path_follower := path_follower_node.instance()
	
	worm_segment.connect("destroy_segment", self, "segment_destroyed")
	
	worm_segment.set_darkness(last_segment_darkness)
	last_segment_darkness += darkness_delta
	
	segments.push_back(worm_segment)
	
	# Add the objects to the scene tree.
	$Segments.add_child_below_node($Segments.get_child(0), worm_segment)
	$Path2D.add_child(path_follower)
	
	# Initialize the segment.
	worm_segment.set_path_follower(path_follower)
	worm_segment.set_index(index)
	
	# Sets the Worm segent position to be the remote position under the pathfollower
	path_follower.get_child(0).set_remote_node(worm_segment.get_path())
	path_follower.offset = 0
	
	
	# Finally, make the worm start doing stuff.
	worm_segment.start()
	
	return worm_segment


# Generates a path for the worm to follow from the start wormhole to the end one.
func generate_path(start : Vector2, end : Vector2) -> void:
	var curve : Curve2D = $PathGenerator.generate_path(start, end).curve
	$Path2D.curve = curve
	
# Returns a Vector2 of the position a WormSegment should be at a certain
# position_on path, which will always be between 0 to 1 
func get_position_on_path(position_on_path : float) -> Vector2:
	return Vector2.ZERO
	
# When the Actor dies, do this.
func _on_HPSystem_Dead() -> void:
	explode()
	CameraEffects.add_trauma(0.08)
	#destroy()
	
func _on_segment_destroyed(segment : WormSegment) -> void:
	print("a worm segment has been destroyed!!!")

# Whenever the Actor's HP is updated
func _on_HPSystem_HPUpdated(new_hp : float) -> void:
	$AnimatedSprite.modulate.g = new_hp / $HPSystem.max_hp
	$AnimatedSprite.modulate.b = new_hp / $HPSystem.max_hp
	
# Make the worm explode. Segments all blow up.
func explode() -> void:
	print("currenly exploding")
	if not dead:
		dead = true
		while segments.size() > 0:
			if segments[0]:
				segments[0]._on_HPSystem_Dead()
			segments.pop_front()
	set_state(states.GOING_TO_WORMHOLE)
