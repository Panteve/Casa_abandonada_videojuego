extends MeshInstance3D
## Símbolo fosforescente: solo se ve con la linterna apagada.
## Se engancha solo a la señal de la linterna (grupo "linterna").


func _ready() -> void:
	add_to_group("simbolos")
	_conectar.call_deferred()


func _conectar() -> void:
	var luz := get_tree().get_first_node_in_group("linterna") as LuzJugador
	if luz == null:
		return
	luz.cambio_encendida.connect(func(encendida: bool) -> void: alternar_visibilidad(not encendida))
	alternar_visibilidad(not luz.visible)


func alternar_visibilidad(visibilidad: bool) -> void:
	visible = visibilidad
