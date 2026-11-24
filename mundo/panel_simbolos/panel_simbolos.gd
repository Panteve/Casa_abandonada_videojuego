# NOTA: esta mecánica (puzzle del panel de símbolos y el cajón que guarda la llave) fue
# desarrollada con ayuda de IA (Claude, de Anthropic).
#
# Qué hizo la IA:
#  - panel_simbolos.gd (este script): valida que los símbolos se pulsen en el orden de `secuencia`;
#    un error reinicia y parpadea en rojo, y al completarla abre el cajón, que encuentra por grupo
#    para no depender de rutas entre escenas instanciadas.
#  - boton_simbolo.gd: cada botón crea su material con el PNG del símbolo, avisa al panel al ser
#    pulsado (método `interactuar`, llamado por el Interactor) y da feedback (verde/rojo).
#  - mundo/comoda/cajon.gd: desliza el cajón con un Tween, bloquea la colisión de lo que hay dentro
#    (la llave) hasta que se abre y se registra en un grupo.
#  - Las escenas panel_simbolos.tscn y boton_simbolo.tscn.
#
# Fue revisada y probada por el equipo en el juego.

class_name PanelSimbolos
extends Node3D
## Panel con botones de símbolos. Si se pulsan en el orden de `secuencia`,
## se abre el cajón. Un error reinicia la secuencia.

signal acierto
signal fallo
signal resuelto

## Orden correcto (los nombres deben coincidir con `simbolo` de cada botón).
@export var secuencia: Array[StringName] = [&"luna", &"ojo", &"mano", &"puerta"]
## Cajón que se abre al resolver. Si se deja vacío, se busca por `grupo_cajon`.
@export var cajon: Cajon
## Grupo del cajón a abrir (el mismo que tiene el cajón en su propiedad `grupo`).
@export var grupo_cajon: StringName = &"cajon_sala"

var _botones: Array[BotonSimbolo] = []
var _ingresados: Array[StringName] = []
var _resuelto: bool = false
var _bloqueado: bool = false

func _ready() -> void:
	_buscar_botones(self)
	if cajon == null:
		_buscar_cajon.call_deferred()

func _buscar_cajon() -> void:
	cajon = get_tree().get_first_node_in_group(grupo_cajon) as Cajon
	if cajon == null:
		push_warning("PanelSimbolos: no encontró ningún cajón en el grupo '%s'." % grupo_cajon)

func _buscar_botones(nodo: Node) -> void:
	for hijo in nodo.get_children():
		if hijo is BotonSimbolo:
			_botones.append(hijo)
			hijo.presionado.connect(_on_presionado.bind(hijo))
		_buscar_botones(hijo)

func _on_presionado(simbolo: StringName, boton: BotonSimbolo) -> void:
	if _resuelto or _bloqueado:
		return

	# Cada pulsación se marca en verde sin decir si es correcta; solo se sabe al completar.
	_ingresados.append(simbolo)
	boton.marcar(Color(0.45, 1.0, 0.55))
	if _ingresados.size() < secuencia.size():
		return

	if _ingresados == secuencia:
		_resuelto = true
		acierto.emit()
		resuelto.emit()
		if cajon:
			cajon.abrir()
	else:
		_error()

func _error() -> void:
	_bloqueado = true
	_ingresados.clear()
	fallo.emit()
	for boton in _botones:
		boton.marcar(Color(1.0, 0.25, 0.25))
	await get_tree().create_timer(0.5).timeout
	for boton in _botones:
		boton.limpiar()
	_bloqueado = false
