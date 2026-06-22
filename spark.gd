extends CenterContainer

class_name Spark

var is_dragging: bool = false
var drag_mouse_offset: Vector2 = Vector2(0.0, 0.0)

signal clicked

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() + drag_mouse_offset

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("RemoveSpark"):
		queue_free()
	
	if is_dragging and event.is_action_released("PlaceOrMoveSpark"):
			is_dragging = false
			accept_event()
			return

	# Grab
	if event.is_action_pressed("PlaceOrMoveSpark"):
		clicked.emit(self)
		is_dragging = true
		drag_mouse_offset = global_position - get_global_mouse_position()
		accept_event()
