extends Control

class_name PolygonPointsDisplay

var points: PackedVector2Array
@export var font: Font = ThemeDB.fallback_font
@export var font_size: int = 24
@export var circle_size: float = 16

func set_points(points: PackedVector2Array) -> void:
	self.points = points
	queue_redraw()

func _draw() -> void:
	var index = 0
	for point in points:
		draw_circle(point, circle_size, Color.WHITE, true, -1.0, true)
		
		var index_text = str(index)
		var size = font.get_string_size(index_text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
		# this is deeply suspicious but pretends to work
		var pos = point + Vector2(-size.x / 2.0, size.y / 4.0)
		draw_string(font, pos, index_text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.BLACK)
		index += 1
