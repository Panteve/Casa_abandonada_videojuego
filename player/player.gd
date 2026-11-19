extends CharacterBody3D

@export var speed:float = 2.5
@export var aceleracion: float = 10.0
@export var friccion: float = 8.0
@export var mouse_sensitivity: float = 0.003
@export var bob_frecuencia: float = 2.2
@export var bob_amplitud: float = 0.05

var _bob_tiempo: float = 0.0

@onready var rayo: RayCast3D = $Head/Camera3D/RayCast3D
@onready var luz: LuzJugador = $Head/Camera3D/SpotLight3D 
@onready var head: Node3D = $Head
@onready var inventario: Inventario = $Inventario
@onready var camera:Camera3D = $Head/Camera3D
@onready var lector: LectorEntrada = $LectorEntrada

const PresenciaScript := preload("res://player/presencia.gd")

var presencia: Node
var _punto_reinicio: Vector3


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	rayo.add_exception(self)

	_punto_reinicio = global_position
	presencia = PresenciaScript.new()
	add_child(presencia)
	
	presencia.aviso.connect(_on_presencia_aviso)
	presencia.alcanzado.connect(_on_presencia_alcanzado)
	
	if not luz.visible:
		presencia.activar()


func poner_linterna(encendida: bool) -> void:
	luz.visible = encendida
	if encendida:
		presencia.desactivar()
	else:
		presencia.activar()


func _on_presencia_aviso() -> void:
	print("La presencia se acerca...")


func _on_presencia_alcanzado() -> void:
	print("La presencia te alcanzó")
	global_position = _punto_reinicio
	velocity = Vector3.ZERO
	poner_linterna(true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = (
			Input.MOUSE_MODE_VISIBLE
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
			else Input.MOUSE_MODE_CAPTURED
		)
	if event.is_action_pressed("interactuar"):
		_intentar_recoger()

	if event.is_action_pressed("linterna"):
		poner_linterna(not luz.visible)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direccion := lector.leer_direccion()
	var direction := transform.basis * direccion
	var objetivo := direction * speed
	var ritmo := aceleracion if direction.length() > 0.1 else friccion

	velocity.x = move_toward(velocity.x, objetivo.x, ritmo * delta)
	velocity.z = move_toward(velocity.z, objetivo.z, ritmo * delta)

	move_and_slide()
	_bob(delta)


func _bob(delta: float) -> void:
	var vel_h := Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and vel_h > 0.1:
		_bob_tiempo += delta * vel_h
		camera.position.y = sin(_bob_tiempo * bob_frecuencia) * bob_amplitud
		camera.position.x = cos(_bob_tiempo * bob_frecuencia * 0.5) * bob_amplitud * 0.5
	else:
		camera.position = camera.position.lerp(Vector3.ZERO, delta * 10.0)


func _intentar_recoger() -> void:
	if not rayo.is_colliding():
		return
	var objetivo := rayo.get_collider()
	if objetivo is Recogible and inventario.agregar(objetivo.item):
		objetivo.recoger()
