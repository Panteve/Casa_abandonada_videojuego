extends CanvasLayer

@export var tamano_normal: float = 5.0
@export var tamano_interactuable: float = 10.0
@export var duracion: float = 0.12

@onready var punto: Panel = $Centro/Punto

var _tween: Tween
var _notas: LectorNotas


func _ready() -> void:
	var estilo := punto.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	estilo.set_corner_radius_all(999)
	punto.add_theme_stylebox_override("panel", estilo)
	punto.custom_minimum_size = Vector2.ONE * tamano_normal

	var interactor := get_parent().get_node_or_null("Interactor") as Interactor
	if interactor:
		interactor.apuntando_cambio.connect(_on_apuntando_cambio)
	_notas = get_parent().get_node_or_null("LectorNotas") as LectorNotas


func _process(_delta: float) -> void:
	if _notas:
		visible = not _notas.abierta


func _on_apuntando_cambio(interactuable: bool) -> void:
	var tamano := tamano_interactuable if interactuable else tamano_normal
	if _tween:
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(punto, "custom_minimum_size", Vector2.ONE * tamano, duracion)
