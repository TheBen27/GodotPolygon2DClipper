extends RigidBody2D

class_name FractureLine

var queue_update_points: bool = false

var points: PackedVector2Array:
	set(value):
		points = value
		queue_update_points = true

@onready var line: Line2D = $Line2D
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D

func _process(delta: float) -> void:
	if queue_update_points:
		line.clear_points()
		for point in points:
			line.add_point(point)
			
		collision.polygon = points
		queue_update_points = false

func set_points(points: PackedVector2Array) -> void:
	self.points = points
