extends Node
	
enum Direction { Back, Forward }

enum DebugStage {
	Pass1,
	Pass2
}

# Clip a closed polygon with a line
# This assumes that the clipping will result in one polygon, which is not always the case.
func clip_plane(positions: PackedVector2Array, line_center: Vector2, line_normal: Vector2, debug_stage: Variant = null) -> void:
	if len(positions) < 3:
		return
	
	var side_of_plane = func (p: Vector2):
		return (p - line_center).dot(line_normal) > 0.0

	var neighbor = func (index: int, offset: int):
		return int(fposmod(index + offset, len(positions)))

	# Pass 1: dissolve points
	var inside: Array[bool] = []
	for point in positions:
		inside.append(side_of_plane.call(point))
	
	var index = 0
	while index < len(positions):
		if not inside[index] and not inside[neighbor.call(index, -1)] and not inside[neighbor.call(index, 1)]:
			positions.remove_at(index)
			inside.remove_at(index)
			# the point at index is now the next point, so don't increment the index
		else:
			index += 1
	
	# I'm pretty sure the dissolving algorithm should always either leave us with a real
	# polygon (>= 3 points) or no points whatsoever. If there are no points left, the remaining
	# operations don't do anything.
	if len(positions) == 0:
		return
	
	if debug_stage == DebugStage.Pass1:
		return
	
	# Pass 2: duplicate points
	# TODO this can probably be done more intelligently
	inside.clear()
	for point in positions:
		inside.append(side_of_plane.call(point))
	
	# we need to use a while loop because the size of the container can change
	# if there are multiple points falling under pass 2
	index = 0
	while index < len(positions):
		if inside[index]:
			index += 1
			continue
		var previous_inside = inside[neighbor.call(index, -1)]
		var next_inside = inside[neighbor.call(index, 1)]
		if previous_inside and next_inside:
			positions.insert(index, positions[index])
			inside.insert(index, false)
		
		index += 1
	
	if debug_stage == DebugStage.Pass2:
		return
	
	# Pass 3: slide points along edges
	# TODO this can probably be done more intelligently
	inside.clear()
	for point in positions:
		inside.append(side_of_plane.call(point))
	
	# TODO maybe move parts of this out so I don't have to make this be "i" just because "index"
	# was used earlier
	var line_tangent = line_normal.rotated(PI / 2.0)
	for i in range(len(positions)):
		if inside[i]:
			continue
		var previous_inside = inside[neighbor.call(i, -1)]
		var next_inside = inside[neighbor.call(i, 1)]
		# not xor
		if (previous_inside and next_inside) or (not previous_inside and not next_inside):
			continue
		var direction = Direction.Back if previous_inside else Direction.Forward
		slide_point(positions, i, direction, line_center, line_tangent)


# move a point towards its previous or next neighbor until it intersects with a line
func slide_point(positions: PackedVector2Array, index: int, direction: Direction, line_center: Vector2, line_tangent: Vector2) -> void:
	var offset = 1 if direction == Direction.Forward else -1
	var target = int(fposmod(index + offset, len(positions)))
	var tangent1 = (positions[target] - positions[index]).normalized()
	var intersection = Geometry2D.line_intersects_line(positions[index], tangent1, line_center, line_tangent)
	assert(intersection)
	positions[index] = intersection
