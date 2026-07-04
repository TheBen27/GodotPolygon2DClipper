extends Spark

class_name LabeledSpark

@onready var label: Label = $Label

var text: String = ""

func set_index(index: int):
	text = str(index)

func _ready() -> void:
	label.text = text
