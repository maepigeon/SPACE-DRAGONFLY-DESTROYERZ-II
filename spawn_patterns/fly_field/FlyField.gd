extends SpawnPattern
class_name FlyField
# Spawns a grid of FighterFlies that come down from the top

var field_size : Vector2 = Vector2(12, 3)
var grid_pixels : Vector2 = Vector2(1920, 1080)
var velocity : Vector2 = Vector2.DOWN * 1000
var use_random_shift : bool = false
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# For testing purposes, this runs the field.
#func _ready():
#	initialize_pattern()
#	start_pattern(self)

# initialize all the properties for the Asteroid Field
func initialize_pattern(
	var _field_size : Vector2 = field_size,
	var _grid_pixels : Vector2 = grid_pixels,
	var _velocity : Vector2 = velocity,
	var _use_random_shift : bool = use_random_shift
	) -> void:
	field_size = _field_size
	grid_pixels = _grid_pixels
	velocity = _velocity
	use_random_shift = _use_random_shift
	rng.randomize()

# Execute the pattern with a spawn target
func start_pattern(_spawn_target) -> void:
	.start_pattern(_spawn_target)
	for x in range(field_size.x):
		for y in range(field_size.y):
			spawn_fly(Vector2(x, y))

# Spawns a fly at it's respective position in the grid that flies down from the
# top of the screen. The index is the position of the fly.
func spawn_fly(index : Vector2) -> void:
	var fly : Fly = $EnemyFactory.instance_enemy("Fly", self)
	fly.position = Vector2(index.x*grid_pixels.x/field_size.x,\
		index.y*grid_pixels.y/field_size.y)
	fly.speed = velocity.length()
	fly.velocity = velocity
	fly.zigzag_amount = 300
	fly.zigzag_duration = 1
	fly.rotation = velocity.angle()-PI/2
		
	# Starts the flies out not moving together side-to-side
	if use_random_shift:
		fly.zigzag_time = rng.randf_range(0, fly.zigzag_speed * 2 * PI)
