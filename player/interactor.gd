class_name Interactor
extends Node

signal apuntando_cambio(interactuable: bool)


@onready var rayo: RayCast3D = $"../Head/Camera3D/RayCast3D"
@onready var inventario: Inventario = $"../Inventario"
@onready var notas: LectorNotas = $"../LectorNotas"
@onready var luz: LuzJugador = $"../Head/Camera3D/SpotLight3D"


var apuntando := false


func _ready() -> void:
	rayo.add_exception(get_parent())

func _process(_delta: float) -> void:
	var ahora := es_interactuable(objetivo())
	if ahora != apuntando:
		apuntando = ahora
		apuntando_cambio.emit(ahora)

func es_interactuable(o: Object) -> bool:
	return o != null and (o.has_method("interactuar") or o.has_method("leer") or o.has_method("usar"))

func objetivo() -> Object:
	return rayo.get_collider() if rayo.is_colliding() else null

func item_seleccionado() -> Item:
	return inventario.slots[inventario.seleccionado]

func consumir_seleccionado() -> void:
	inventario.quitar(inventario.seleccionado)

func interactuar() -> void:
	var o := objetivo()
	if o != null and o.has_method("interactuar"):
		o.call("interactuar", self)
	elif o != null and o.has_method("leer"):
		o.call("leer", self)

func usar() -> void:
	var o := objetivo()
	if o != null and o.has_method("usar"):
		o.call("usar", self)
