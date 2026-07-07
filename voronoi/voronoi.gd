extends MarginContainer

@onready var visualizer: Control = $VoronoiVisualization
@onready var sparks: SparksSpawner = $Sparks
@onready var lines: Lines = $Lines
@onready var controls: VoronoiControls = $VoronoiControls

func _ready() -> void:
	controls.clearPointsClicked.connect(sparks.clear_points)

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
