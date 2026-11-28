class_name Destello
extends Node3D
## Hace que el objeto padre brille suave y despacio para que se encuentre en la oscuridad.
## Solo brilla cerca del jugador y brilla más con la linterna apagada.

@export var color: Color = Color(1.0, 0.85, 0.6)
@export_range(0.0, 4.0, 0.05) var intensidad_maxima: float = 1.2
@export_range(0.0, 4.0, 0.05) var intensidad_minima: float = 0.3
@export_range(0.5, 10.0, 0.1, "suffix:s") var periodo: float = 2.5
@export_range(1.0, 20.0, 0.5, "suffix:m") var distancia_maxima: float = 6.0
## Cuánto brilla con la linterna encendida, comparado con apagada (0 = nada, 1 = igual).
@export_range(0.0, 1.0, 0.05) var con_linterna: float = 1.0

var _materiales: Array[BaseMaterial3D] = []
var _malla: MeshInstance3D    # para medir la distancia desde donde se ve el objeto
var _jugador: Node3D
var _luz: LuzJugador
var _tiempo := 0.0


func _ready() -> void:
	_tiempo = randf() * periodo    # para que no pulsen todas al mismo tiempo
	_preparar_materiales.call_deferred()


func _preparar_materiales() -> void:
	var padre := get_parent()
	for malla: MeshInstance3D in padre.find_children("*", "MeshInstance3D", true, false):
		if malla.mesh == null:
			continue
		for i in malla.mesh.get_surface_count():
			var base := malla.get_active_material(i) as BaseMaterial3D
			if base == null:
				continue
			var m := base.duplicate() as BaseMaterial3D
			m.emission_enabled = true
			m.emission = color
			m.emission_texture = base.albedo_texture
			m.emission_energy_multiplier = 0.0
			malla.set_surface_override_material(i, m)
			_materiales.append(m)
		if _malla == null:
			_malla = malla

	_luz = get_tree().get_first_node_in_group("linterna") as LuzJugador
	if _luz:
		_jugador = _luz.owner as Node3D


func _process(delta: float) -> void:
	if _materiales.is_empty():
		return
	_tiempo += delta

	var pulso := 0.5 + 0.5 * sin(_tiempo * TAU / periodo)
	var energia := lerpf(intensidad_minima, intensidad_maxima, pulso)

	if _jugador:
		var centro := _malla.global_transform * _malla.get_aabb().get_center()
		var d := centro.distance_to(_jugador.global_position)
		energia *= clampf(1.0 - d / distancia_maxima, 0.0, 1.0)
	if _luz and _luz.encendida:
		energia *= con_linterna

	for m in _materiales:
		m.emission_energy_multiplier = energia
