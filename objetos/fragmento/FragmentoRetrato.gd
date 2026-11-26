
class_name FragmentoRetrato
extends Area3D

@export var item: Item


func interactuar(interactor: Interactor) -> void:

	if item == null:
		return

	# Intentar guardar el fragmento.
	var agregado := interactor.inventario.agregar(item)

	if agregado:
		print("Has recogido: ", item.nombre)
		queue_free()
	else:
		print("No tienes espacio en el inventario")
