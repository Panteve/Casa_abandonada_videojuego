
extends CanvasLayer

@onready var fondo: Sprite2D = $papel
@onready var panel: Panel = $papel/Panel
@onready var titulo: Label = $papel/Panel/Titulo
@onready var contenido: RichTextLabel = $papel/Panel/Contenido

var abierta: bool = false


func _ready() -> void:
	visible = false


func abrir_nota(nombre: String, texto: String) -> void:
	titulo.text = nombre
	contenido.text = texto

	visible = true
	abierta = true

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func cerrar_nota() -> void:
	visible = false
	abierta = false

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if abierta and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cerrar_nota()
			get_viewport().set_input_as_handled()
