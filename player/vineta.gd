extends CanvasLayer

@export var velocidad: float = 3.0

@onready var rect: ColorRect = $ColorRect

var _intensidad := 0.0


func _process(delta: float) -> void:
	var objetivo := 0.0
	var presencia = get_parent().get("presencia")
	if presencia:
		objetivo = clampf(presencia.segundos_a_oscuras / presencia.tiempo_limite, 0.0, 1.0)

	_intensidad = move_toward(_intensidad, objetivo, delta * velocidad)
	rect.material.set_shader_parameter("intensidad", _intensidad)
