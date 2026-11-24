class_name LuzJugador
extends SpotLight3D

signal bateria_cambio(porcentaje: float)
## Se emite cada vez que la linterna se enciende o se apaga (también al agotarse la batería).
signal cambio_encendida(encendida: bool)

@export var rango := 8.0
@export var altura := 0.0
@export var duracion := 120.0      # segundos de batería con la linterna encendida
@export var umbral_baja := 0.25    # por debajo de este porcentaje la luz se va debilitando

var bateria := 0.0                 # segundos que le quedan
var energia_base := 1.0

func _ready() -> void:
	position = Vector3(0.0, altura, 0.0)
	spot_range = rango
	spot_attenuation = 2.0
	energia_base = light_energy
	bateria = duracion
	visibility_changed.connect(func() -> void: cambio_encendida.emit(visible))

func _process(delta: float) -> void:
	if not visible:
		return                      # apagada: no gasta batería
	bateria = maxf(0.0, bateria - delta)
	if bateria <= 0.0:
		visible = false             # se acabo la batería
	_actualizar()


## no deja encender si no hay batería
func alternar() -> void:
	if bateria <= 0.0:
		return
	visible = not visible


## cuando se recarga la pila se suman 60segs
func recargar(segundos: float) -> void:
	bateria = minf(duracion, bateria + segundos)
	_actualizar()

func _actualizar() -> void:
	var porcentaje := bateria / duracion
	# con poca batería la luz se debilita de a poco, la iluminacion no va a bajar de 15%
	light_energy = energia_base * clampf(porcentaje / umbral_baja, 0.15, 1.0)
	bateria_cambio.emit(porcentaje)
