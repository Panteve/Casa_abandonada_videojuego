class_name Recogible
extends Area3D

@export var item: Item


func interactuar(interactor: Interactor) -> void:
	if item == null:
		return
	if interactor.inventario.agregar(item):
		print("Has recogido: ", item.nombre)
		recoger()


func recoger() -> Item:
	queue_free()
	return item
