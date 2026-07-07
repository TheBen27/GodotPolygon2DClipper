extends PanelContainer

class_name VoronoiControls

signal showCellLinesChanged
signal cellFractureClicked
signal clearPointsClicked

var shouldShowCellLines: bool = false

@onready var showCellLinesCheckbox: CheckBox = $MarginContainer/VBoxContainer/HBoxContainer/ShowCellLinesCheckbox
@onready var cellFractureButton: Button = $MarginContainer/VBoxContainer/CellFractureButton
@onready var clearPointsButton: Button = $MarginContainer/VBoxContainer/ClearPointsButton

func _ready() -> void:
	shouldShowCellLines = showCellLinesCheckbox.button_pressed
	showCellLinesCheckbox.toggled.connect(func(x: bool): shouldShowCellLines = x)
	cellFractureButton.pressed.connect(cellFractureClicked.emit)
	clearPointsButton.pressed.connect(clearPointsClicked.emit)
