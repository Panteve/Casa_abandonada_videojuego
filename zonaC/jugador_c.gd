extends CharacterBody3D
@export var vel_caminar := 3.0            # m/s: cruzar el sótano (12 m) toma 4 s
@export var vel_correr := 6.0             # m/s: lo cruza en 2 s
@export var tecla_correr := KEY_SHIFT
@export var segundos_sin_luz := 5.0       # al correr, la linterna se apaga (regla del juego)

@onready var luz: LuzJugador = $LuzJugador

var sin_luz := 0.0   # segundos que faltan para que la linterna vuelva


func _physics_process(delta: float) -> void:
	var x := int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	var z := int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
	var direccion := Vector3(x, 0, z).normalized()
	var corriendo := direccion != Vector3.ZERO and Input.is_key_pressed(tecla_correr)

	velocity = direccion * (vel_correr if corriendo else vel_caminar)
	move_and_slide()

	if corriendo:
		sin_luz = segundos_sin_luz
	else:
		sin_luz = maxf(0.0, sin_luz - delta)
	luz.visible = sin_luz <= 0.0
