extends Node
class_name PathGenerator
# Generates a smooth random path between two points.

# The maximum amount of points on the path.
export var max_points = 20

# The start/end point of the path.
var start_point := Vector2(0, 0)
var end_point := Vector2(800, 800)

# The distance between points (except the last).
var point_gap = 250

# The distance a control point is from the real point.
var control_point_distance = 70

var rng = RandomNumberGenerator.new()

# Randomizes the rng when the scene is loaded.
func _ready() -> void:
	rng.randomize()
	
# Determines the length (in pixels) of the control points.
func set_control_point_distance(distance : float) -> void:
	control_point_distance = distance
	 
# Determines the distance the next point will be. This value is also used to 
# compare the last point's distance.
func set_next_point_gap(gap : float) -> void:
	point_gap = gap
	
# Generates and returns the generated path
func generate_path(_start_point : Vector2, _end_point : Vector2) -> Path2D:
	start_point = _start_point
	end_point = _end_point
	# Get control over the Path2D node
	var path : Path2D = $Path2D
	var curve : Curve2D = path.curve
	# First, generate the points
	curve.add_point(start_point, Vector2.ZERO, Vector2.ZERO)
	var current_point : Vector2 = start_point
	# Then generate the control points for points 0 and n.
	while (current_point.distance_to(end_point) > point_gap \
		and curve.get_point_count() <= max_points):
		# Generate the point
		var direction_vec : Vector2 = (end_point - current_point).normalized()
		var direction_angle : float = direction_vec.angle()
		direction_angle += pow(rng.randf_range(-1.0, 1.0), 3) * PI
		direction_vec = Vector2(cos(direction_angle), sin(direction_angle))
		
		current_point = current_point + direction_vec * point_gap
		curve.add_point(current_point)
	# Add last point
	curve.add_point(end_point, Vector2.ZERO, Vector2.ZERO)
	
	# Then, generate the control points for points.
	curve.set_point_out(0, curve.get_point_position(1).normalized() \
		* control_point_distance)
	var i : int = 1
	while (i < curve.get_point_count() - 1):
		var p0 : Vector2 = curve.get_point_position(i - 1)
		var p2 : Vector2 = curve.get_point_position(i + 1)
		
		var in_pt : Vector2 = (p0 - p2).normalized() * control_point_distance
		var out_pt : Vector2 = - (p0 - p2).normalized() * control_point_distance
		
		curve.set_point_in(i, in_pt)
		curve.set_point_out(i, out_pt)
		
		i += 1
	
	curve.set_point_in(curve.get_point_count() - 1,  \
		curve.get_point_position(curve.get_point_count() - 2).normalized() \
		* control_point_distance)
		
	# Now, return the path.
	path.curve = curve
	return path
