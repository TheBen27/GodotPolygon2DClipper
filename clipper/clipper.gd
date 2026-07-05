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
	if control.activeStage != ClipperControl.Stage.Input:
		var stage = null
		if control.activeStage == ClipperControl.Stage.Pass1:
			stage = PolygonOps.DebugStage.Pass1
		elif control.activeStage == ClipperControl.Stage.Pass2:
			stage = PolygonOps.DebugStage.Pass2
		for plane in plane_info:
			PolygonOps.clip_plane(positions, plane["position"], plane["normal"], stage)
	fill.polygon = positions
	stroke.clear_points()
	for point in positions:
		stroke.add_point(point)
