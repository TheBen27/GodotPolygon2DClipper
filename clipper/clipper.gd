extends Node2D

@onready var points: PolygonPoints = $PolygonPoints
@onready var control: ClipperControl = $ClipperControl
@onready var fill: Polygon2D = $PolygonFill
@onready var stroke: Line2D = $PolygonLines

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var positions = points.get_point_positions()
	# TODO apply plane clipping
	fill.polygon = positions
	stroke.clear_points()
	for point in positions:
		stroke.add_point(point)
