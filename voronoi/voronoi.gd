extends MarginContainer

@onready var visualizer: Control = $VoronoiVisualization
@onready var sparks: SparksSpawner = $Sparks
@onready var lines: Lines = $Lines
@onready var controls: VoronoiControls = $VoronoiControls
@onready var fractureCells: Node2D = $FractureCells

@onready var fractureLineScene: PackedScene = preload("res://voronoi/FractureLine.tscn")

@export var shrink_factor: float = 0.1

func _ready() -> void:
	controls.clearPointsClicked.connect(sparks.clear_points)
	controls.cellFractureClicked.connect(fracture_cells)

func _process(_delta: float) -> void:
	# background visualization
	var spark_positions = sparks.get_point_positions()
	var visualizer_material: ShaderMaterial = visualizer.material
	visualizer_material.set_shader_parameter("point_positions", spark_positions)
	visualizer_material.set_shader_parameter("points", spark_positions.size())

	if controls.shouldShowCellLines:
		lines.set_spark_lines(sparks.get_active_spark_lines())
	else:
		lines.set_spark_lines(PackedVector2Array())

func fracture_cells() -> void:
	for child in fractureCells.get_children():
		child.queue_free()
	
	var positions = sparks.get_point_positions()
	var box = PackedVector2Array()
	box.append(Vector2(0.0, 0.0))
	box.append(Vector2(0.0, size.y))
	box.append(Vector2(size.x, size.y))
	box.append(Vector2(size.x, 0.0))
	
	for i in range(len(positions)):
		var vertices = box.duplicate()
		for j in range(len(positions)):
			if i == j:
				continue
			
			var pi = positions[i]
			var pj = positions[j]
			var center = (pi + pj) * 0.5
			var normal = (pi - pj).normalized()
			PolygonOps.clip_plane(vertices, center, normal)
		
		var polygon = fractureLineScene.instantiate()
		for v in vertices:
			polygon.add_point(v.lerp(positions[i], shrink_factor))
		fractureCells.add_child(polygon)
