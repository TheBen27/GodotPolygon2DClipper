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

func _gui_input(event: InputEvent) -> void:
	if event.is_action_released("PlaceOrMoveSpark"):
		state = State.Idle
	elif event is InputEventMouseMotion:
		if state == State.Moving:
			global_position = event.global_position - drag_offset
		elif state == State.Rotating:
			var direction = (event.global_position - rotationPivot.global_position).normalized()
			rotation = atan2(direction.y, direction.x) + PI / 2

func arrow_gui_input(input: InputEvent) -> void:
	if input.is_action_pressed("PlaceOrMoveSpark"):	
		state = State.Rotating

func line_gui_input(input: InputEvent) -> void:
	if input.is_action_pressed("PlaceOrMoveSpark"):	
		state = State.Moving
		drag_offset = input.global_position - global_position
