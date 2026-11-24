class_name Gabinete
extends AnimatableBody3D

signal gabinete_abierto
@onready var gab_puerta: MeshInstance3D = $"Sketchfab_Scene/Sketchfab_model/46f19b9e01c6450699090288b8f57565_fbx/RootNode/Gabinet_Door/Gabinet_Door_Window_0"
## Item con el que se puede abrir este gabinete (ej. el cuchillo).
@export var tipo_herramienta: String = "cuchillo"
@export_range(-180.0, 180.0, 1.0, "suffix:°") var angulo_apertura: float = -100.0
@export_range(0.1, 5.0, 0.1, "suffix:s") var duracion: float = 1.0

var abierto: bool = false
var _abriendo: bool = false
var _rotacion_cerrada: float = 0.0


func _ready() -> void:
	_rotacion_cerrada = rotation.y


func puede_abrir_con(item: Item) -> bool:
	return item != null and item.tipo == tipo_herramienta


func usar(interactor: Interactor) -> void:
	if abierto or _abriendo:
		return

	var item := interactor.item_seleccionado()
	if puede_abrir_con(item):
		interactor.consumir_seleccionado()
		abrir()
	elif item == null:
		print("El gabinete está atascado, necesitas algo para forzarlo")
	else:
		print("Este objeto no sirve para abrir el gabinete")


func abrir() -> void:
	if abierto or _abriendo:
		return

	_abriendo = true

	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(gab_puerta, "rotation:z", _rotacion_cerrada + deg_to_rad(angulo_apertura), duracion)
	tween.finished.connect(_on_apertura_terminada)


func _on_apertura_terminada() -> void:
	_abriendo = false
	abierto = true
	gabinete_abierto.emit()
