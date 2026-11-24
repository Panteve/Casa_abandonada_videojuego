class_name NotaLeible
extends Area3D
## Nota fija en el mundo: no se recoge, se lee con clic derecho.

## Item de tipo "nota" que aporta el título y el texto.
@export var item: Item


func leer(interactor: Interactor) -> void:
	if item:
		interactor.notas.abrir(item.nombre, item.contenido)
