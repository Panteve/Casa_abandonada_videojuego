class_name SistemaEventos
extends Node
@export var luz_evento: OmniLight3D
@export var pico_destello := 4.0
@export var k_destello := 6.0 

@export var luz_variable: OmniLight3D
@export var luz_bombillo: LuzParpadeante    
@export var color_bajo := Color("F5F5DC")
@export var color_alto := Color("B22222")
@export var entorno: WorldEnvironment
@export var k_variable := 4.0
@export var segundos_derrota := 20.0

var variable := 0.0                # de 0 a 1
var segundos_a_oscuras := 0.0
var llego := false

signal presencia_llega

func _ready() -> void:
	for d in get_tree().get_nodes_in_group("disparadores"):
		d.evento.connect(_on_evento)
	luz_evento.light_energy = 0.0

func _process(delta: float) -> void:
	luz_evento.light_energy = decaer(luz_evento.light_energy, 0.0,
		k_destello, delta)
	_actualizar_oscuridad(delta)

	if luz_variable != null:
		luz_variable.light_color = color_bajo.lerp(color_alto, variable)
		var deseada := 1.0 + 3.0 * variable
		luz_variable.light_energy = decaer(luz_variable.light_energy,
			deseada, k_variable, delta)
	if entorno != null and entorno.environment != null:
		entorno.environment.adjustment_enabled = true
		entorno.environment.adjustment_brightness = lerpf(1.0, 0.25, variable)
func _on_evento(posicion: Vector3) -> void:
	luz_evento.global_position = posicion + Vector3.UP * 1.5
	luz_evento.light_energy = pico_destello

static func decaer(actual: float, base: float, k: float, dt: float) -> float:
	var alpha := CamaraSeguidora.alpha_exponencial(k, dt)
	return actual + (base - actual) * alpha

func _actualizar_oscuridad(delta: float) -> void:
	# PRUEBA: mantén O presionada para "apagar la linterna".
	# Cuando exista la linterna real, reemplaza esta línea por su estado.
	var linterna_encendida := not Input.is_key_pressed(KEY_O)

	if linterna_encendida:
		segundos_a_oscuras = 0.0
		llego = false
	else:
		segundos_a_oscuras += delta

	variable = clampf(segundos_a_oscuras / segundos_derrota, 0.0, 1.0)
	
	if luz_bombillo != null:
		# 10 s: aviso (parpadeo fuerte). 15 s: la presencia apaga el bombillo.
		luz_bombillo.amplitud = 0.9 if segundos_a_oscuras >= 10.0 else 0.5
		luz_bombillo.visible = segundos_a_oscuras < 15.0

	if segundos_a_oscuras >= segundos_derrota and not llego:
		llego = true
		presencia_llega.emit()
