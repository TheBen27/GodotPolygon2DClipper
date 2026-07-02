extends VBoxContainer

class_name ClipperPlane

@onready var arrow: Control = $DirectionArrow
@onready var line: Control = $CenterContainer/Line
@onready var rotationPivot: Control = $CenterContainer/PivotPoint

enum State { Idle, Rotating, Moving }

var state = State.Idle
var drag_offset: Vector2 = Vector2(0.0, 0.0)

func _ready() -> void:
	arrow.gui_input.connect(arrow_gui_input)
	line.gui_input.connect(line_gui_input)

func set_position_centered(position: Vector2) -> void:
	global_position = position - (pivot_offset + pivot_offset_ratio * size)

func _process(delta: float) -> void:
	if Input.is_action_just_released("PlaceOrMoveSpark"):
		state = State.Idle
	elif state == State.Moving:
		global_position = get_viewport().get_mouse_position() - drag_offset
	elif state == State.Rotating:
		var direction = (get_viewport().get_mouse_position() - rotationPivot.global_position).normalized()
		rotation = atan2(direction.y, direction.x) + PI / 2

func arrow_gui_input(input: InputEvent) -> void:
	if input.is_action_pressed("PlaceOrMoveSpark"):	
		state = State.Rotating
		arrow.accept_event()

func line_gui_input(input: InputEvent) -> void:
	if input.is_action_pressed("PlaceOrMoveSpark"):	
		state = State.Moving
		drag_offset = input.global_position - global_position
		line.accept_event()
