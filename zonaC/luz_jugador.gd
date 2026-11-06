class_name LuzJugador
extends SpotLight3D

@export var rango := 8.0      # m: hasta dónde alumbra
@export var altura := 1.6     # m sobre los pies del jugador (la altura de los ojos)


func _ready() -> void:
	position = Vector3(0.0, altura, 0.0)
	spot_range = rango
	spot_attenuation = 2.0  

	print(atenuacion(1.0), " ", atenuacion(2.0), " ", atenuacion(4.0))


static func atenuacion(d: float, exponente: float = 2.0) -> float:
	return 1.0 / pow(maxf(d, 0.0001), exponente)
