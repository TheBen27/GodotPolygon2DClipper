extends Node2D

@onready var points: PolygonPoints = $PolygonPoints
@onready var pointsDisplay: PolygonPointsDisplay = $PolygonPointsDisplay
@onready var planes: PolygonPlanes = $PolygonPlanes
@onready var control: ClipperControl = $ClipperControl
@onready var fill: Polygon2D = $PolygonFill
@onready var stroke: Line2D = $PolygonLines

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var positions = points.get_point_positions()
	var plane_info = planes.get_planes()
	pointsDisplay.set_points(positions)
	for plane in plane_info:
		clip_plane(positions, plane["position"], plane["normal"])
	fill.polygon = positions
	stroke.clear_points()
	for point in positions:
		stroke.add_point(point)


func clip_plane(points: PackedVector2Array, plane_position: Vector2, plane_normal: Vector2) -> void:
	# Clipping points with a plane happens in three passes and is done on a point-by-point basis.
	# Each pass iterates over every point and does an operation on points that match a certain
	# condition.
	#
	# Points represents the vertices of a closed polygon, so the index of the
	# point after len(points) - 1 is 0, and the index of the point before 0 is len(points) - 1.
	#
	# A point is either on the "keep" side of the plane (dot product with normal > 0) or the "cut" side.
	#
	# Also, I'm pretty sure these aren't "planes"; they're lines with a normal perpendicular to said
	# line. I don't know what you call those in 2D.
	#
	# Pass one
	#   Change if: this point and both of its neighbors are on the cut side of the plane.
	#   Operation: dissolve this point, connecting its neighboring points.
	#   Run: over and over until no points match the change condition. [Maybe unnecessary?]
	#
	# Pass two
	#   Change if: this point is on the cut side, but both of its neighbors are on the keep side.
	#   Operation: duplicate this point with the same position.
	#   Run: once for every point - you can skip newly-generated points.
	#
	# Pass three:
	#   Change if: this point is on the cut side, with one neighbor on the cut side
	#     and one neighbor on the keep side.
	#   Operation: slide this point along the line segment between it and the neighbor on the
	#     keep side so that it is on the plane's dividing line.
	#   Run: once for each point
	#
	# Rationale: This works pretty well when I do it in Blender. I should probably figure out
	# if it really works or not, though.
	# 
	# Edge case: it's possible that the entire polygon is on the plane's cut side, in which case
	# this should return an empty array.
	#
	# Edge case: if the input polygon has less than 3 points, we won't do anything to it.
	# It is possible to write algorithms that "make sense" for line segments and points, but
	# those seem unnecessary.
	if len(points) < 3:
		return
	
	if control.activeStage == ClipperControl.Stage.Input:
		return
	
	var side_of_plane = func (p: Vector2):
		return (p - plane_position).dot(plane_normal) > 0.0

	var neighbor = func (index: int, offset: int):
		return int(fposmod(index + offset, len(points)))

	# Pass 1: dissolve points
	var inside: Array[bool] = []
	for point in points:
		inside.append(side_of_plane.call(point))
	
	var index = 0
	while index < len(points):
		if not inside[index] and not inside[neighbor.call(index, -1)] and not inside[neighbor.call(index, 1)]:
			PolygonOps.dissolve_point(points, index)
			# the point at index is now the next point, so don't increment the index
		else:
			index += 1
	
	# I'm pretty sure the dissolving algorithm should always either leave us with a real
	# polygon (>= 3 points) or no points whatsoever. If there are no points left, the remaining
	# operations don't do anything.
	if len(points) == 0:
		return
	
	if control.activeStage == ClipperControl.Stage.Pass1:
		return
	
	# Pass 2: duplicate points
	# TODO this can probably be done more intelligently
	inside.clear()
	for point in points:
		inside.append(side_of_plane.call(point))
	for i in range(len(points)):
		if inside[i]:
			continue
		var previous_inside = inside[neighbor.call(i, -1)]
		var next_inside = inside[neighbor.call(i, 1)]
		if previous_inside and next_inside:
			PolygonOps.duplicate_point(points, i)
	
	if control.activeStage == ClipperControl.Stage.Pass2:
		return
	
	# Pass 3: slide points along edges
	# TODO this can probably be done more intelligently
	inside.clear()
	for point in points:
		inside.append(side_of_plane.call(point))
	
	# TODO maybe move parts of this out so I don't have to make this be "i" just because "index"
	# was used earlier
	for i in range(len(points)):
		if inside[i]:
			continue
		var previous_inside = inside[neighbor.call(i, -1)]
		var next_inside = inside[neighbor.call(i, 1)]
		# not xor
		if (previous_inside and next_inside) or (not previous_inside and not next_inside):
			continue
		var direction = PolygonOps.Direction.Back if previous_inside else PolygonOps.Direction.Forward
		PolygonOps.slide_point(points, i, direction, plane_position, plane_normal)
		
