extends Control

class_name Lines

var spark_lines: PackedVector2Array = PackedVector2Array()

func set_spark_lines(lines: PackedVector2Array) -> void:
	spark_lines = lines
	queue_redraw()

func _draw() -> void:
	if spark_lines.size() > 0:
		draw_multiline(spark_lines, Color.WHITE, 1.0, true)
