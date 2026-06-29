extends Node2D

@onready var points: PolygonPoints = $PolygonPoints
@onready var control: ClipperControl = $ClipperControl
@onready var lines: Polygon2D = $PolygonLines

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var positions = points.get_point_positions()
	lines.polygon = positions
