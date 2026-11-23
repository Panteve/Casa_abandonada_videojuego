extends CanvasLayer

@export var ruta_luz: NodePath = ^"../Head/Camera3D/SpotLight3D"
@export var estilo_normal: StyleBox     # relleno con batería normal
@export var estilo_bajo: StyleBox       # relleno con poca batería
@export var umbral_bajo := 0.25         # por debajo de este porcentaje se pone en rojito

@onready var linterna: Control = $Control/Linterna
@onready var barra: ProgressBar = $Control/Linterna/Barra

var luz: LuzJugador

func _ready() -> void:
	luz = get_node(ruta_luz)
	luz.bateria_cambio.connect(_on_bateria)
	luz.visibility_changed.connect(_on_visibilidad)
	_on_bateria(luz.bateria / luz.duracion)
	_on_visibilidad()

func _on_bateria(porcentaje: float) -> void:
	barra.value = porcentaje * 100.0
	var estilo := estilo_bajo if porcentaje <= umbral_bajo else estilo_normal
	barra.add_theme_stylebox_override("fill", estilo)

func _on_visibilidad() -> void:
	linterna.modulate.a = 1.0 if luz.visible else 0.35   # apagada: el icono se ve opaco
