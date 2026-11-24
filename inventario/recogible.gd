class_name Recogible
extends Area3D

@export var item: Item


func interactuar(interactor: Interactor) -> void:
	if interactor.inventario.agregar(item):
		recoger()


func recoger() -> Item:
	queue_free()
	return item
