extends MarginContainer

class_name ClipperControl

@onready var polygonButton: Button = $VBoxContainer/ToolSelector/HBoxContainer/PolygonToggle
@onready var planeButton: Button = $VBoxContainer/ToolSelector/HBoxContainer/PlaneToggle
@onready var pointsCountSpinbox: SpinBox = $VBoxContainer/PolygonToolbar/MarginContainer/VBoxContainer/HBoxContainer/PointsCountSpinbox
@onready var resetPointsButton: Button = $VBoxContainer/PolygonToolbar/MarginContainer/VBoxContainer/ResetPointsButton
@onready var clearPlanesButton: Button = $VBoxContainer/PlaneToolbar/MarginContainer/VBoxContainer/ClearPlanesButton
@onready var polygonToolbar: Container = $VBoxContainer/PolygonToolbar
@onready var planeToolbar: Container = $VBoxContainer/PlaneToolbar

signal activeToolChanged
signal clearPlanes
signal changePointCount
signal resetPointPositions

enum Tool {
	Polygon,
	Plane
}
var activeTool: Tool:
	get:
		return activeTool
	set(value):
		activeTool = value
		activeToolChanged.emit(value)

func _ready() -> void:
	polygonButton.pressed.connect(polygonButtonPressed)
	planeButton.pressed.connect(planeButtonPressed)
	pointsCountSpinbox.value_changed.connect(changePointCount.emit)
	resetPointsButton.pressed.connect(resetPointPositions.emit)
	clearPlanesButton.pressed.connect(clearPlanes.emit)
	activeTool = Tool.Polygon
	changePointCount.emit(pointsCountSpinbox.value)

func polygonButtonPressed() -> void:
	activeTool = Tool.Polygon

func planeButtonPressed() -> void:
	activeTool = Tool.Plane
