extends Enemy
class_name WormSegment

# The object that this will follow (position is anchored to the pathfollow2d's child)
var path_follower : PathFollow2D

# The index of the segment. 0 = head.
var index = 0

# The amount of jerk applied to the segment.
export var jerk_amount : float = 800

# THe maximum acceleration for the segment.
export var max_acceleration : float = 300

# The current acceleration of the worm segment.
export var current_acceleration : float = 0

# The number of "pixels" along the PathFollow2D the segment moves at.
export var max_speed : float = 100

# The current speed of the worm segment.
export var current_speed : float = 0

# 0 = non-modified color, 1 = completely black
var darkness : float = 0

# Define the HP for the head and tail segments.
var tail_hp : float = 0.5
var head_hp : float = 0.75

# The explosions particles scene.
var explosion_particles_scene := preload("res://space_actors/enemies/asteroid/ParticlesAsteroidExplosion.tscn")

# Signal sent when the worm is killed.
signal destroy_segment(segment_index)


# Run when the scene is loaded
func _ready() -> void:
	set_physics_process(false)
	if index != 0:
		$AnimatedSprite.play("Body")
		
		
# Run when you want the worm to start doing stuff. Also sets the hp.
func start() -> void:
	set_physics_process(true)
	if index == 0:
		$HPSystem.initialize_hp_and_max_hp(head_hp)
	else:
		$HPSystem.initialize_hp_and_max_hp(tail_hp)

# Gets the total distance the segment has travelled
func get_distance() -> float:
	return path_follower.offset
	
# Gets the index of the segment
func set_index(_index : int):
	index = _index
	if index != 0:
		$AnimatedSprite.play("Body")

func set_path_follower(_path_follower : PathFollow2D) -> void:
	path_follower = _path_follower
	
# Sets how dark the segment is. 0 = non-modified color, 1 = completely black
func set_darkness(_darkness : float) -> void:
	darkness = _darkness
	$AnimatedSprite.modulate = Color(1.0-darkness, 1.0-darkness, 1.0-darkness)
	
# Run before each frame
func _physics_process(delta : float) -> void:
	current_acceleration = min(max_acceleration, current_acceleration + jerk_amount * delta)
	current_speed = min(max_speed, current_speed + current_acceleration * delta)
	path_follower.set_offset(path_follower.get_offset() + current_speed * delta)

# Whenever the Actor's HP is updated
func _on_HPSystem_HPUpdated(new_hp : float) -> void:
	$AnimatedSprite.modulate.g = new_hp / $HPSystem.max_hp
	$AnimatedSprite.modulate.b = new_hp / $HPSystem.max_hp
	$AnimatedSprite.modulate.r = new_hp / $HPSystem.max_hp


# Do nothing when it exsts the viewport. This is expected behavior for worms.
# Do nothing when it exsts the viewport. This is expected behavior for worms.
func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	pass
	
	
# Plays an explosion animation for the worm.
func explode() -> void:
	emit_explosion_particles()
	
# Emit explosion Particles
func emit_explosion_particles() -> void:
	var explosion_particles = explosion_particles_scene.instance()
	explosion_particles.position = self.position
	get_parent().add_child(explosion_particles)
	explosion_particles.emitting = true
	
# When the Actor dies, do this.
func _on_HPSystem_Dead() -> void:
	emit_signal("destroy_segment", index)
	explode()
	CameraEffects.add_trauma(0.08)
	destroy()

