class_name LuzJugador
extends SpotLight3D
## Tarea C, nivel 1: la luz que acompaña al jugador.
## Es la linterna de Camila: un cono cálido hijo del Jugador, así que se mueve con él.

@export var rango := 8.0      # m: hasta dónde alumbra
@export var altura := 1.6     # m sobre los pies del jugador (la altura de los ojos)


func _ready() -> void:
	position = Vector3(0.0, altura, 0.0)
	spot_range = rango
	spot_attenuation = 2.0    # la que se parece a 1/d²

	# Prueba de la función pura (nivel 1). Debe imprimir: 1.0 0.25 0.0625
	print(atenuacion(1.0), " ", atenuacion(2.0), " ", atenuacion(4.0))


## Función pura: no toca la escena, así que se puede probar con números.
## Cuánta luz llega a la distancia d (en metros) si a 1 m llega 1.
static func atenuacion(d: float, exponente: float = 2.0) -> float:
	return 1.0 / pow(maxf(d, 0.0001), exponente)
