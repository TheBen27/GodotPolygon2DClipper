extends Control

class_name PointSpawner

@export var maxPoints: int = 256
var pointScene: PackedScene

func _init(_pointScene: PackedScene) -> void:
	self.pointScene = _pointScene

func _gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("PlaceOrMoveSpark"):
		return
	if maxPoints > 0 and get_child_count() >= maxPoints:
		return
	var point: Control = pointScene.instantiate()
	point.position = get_local_mouse_position()
	on_point_added(point)
	add_child(point)
	accept_event()

func on_point_added(point: Control) -> void:
	pass

func clear_points() -> void:
	for child in get_children():
		child.queue_free()

func get_point_positions() -> PackedVector2Array:
	var positions = PackedVector2Array()
	positions.resize(get_child_count())
	var children = get_children()
	for i in range(children.size()):
		positions[i] = (children[i] as Control).global_position
	return positions
