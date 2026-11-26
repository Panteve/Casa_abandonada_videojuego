class_name Interactor
extends Node


@onready var rayo: RayCast3D = $"../Head/Camera3D/RayCast3D"
@onready var inventario: Inventario = $"../Inventario"
@onready var notas: LectorNotas = $"../LectorNotas"
@onready var luz: LuzJugador = $"../Head/Camera3D/SpotLight3D"


func _ready() -> void:
	rayo.add_exception(get_parent())

func objetivo() -> Object:
	return rayo.get_collider() if rayo.is_colliding() else null

func item_seleccionado() -> Item:
	return inventario.slots[inventario.seleccionado]

func consumir_seleccionado() -> void:
	inventario.quitar(inventario.seleccionado)

func interactuar() -> void:
	var o := objetivo()
	print("miro: ", o)
	if o != null:
		print("tiene interactuar: ", o.has_method("interactuar"))
		print("bateria: ", luz.bateria, " de ", luz.duracion)
	if o != null and o.has_method("interactuar"):
		o.call("interactuar", self)
	elif o != null and o.has_method("leer"):
		o.call("leer", self)

func usar() -> void:
	var o := objetivo()
	if o != null and o.has_method("usar"):
		o.call("usar", self)
