extends Node

# delete a point at an index in positions
func dissolve_point(positions: PackedVector2Array, index: int) -> void:
	positions.remove_at(index)
	
enum Direction { Back, Forward }

# slide a point towards the last or next polygon by a certain distance
# this function assumes the polygon is closed
func slide_point(positions: PackedVector2Array, index: int, direction: Direction, plane_position: Vector2, plane_normal: Vector2) -> void:
	var offset = 1 if direction == Direction.Forward else -1
	var target = int(fposmod(index + offset, len(positions)))
	var tangent1 = (positions[target] - positions[index]).normalized()
	var tangent2 = plane_normal.rotated(PI / 2.0)
	var intersection = Geometry2D.line_intersects_line(positions[index], tangent1, plane_position, tangent2)
	assert(intersection)
	positions[index] = intersection

# duplicate a point and return the indices of the old and new points
# returns [] if the array is empty
func duplicate_point(positions: PackedVector2Array, index: int) -> Array[int]:
	if len(positions) == 0:
		return []
	positions.insert(index, positions[index])
	return [index, index + 1]
