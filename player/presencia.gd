extends Node

signal aviso    
signal alcanzado  

@export var tiempo_aviso: float = 10.0
@export var tiempo_limite: float = 20.0
@export var saturacion_minima: float = 0.0

var segundos_a_oscuras: float = 0.0

var _aviso_emitido := false
var _env: Environment
var _saturacion_base := 0.8


func _ready() -> void:
	set_process(false)    # dormida hasta que se apague la linterna
	_buscar_entorno.call_deferred()


func _buscar_entorno() -> void:
	var nodo := get_tree().root.find_child("WorldEnvironment", true, false)
	if nodo is WorldEnvironment and nodo.environment:
		_env = nodo.environment
		_saturacion_base = _env.adjustment_saturation


func activar() -> void:
	print("Presencia: activada")
	set_process(true)


func desactivar() -> void:
	print("Presencia: desactivada")
	set_process(false)
	segundos_a_oscuras = 0.0
	_aviso_emitido = false
	_aplicar_efectos()


func _process(delta: float) -> void:
	segundos_a_oscuras += delta

	if not _aviso_emitido and segundos_a_oscuras >= tiempo_aviso:
		_aviso_emitido = true
		aviso.emit()

	if segundos_a_oscuras >= tiempo_limite:
		desactivar()
		alcanzado.emit()
		return

	_aplicar_efectos()


func _aplicar_efectos() -> void:
	if _env == null:
		return
	var t := clampf(segundos_a_oscuras / tiempo_limite, 0.0, 1.0)
	_env.adjustment_saturation = lerpf(_saturacion_base, saturacion_minima, t)
