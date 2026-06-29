extends Control

class_name PolygonPoints

@export var default_radius: float = 320.0

@onready var spark = preload("res://clipper/ClipperPoint.tscn")

func set_point_count(points: int) -> void:
	for child in get_children():
		child.queue_free()
	
	for i in range(points):
		add_child(spark.instantiate())
	
	reset_point_positions()

func reset_point_positions() -> void:
	var active_children = []
	for child in get_children():
		if not child.is_queued_for_deletion():
			active_children.append(child)
	
	var screen_center = get_viewport().get_visible_rect().get_center()
	for i in range(len(active_children)):
		var angle = 2 * PI * (float(i) / float(len(active_children)))
		var p = screen_center + Vector2(default_radius * cos(angle), default_radius * sin(angle))
		active_children[i].position = p

func get_point_positions() -> PackedVector2Array:
	var positions = PackedVector2Array()
	for child in get_children():
		if not child.is_queued_for_deletion():
			positions.append(child.position)
	
	return positions
