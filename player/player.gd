extends CharacterBody3D

@export var speed:float = 7.0
@export var aceleracion: float = 25.0
@export var friccion: float = 25.0
@export var mouse_sensitivity: float = 0.003

@onready var head: Node3D = $Head
@onready var camera:Camera3D = $Head/Camera3D
@onready var lector: LectorEntrada = $LectorEntrada


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = (
			Input.MOUSE_MODE_VISIBLE
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
			else Input.MOUSE_MODE_CAPTURED
		)

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
