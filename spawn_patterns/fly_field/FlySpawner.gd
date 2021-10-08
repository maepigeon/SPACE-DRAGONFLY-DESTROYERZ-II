extends SpawnPattern
class_name FlySpawner

# How many flies are in the fly field
export var amount_of_flies : int = 20
# The source direction for the flies (in degrees from right)
export var source_direction : float = 90
# The amount of pixels of range that flies will spawn (from position along
#  source_direction).
export var source_width : float = 800.0
# The amount of variance of direction that flies will spawn. 360 = any direction.
export var angle_variance : float = 30.0
# The base min speed for the flies.
export var min_speed : float = 120.0
# The base max speed for the flies
export var max_speed : float = 180.0
# The amount of time you go through the fly field for (in seconds).
export var time : float = 5;

# The amount of time left in the pattern
onready var time_remaining :float = time
onready var amount_of_flies_remaining : int = amount_of_flies

var rng = RandomNumberGenerator.new()

# Run on start
func _ready() -> void:
	rng.randomize()
	set_physics_process(false)

# Runs on each frame.
func _physics_process(delta) -> void:
	time_remaining -= delta
	if time_remaining / time < float(amount_of_flies_remaining) \
		/ float(amount_of_flies):
		if amount_of_flies_remaining > 0:
			amount_of_flies_remaining -= 1
			spawn_fly()
			
	if time_remaining < 0:
		time_remaining = 0
		set_physics_process(false)
		return
		
# Spawns a single fly.
func spawn_fly() -> void:
	var fly : Node = $EnemyFactory.instance_enemy("Fly", self)
	var position_x : float = rng.randf_range(-source_width/2, source_width/2)
	var position_y : float = 0
	fly.position = Vector2(position_x, position_y)
	fly.position = fly.position.rotated(deg2rad(source_direction - 90))
	
	var speed : float = rng.randf_range(min_speed, max_speed)
	
	
	var fly_angle : float = rng.randf_range(-angle_variance/2.0, angle_variance/2.0) + source_direction
	fly_angle = deg2rad(fly_angle) + PI/2
	fly.direction = Vector2(cos(fly_angle), sin(fly_angle))
	# Reparent the Asteroid
	reparent(fly, spawn_target)
	fly.position += position
	
# initialize all the properties for the Fly Spawner
func initialize_pattern(_amount_of_flies:int=amount_of_flies,\
	_source_direction:float=source_direction,\
	_source_width:float=source_width, _angle_variance:float=angle_variance,\
	_min_speed:float=min_speed, _max_speed:float=max_speed, _time:float=time):
		
	amount_of_flies = _amount_of_flies
	source_direction = _source_direction
	source_width = _source_width
	angle_variance = _angle_variance
	min_speed = _min_speed
	max_speed = _max_speed
	time = _time

# Execute the pattern
func start_pattern(_spawn_target):
	.start_pattern(_spawn_target)
	set_physics_process(true)
	time_remaining = time
	amount_of_flies_remaining = amount_of_flies
