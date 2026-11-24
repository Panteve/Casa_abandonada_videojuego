class_name Interactor
extends Node


@onready var rayo: RayCast3D = $"../Head/Camera3D/RayCast3D"
@onready var inventario: Inventario = $"../Inventario"
@onready var notas: LectorNotas = $"../LectorNotas"


func _ready() -> void:
	rayo.add_exception(get_parent())

func objetivo() -> Object:
	return rayo.get_collider() if rayo.is_colliding() else null

func item_seleccionado() -> Item:
	return inventario.slots[inventario.seleccionado]

func consumir_seleccionado() -> void:
	inventario.quitar(inventario.seleccionado)

func interactuar() -> void:
	_llamar(&"interactuar")

func usar() -> void:
	_llamar(&"usar")


func leer() -> void:
	var o := objetivo()
	if o != null and o.has_method(&"leer"):
		o.leer(self)
		get_viewport().set_input_as_handled()
		return

	# Sin nota delante: nota del inventario, si hay una seleccionada
	var item := item_seleccionado()
	if item != null and item.tipo == "nota":
		notas.abrir(item.nombre, item.contenido)
		get_viewport().set_input_as_handled()


func _llamar(metodo: StringName) -> void:
	var o := objetivo()
	if o != null and o.has_method(metodo):
		o.call(metodo, self)
