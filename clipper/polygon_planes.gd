extends Control

class_name PolygonPlanes

var can_place: bool = false

@onready var plane_scene: PackedScene = load("res://clipper/ClipperPlane.tscn")

func _gui_input(event: InputEvent) -> void:
	if can_place and event.is_action_pressed("PlaceOrMoveSpark"):
		var plane: ClipperPlane = plane_scene.instantiate()
		add_child(plane)
		plane.set_position_centered(event.global_position)
		plane.state = ClipperPlane.State.Rotating

func _on_active_tool_changed(tool: ClipperControl.Tool) -> void:
	var active = tool == ClipperControl.Tool.Plane
	can_place = active
	if active:
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_INHERITED
		mouse_filter = Control.MOUSE_FILTER_PASS
	else:
		mouse_behavior_recursive = Control.MOUSE_BEHAVIOR_DISABLED
		mouse_filter = Control.MOUSE_FILTER_IGNORE

# [{ position: Vector2, normal: Vector2 }]
func get_planes() -> Array[Dictionary]:
	var output: Array[Dictionary] = []
	for child in get_children():
		if not child.is_queued_for_deletion():
			output.append((child as ClipperPlane).get_info())
	return output


func _on_clear_planes() -> void:
	for child in get_children():
		child.queue_free()
