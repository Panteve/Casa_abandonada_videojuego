class_name Inventario
extends Node

signal cambio_slots
signal cambio_seleccion(indice: int)

const TAMANO := 3

var slots: Array[Item] = []
var seleccionado: int = 0


func _ready() -> void:
	slots.resize(TAMANO)


func agregar(item: Item) -> bool:
	for i in TAMANO:
		if slots[i] == null:
			slots[i] = item
			cambio_slots.emit()
			return true
	return false


func quitar(indice: int) -> Item:
	var item := slots[indice]
	slots[indice] = null
	cambio_slots.emit()
	return item


func seleccionar(indice: int) -> void:
	seleccionado = clampi(indice, 0, TAMANO - 1)
	cambio_seleccion.emit(seleccionado)
