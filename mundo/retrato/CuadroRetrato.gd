
class_name CuadroRetrato
extends Area3D

signal fragmento_colocado(id: int)
signal retrato_completado

@export var visuales: Array[Node3D]   # arrastra aquí los 6 nodos, en orden de id

var piezas_colocadas: Array[bool] = []


func _ready() -> void:
	piezas_colocadas.resize(visuales.size())
	piezas_colocadas.fill(false)
	for v in visuales:
		v.visible = false


func interactuar(interactor: Interactor) -> void:

	var item := interactor.item_seleccionado()

	# Comprobar que hay un objeto seleccionado.
	if item == null:
		print("No tienes ningún objeto seleccionado")
		return

	# Comprobar que sea un fragmento.
	if item.tipo != "fragmento":
		print("Este objeto no sirve para el retrato")
		return

	var id := item.id_fragmento

	if id < 0 or id >= piezas_colocadas.size():
		return

	# Comprobar que la posición no esté ocupada.
	if piezas_colocadas[id]:
		print("Este fragmento ya está colocado")
		return

	# Colocar el fragmento.
	piezas_colocadas[id] = true
	visuales[id].visible = true
	# Eliminarlo del inventario.
	interactor.consumir_seleccionado()
	fragmento_colocado.emit(id)



	if not piezas_colocadas.has(false):
		print("¡Has reconstruido el retrato!")
		retrato_completado.emit()
