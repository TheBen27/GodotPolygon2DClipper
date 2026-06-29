extends PointSpawner

class_name SparksSpawner

var active_spark: Spark

func _init() -> void:
	super(load("res://voronoi/spark.tscn")) 

func on_point_added(point: Control) -> void:
	point.clicked.connect(spark_clicked)

func spark_clicked(spark: Spark) -> void:
	active_spark = spark

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
