extends MeshInstance3D

func _ready() -> void:
	add_to_group("simbolos")
	_conectar.call_deferred()


func _conectar() -> void:
	var luz := get_tree().get_first_node_in_group("linterna") as LuzJugador
	if luz == null:
		return
	luz.cambio_encendida.connect(func(encendida: bool) -> void: alternar_visibilidad(not encendida))
	alternar_visibilidad(not luz.encendida)


func alternar_visibilidad(visibilidad: bool) -> void:
	visible = visibilidad
