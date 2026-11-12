class_name Recogible
extends Area3D

@export var item: Item


func recoger() -> Item:
	queue_free()
	return item
