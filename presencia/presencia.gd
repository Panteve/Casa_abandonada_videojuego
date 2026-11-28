class_name Presencia
extends Node

signal aviso  
signal alcanzado 

@export_group("Fantasma")
@export var escena_fantasma: PackedScene = preload("res://presencia/presencia.tscn")
## Nombre de la animación del modelo que se repite mientras camina.
@export var animacion: StringName = &"Take 001"
@export var visible_en_oscuridad := true
@export_range(0.0, 1.0) var opacidad := 0.75
@export var desfase_altura: float = -0.75

@export_group("Movimiento")
@export_range(1.0, 30.0, 0.5, "suffix:m") var distancia_aparicion: float = 8.0
@export_range(0.05, 5.0, 0.05, "suffix:m/s") var velocidad: float = 0.4
@export var multiplicador_moviendose: float = 1.25
@export_range(1.0, 3.0, 0.05) var ventaja_sobre_jugador: float = 1.2
@export_range(0.5, 15.0, 0.5, "suffix:m") var distancia_aviso: float = 3.0
@export_range(0.2, 3.0, 0.1, "suffix:m") var distancia_atrapa: float = 1.0

@export_group("Efecto")
@export var saturacion_minima: float = 0.0

var activa := false
var cercania := 0.0

var _jugador: CharacterBody3D
var _fantasma: Node3D
var _anim: AnimationPlayer
var _luz: LuzJugador
var _aviso_emitido := false
var _env: Environment
var _saturacion_base := 0.8


func _ready() -> void:
	_jugador = get_parent() as CharacterBody3D
	set_process(false)  
	_crear_fantasma()
	_preparar.call_deferred()


func _preparar() -> void:
	var nodo := get_tree().root.find_child("WorldEnvironment", true, false)
	if nodo is WorldEnvironment and nodo.environment:
		_env = nodo.environment
		_saturacion_base = _env.adjustment_saturation

	_luz = get_tree().get_first_node_in_group("linterna") as LuzJugador
	if _luz == null:
		return
	_luz.cambio_encendida.connect(_on_linterna_cambio)
	if not _luz.encendida:
		activar()


func _on_linterna_cambio(encendida: bool) -> void:
	if encendida:
		desactivar()
	else:
		activar()


func activar() -> void:
	if activa or _jugador == null:
		return
	activa = true
	_aviso_emitido = false
	if _fantasma:
		# Aparece a la espalda del jugador (+Z local es "atrás").
		var atras := _jugador.global_transform.basis.z
		atras.y = 0.0
		atras = atras.normalized() * distancia_aparicion
		_fantasma.global_position = _jugador.global_position + atras + Vector3.UP * desfase_altura
		_mirar_hacia(_jugador.global_position)
		_mostrar_fantasma()
	set_process(true)


func desactivar() -> void:
	activa = false
	set_process(false)
	_aviso_emitido = false
	_ocultar_fantasma()
	_aplicar_efectos(distancia_aparicion)


func _process(delta: float) -> void:
	if _fantasma == null:
		return

	var objetivo := _jugador.global_position
	var hacia := objetivo - _fantasma.global_position
	hacia.y = 0.0
	var distancia := hacia.length()

	var v := velocidad
	var vel_jugador := Vector2(_jugador.velocity.x, _jugador.velocity.z).length()
	if vel_jugador > 0.5:
		v = maxf(velocidad * multiplicador_moviendose, vel_jugador * ventaja_sobre_jugador)
	if distancia > 0.001:
		_fantasma.global_position += hacia / distancia * minf(v * delta, distancia)
	_fantasma.global_position.y = objetivo.y + desfase_altura
	_mirar_hacia(objetivo)

	if not _aviso_emitido and distancia <= distancia_aviso:
		_aviso_emitido = true
		aviso.emit()

	if distancia <= distancia_atrapa:
		desactivar()
		alcanzado.emit()
		if _luz and not _luz.encendida:
			activar.call_deferred()
		return
	_aplicar_efectos(distancia)


# --- Fantasma (modelo) ---
#PROMPT: Como podria hacer una mecanica para que la escena del fantasma siga al jugador
#cada vez que apago la linterna
func _crear_fantasma() -> void:
	if escena_fantasma == null:
		push_warning("Presencia: falta la escena del fantasma.")
		return
	_fantasma = escena_fantasma.instantiate() as Node3D
	_fantasma.top_level = true 
	add_child(_fantasma)
	_fantasma.hide()

	var anims := _fantasma.find_children("*", "AnimationPlayer", true, false)
	if not anims.is_empty():
		_anim = anims[0] as AnimationPlayer
	if visible_en_oscuridad:
		_preparar_materiales()


func _mostrar_fantasma() -> void:
	_fantasma.show()
	if _anim and _anim.has_animation(animacion):
		_anim.get_animation(animacion).loop_mode = Animation.LOOP_LINEAR
		_anim.play(animacion)


func _ocultar_fantasma() -> void:
	if _fantasma:
		_fantasma.hide()
	if _anim:
		_anim.stop()

func _mirar_hacia(punto: Vector3) -> void:
	var dir := punto - _fantasma.global_position
	if Vector2(dir.x, dir.z).length() > 0.01:
		_fantasma.global_rotation.y = atan2(dir.x, dir.z)

#PROMPT: Necesito que el fantasma se vea en la oscuridad
func _preparar_materiales() -> void:
	for malla: MeshInstance3D in _fantasma.find_children("*", "MeshInstance3D", true, false):
		if malla.mesh == null:
			continue
		for i in malla.mesh.get_surface_count():
			var base := malla.get_active_material(i) as BaseMaterial3D
			if base == null:
				continue
			var m := base.duplicate() as BaseMaterial3D
			m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			m.albedo_color.a = opacidad
			m.cull_mode = BaseMaterial3D.CULL_DISABLED
			malla.set_surface_override_material(i, m)

func _aplicar_efectos(distancia: float) -> void:
	cercania = clampf(1.0 - distancia / distancia_aparicion, 0.0, 1.0)
	if _env == null:
		return
	_env.adjustment_saturation = lerpf(_saturacion_base, saturacion_minima, cercania)
