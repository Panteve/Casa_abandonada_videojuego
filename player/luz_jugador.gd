class_name LuzJugador
extends SpotLight3D

@export var rango := 8.0      # m: hasta dónde alumbra
@export var altura := 0     # m sobre los pies del jugador (la altura de los ojos)


func _ready() -> void:
	position = Vector3.ZERO      # ya está en la cámara, no hay que subirla
	rotation = Vector3.ZERO      # apunta hacia donde mira la cámara (-Z)
	spot_range = rango
	spot_angle = 35.0
	spot_attenuation = 2.0
	light_energy = 4.0           # sube la energía para ver el efecto claro
	shadow_enabled = true
	print("Luz visible: ", is_visible_in_tree(), " energía: ", light_energy)
	

	# Pruebas de las funciones puras (nivel 1 y nivel 3).
	# Nivel 1, debe imprimir: 1.0 0.25 0.0625
	print(atenuacion(1.0), " ", atenuacion(2.0), " ", atenuacion(4.0))
	print(blinn_phong(Vector3(0, 1, 0), Vector3(0, 1, 1), Vector3(0, 1, -1), 32.0))
	print(blinn_phong(Vector3(0, 1, 0), Vector3(0, 1, 1), Vector3(0, 1, 0), 32.0))


static func atenuacion(d: float, exponente: float = 2.0) -> float:
	return 1.0 / pow(maxf(d, 0.0001), exponente)



static func blinn_phong(normal: Vector3, hacia_luz: Vector3,
		hacia_ojo: Vector3, brillo: float) -> float:
	var n := normalizar(normal)
	var l := normalizar(hacia_luz)
	var v := normalizar(hacia_ojo)
	var h := normalizar(l + v)
	return pow(maxf(0.0, n.dot(h)), brillo)


static func normalizar(v: Vector3) -> Vector3:
	var largo := sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
	if largo == 0.0:
		return Vector3.ZERO
	return v / largo
