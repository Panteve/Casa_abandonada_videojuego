# NOTA: este script hace parte de la mecánica del panel de símbolos y fue desarrollado con ayuda
# de IA (Claude, de Anthropic): desliza el cajón con un Tween, bloquea la colisión de la llave
# hasta que se abre y se registra en un grupo para que el panel lo encuentre.
#
# Prompts del equipo que originaron la mecánica (ver también panel_simbolos.gd):
#  - "No pues solo es mover el cajon hacia atras o adelane para abrilo y ya ahora me preocupa es como se va a abrir"
#  - "Ya ahora pasemos a hacer lo del panel para poner el codigo"

class_name Cajon
extends Node3D
## Cajón que se desliza. Se pone el script directamente en el nodo del cajón
## (por ejemplo, en la malla del cajón dentro del modelo de la cómoda).
## Lo que haya dentro (la llave) debe ser hijo de este nodo para moverse con él.

signal se_abrio

## Hacia dónde sale, en el mismo espacio que la posición del nodo (el del padre).
@export var desplazamiento: Vector3 = Vector3(0, 0, 0.3)
@export_range(0.1, 5.0, 0.1, "suffix:s") var duracion: float = 1.0
## Grupo con el que otros nodos (el panel) encuentran este cajón.
@export var grupo: StringName = &"cajon_sala"
## Objetos de adentro (por ejemplo la llave). No se pueden tocar hasta que el cajón se abra.
## Si se deja vacío, se usan todos los objetos con colisión que sean hijos de este nodo.
@export var contenido: Array[CollisionObject3D] = []

var esta_abierto: bool = false
var _capas: Dictionary = {}

func _ready() -> void:
	if grupo != &"":
		add_to_group(grupo)
	if contenido.is_empty():
		_buscar_contenido(self)
	for objeto in contenido:
		_capas[objeto] = objeto.collision_layer
		objeto.collision_layer = 0

func _buscar_contenido(nodo: Node) -> void:
	for hijo in nodo.get_children():
		if hijo is CollisionObject3D:
			contenido.append(hijo)
		_buscar_contenido(hijo)

func abrir() -> void:
	if esta_abierto:
		return
	esta_abierto = true

	for objeto in contenido:
		if is_instance_valid(objeto):
			objeto.collision_layer = _capas[objeto]

	var tween := create_tween()
	tween.tween_property(self, "position", position + desplazamiento, duracion) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func() -> void: se_abrio.emit())
