class_name Distance

# One metter is equal to 10 vector points from coordinates
var _one_metter: int = 10
var _one_kilometter: int = _one_metter * 1000

# Returns distance in metters between two points
func get_distance(start: float, end: float) -> float:
	return ("%.2f" % ((end - start) / _one_metter)) as float

# Converts real kilometters to vector points
func kilometters_to_points(kilometters: float) -> float:
	return kilometters * _one_kilometter

# Convert vector's distance to metters
# for instance, from result of Vector2.distance_to
func convert_distance(distance: float) -> float:
	return ("%.2f" % (distance / _one_metter)) as float


# Returns radius distance what may be saw by player
# Calculates from player position
static func active_world_radius_points() -> int:
	return 1000
