class_name PilaBateria
extends StaticBody3D

@export var segundos := 40.0        # cuánta batería renueva
@export var velocidad_giro := 1.5   

@onready var malla: Node3D = $Malla

func _process(delta: float) -> void:
	malla.rotate_y(velocidad_giro * delta)

## Con la batería llena no se gasta, para no desperdiciar la pila.
func interactuar(interactor: Interactor) -> void:
	var luz := interactor.luz
	if luz.bateria >= luz.duracion:
		return
	luz.recargar(segundos)
	queue_free()
