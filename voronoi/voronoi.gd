extends MarginContainer

@onready var visualizer: Control = $VoronoiVisualization
@onready var sparks: SparksSpawner = $Sparks
@onready var lines: Lines = $Lines

func _process(delta: float) -> void:
	# background visualization
	var spark_positions = sparks.get_spark_positions()
	var visualizer_material: ShaderMaterial = visualizer.material
	visualizer_material.set_shader_parameter("point_positions", spark_positions)
	visualizer_material.set_shader_parameter("points", spark_positions.size())

	lines.set_spark_lines(sparks.get_active_spark_lines())
