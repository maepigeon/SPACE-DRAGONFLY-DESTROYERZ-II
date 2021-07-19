extends RayCast2D

# Deals 1 hitpoint per second.
export var damage_rate = 1.0
var is_casting := false setget set_is_casting


# Speed at which the laser extends when first fired, in pixels per seconds.
export var cast_speed := 7000.0
# Maximum length of the laser in pixels.
export var max_length := 1400.0

onready var casting_particles := $CastingParticles2D
onready var collision_particles := $CollisionParticles2D
onready var beam_particles := $BeamParticles2D

func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	cast_to = (cast_to + Vector2.RIGHT * cast_speed * delta).clamped(max_length)
	cast_beam(delta)
	
# Handles gun input
#func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		set_is_casting(event.pressed)
		
	
		
func set_is_casting(cast: bool) -> void:
	# If the state is not changing, don't do anything.
	if is_casting == cast:
		return
	
	# Otherwise, actually do stuff.
	is_casting = cast

	if is_casting:
		cast_to = Vector2.ZERO
		$Line2D.points[1] = cast_to
		appear()
	else:
		collision_particles.emitting = false
		disappear()

	set_physics_process(is_casting)
	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting


# Controls the emission of particles and extends the Line2D to `cast_to` or the ray's 
# collision point, whichever is closest.
func cast_beam(delta: float) -> void:
	var cast_point = cast_to

	force_raycast_update()
	collision_particles.emitting = is_colliding()

	if is_colliding():
		cast_point = to_local(get_collision_point())
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = cast_point
		
		
		var object_hit : Node = get_collider()
		if object_hit.is_in_group("Enemies"): 
			object_hit.get_node("HPSystem").damage(delta * damage_rate)
		else:
			print("laser hit"+object_hit.name)

	$Line2D.points[1] = cast_point
	beam_particles.position = cast_point * 0.5
	beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
# Makes the laser appear.
func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 10.0, 0.2)
	$Tween.start()

# Makes the laser disappear.
func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 10.0, 0, 0.1)
	$Tween.start()


