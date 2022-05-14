class_name Distance

# One metter is equal to 10 vector points from coordinates
var one_metter: int = 10
var one_kilometter: int = one_metter * 1000

# Returns distance in metters between two points
func get_distance(start: float, end: float) -> float:
	return ("%.2f" % ((end - start) / one_metter)) as float

# Converts real kilometters to vector points
func kilometters_to_points(kilometters: float) -> float:
	return kilometters * one_kilometter

# Convert vector's distance to metters
# for instance, from result of Vector2.distance_to
func convert_distance(distance: float) -> float:
	return ("%.2f" % (distance / one_metter)) as float
