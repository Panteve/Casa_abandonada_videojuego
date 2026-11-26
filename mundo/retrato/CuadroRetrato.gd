
class_name CuadroRetrato
extends StaticBody3D

signal fragmento_colocado(id: int)
signal retrato_completado

const TOTAL_PIEZAS := 6

var piezas_colocadas: Array[bool] = []


func _ready() -> void:
	piezas_colocadas.resize(TOTAL_PIEZAS)
	piezas_colocadas.fill(false)


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

	# Comprobar que el identificador sea válido.
	if id < 0 or id >= TOTAL_PIEZAS:
		return

	# Comprobar que la posición no esté ocupada.
	if piezas_colocadas[id]:
		print("Este fragmento ya está colocado")
		return

	# Colocar el fragmento.
	piezas_colocadas[id] = true

	# Eliminarlo del inventario.
	interactor.consumir_seleccionado()

	print("Has colocado el fragmento: ", id)

	# Avisar a la interfaz.
	fragmento_colocado.emit(id)

	comprobar_completado()


func comprobar_completado() -> void:

	for colocada in piezas_colocadas:
		if not colocada:
			return

	print("¡Has reconstruido el retrato!")

	retrato_completado.emit()
