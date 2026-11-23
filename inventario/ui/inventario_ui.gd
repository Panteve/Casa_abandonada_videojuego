class_name InventarioUI
extends CanvasLayer

@export var estilo_normal: StyleBox        # borde de la casilla normal
@export var estilo_seleccionado: StyleBox  # borde de la casilla seleccionada

@onready var casillas: Array[Node] = $Control/Fila.get_children()

var inventario: Inventario


func _ready() -> void:
	inventario = get_parent().get_node("Inventario")   # hermano del jugador
	inventario.cambio_slots.connect(_actualizar)
	inventario.cambio_seleccion.connect(func(_i: int) -> void: _actualizar())
	_actualizar()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1: inventario.seleccionar(0)
			KEY_2: inventario.seleccionar(1)
			KEY_3: inventario.seleccionar(2)
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			inventario.seleccionar(posmod(inventario.seleccionado - 1, Inventario.TAMANO))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			inventario.seleccionar(posmod(inventario.seleccionado + 1, Inventario.TAMANO))


func _actualizar() -> void:
	for i in casillas.size():
		var casilla: PanelContainer = casillas[i]
		var nombre: Label = casilla.get_node("Margen/Columna/Nombre")
		var icono: TextureRect = casilla.get_node("Margen/Columna/Icono")

		var item: Item = inventario.slots[i] if i < inventario.slots.size() else null
		nombre.text = _nombre_de(item) if item else ""
		var textura = item.get("icono") if item else null
		icono.texture = textura if textura is Texture2D else null
		icono.visible = icono.texture != null

		var estilo := estilo_seleccionado if i == inventario.seleccionado else estilo_normal
		casilla.add_theme_stylebox_override("panel", estilo)


func _nombre_de(item: Item) -> String:
	var n = item.get("nombre")      # campo del item, toca cambiarlo depende del item
	return str(n) if n != null else item.resource_name
