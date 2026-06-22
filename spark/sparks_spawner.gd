extends Control

class_name SparksSpawner

@export var maxPoints: int = 256
@onready var spark_scene: PackedScene = preload("res://spark/spark.tscn")

var active_spark: Spark

func _gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("PlaceOrMoveSpark"):
		return
	if maxPoints > 0 and get_child_count() >= maxPoints:
		return
	var spark: Spark = spark_scene.instantiate()
	spark.position = get_local_mouse_position()
	spark.clicked.connect(spark_clicked)
	
	add_child(spark)
	accept_event()

func spark_clicked(spark: Spark) -> void:
	active_spark = spark

func get_spark_positions() -> PackedVector2Array:
	var positions = PackedVector2Array()
	positions.resize(get_child_count())
	var children = get_children()
	for i in range(children.size()):
		positions[i] = (children[i] as Control).global_position
	return positions

func get_active_spark_lines() -> PackedVector2Array:
	var output = PackedVector2Array()
	if not active_spark:
		return output
	
	for spark in get_children():
		if spark == active_spark:
			continue
		
		var mp = active_spark.global_position
		var sp = spark.global_position
		var midpoint = (mp + sp) / 2.0
		var tangent = (mp - sp).normalized()
		var normal = Vector2(tangent.y, -tangent.x)
		var start = midpoint + normal * 1024.0
		var end = midpoint - normal * 1024.0
		
		output.append(start)
		output.append(end)
	
	return output
