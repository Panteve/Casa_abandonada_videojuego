class_name Puerta
extends AnimatableBody3D

@export var llave_requerida: Item
@export_range(-180.0, 180.0, 1.0, "suffix:°") var angulo_apertura: float = -110.0
@export_range(0.1, 5.0, 0.1, "suffix:s") var duracion: float = 1.5

var abierta: bool = false
var _rotacion_cerrada: float = 0.0


func _ready() -> void:
	_rotacion_cerrada = rotation.y


func puede_abrir_con(item: Item) -> bool:
	if llave_requerida == null or item == null:
		return false
	return item == llave_requerida


func usar(interactor: Interactor) -> void:
	var item := interactor.item_seleccionado()
	if puede_abrir_con(item):
		abrir()
	elif llave_requerida == null:
		print("Esta puerta no se puede abrir")
	elif item == null:
		print("Esta puerta está cerrada con llave")
	else:
		print("Este objeto no abre esta puerta")


func abrir() -> void:
	if abierta:
		return

	abierta = true

	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "rotation:y", _rotacion_cerrada + deg_to_rad(angulo_apertura), duracion)
