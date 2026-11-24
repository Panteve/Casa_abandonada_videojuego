extends MeshInstance3D
## Símbolo fosforescente: solo se ve con la linterna apagada.
## Se engancha solo a la señal de la linterna (grupo "linterna").


func _ready() -> void:
	add_to_group("simbolos")
	_sin_iluminacion()
	_conectar.call_deferred()


func _conectar() -> void:
	var luz := get_tree().get_first_node_in_group("linterna") as LuzJugador
	if luz == null:
		return
	luz.cambio_encendida.connect(func(encendida: bool) -> void: alternar_visibilidad(not encendida))
	alternar_visibilidad(not luz.encendida)


func alternar_visibilidad(visibilidad: bool) -> void:
	visible = visibilidad


## Que la linterna no altere el color: el material ignora la luz.
func _sin_iluminacion() -> void:
	for i in mesh.get_surface_count():
		var base := get_active_material(i)
		if base is BaseMaterial3D:
			var m := base.duplicate() as BaseMaterial3D
			m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			set_surface_override_material(i, m)
