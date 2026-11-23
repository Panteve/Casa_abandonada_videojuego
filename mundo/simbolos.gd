extends MeshInstance3D

func _ready() -> void:
	add_to_group('simbolos')
	
func alternar_visibilidad(visibilidad: bool) -> void:
	visible = visibilidad
