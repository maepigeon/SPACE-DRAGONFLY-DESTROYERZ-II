extends SpawnPattern
class_name AsteroidField

# How many asteroids are in the asteroid field
export var amount_of_asteroids : int = 20
# The source direction for the asteroids (in degrees from right)
export var source_direction : float = 90
# The amount of pixels of range that asteroids will spawn (from position along
#  source_direction).
export var source_width : float = 800.0
# The amount of variance of direction that asteroids will spawn. 360 = any direction.
export var angle_variance : float = 30.0
# The base min speed for the asteroids.
export var min_speed : float = 120.0
# The base max speed for the asteroids
export var max_speed : float = 180.0
# The amount of time you go through the asteroid field for (in seconds).
export var time : float = 5;
# The range of randomness that an Asteroid spins
export var spin_amount_randomness_range : float = 1;

# The amount of time left in the pattern
onready var time_remaining :float = time
onready var amount_of_asteroids_remaining : int = amount_of_asteroids

var rng = RandomNumberGenerator.new()

# Run on start
func _ready() -> void:
	rng.randomize()
	set_physics_process(false)

# Runs on each frame.
func _physics_process(delta) -> void:
	time_remaining -= delta
	if time_remaining / time < float(amount_of_asteroids_remaining) \
		/ float(amount_of_asteroids):
		if amount_of_asteroids_remaining > 0:
			amount_of_asteroids_remaining -= 1
			spawn_asteroid()
			
	if time_remaining < 0:
		time_remaining = 0
		set_physics_process(false)
		return
		
# Spawns a single asteroid.
func spawn_asteroid() -> void:
	var asteroid : Node = $EnemyFactory.instance_enemy("Asteroid", self)
	var position_x : float = rng.randf_range(-source_width/2, source_width/2)
	var position_y : float = 0
	asteroid.position = Vector2(position_x, position_y)
	asteroid.position = asteroid.position.rotated(deg2rad(source_direction - 90))
	
	var speed : float = rng.randf_range(min_speed, max_speed)
	
	
	var asteroid_angle : float = rng.randf_range(-angle_variance/2.0, angle_variance/2.0) + source_direction
	asteroid_angle = deg2rad(asteroid_angle)
	asteroid.set_velocity(Vector2(cos(asteroid_angle), sin(asteroid_angle)) * speed)
	asteroid.spin_amount_randomness_range = spin_amount_randomness_range
	# Reparent the Asteroid
	reparent(asteroid, spawn_target)
	asteroid.position += position
	
# initialize all the properties for the Asteroid Field
func initialize_pattern(_amount_of_asteroids:int=amount_of_asteroids,\
	_source_direction:float=source_direction,\
	_source_width:float=source_width, _angle_variance:float=angle_variance,\
	_min_speed:float=min_speed, _max_speed:float=max_speed, _time:float=time,\
	_spin_amount_randomness_range:float=spin_amount_randomness_range):
		
	amount_of_asteroids = _amount_of_asteroids
	source_direction = _source_direction
	source_width = _source_width
	angle_variance = _angle_variance
	min_speed = _min_speed
	max_speed = _max_speed
	time = _time
	spin_amount_randomness_range = _spin_amount_randomness_range

# Execute the pattern
func start_pattern(_spawn_target):
	.start_pattern(_spawn_target)
	set_physics_process(true)
	time_remaining = time
	amount_of_asteroids_remaining = amount_of_asteroids
