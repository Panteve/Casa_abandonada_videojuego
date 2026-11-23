extends CanvasLayer

## escena a la que se vuelve, (salir menu)
@export_file("*.tscn") var escena_menu := "res://menu/menu_principal.tscn"

@onready var menu: Control = $Control/Menu
@onready var panel_opciones: Control = $Control/PanelOpciones
@onready var boton_reanudar: Button = $Control/Menu/Columna/Botones/Reanudar
@onready var boton_configuracion: Button = $Control/Menu/Columna/Botones/Configuracion
@onready var boton_salir: Button = $Control/Menu/Columna/Botones/Salir
@onready var slider_volumen: HSlider = $Control/PanelOpciones/Columna/Volumen/Slider
@onready var check_pantalla: CheckBox = $Control/PanelOpciones/Columna/PantallaCompleta
@onready var boton_volver: Button = $Control/PanelOpciones/Columna/Volver

func _ready() -> void:
	visible = false
	boton_reanudar.pressed.connect(_pausar.bind(false))
	boton_configuracion.pressed.connect(_mostrar_opciones.bind(true))
	boton_salir.pressed.connect(_salir_al_menu)
	boton_volver.pressed.connect(_mostrar_opciones.bind(false))
	slider_volumen.value_changed.connect(_on_volumen)
	check_pantalla.toggled.connect(_on_pantalla_completa)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible and panel_opciones.visible:
			_mostrar_opciones(false)        # ESC, pausa
		else:
			_pausar(not visible)
		get_viewport().set_input_as_handled()

func _pausar(pausar: bool) -> void:
	visible = pausar
	get_tree().paused = pausar
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if pausar else Input.MOUSE_MODE_CAPTURED
	if pausar:
		_mostrar_opciones(false)
		slider_volumen.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(0)))
		check_pantalla.set_pressed_no_signal(
				DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func _mostrar_opciones(mostrar: bool) -> void:
	menu.visible = not mostrar
	panel_opciones.visible = mostrar
	(boton_volver if mostrar else boton_reanudar).grab_focus()

func _salir_al_menu() -> void:
	get_tree().paused = false               # esto se hace pq si no el menu principal arrancaria pausado
	get_tree().change_scene_to_file(escena_menu)

func _on_volumen(valor: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(valor))
	AudioServer.set_bus_mute(0, valor <= 0.001)

func _on_pantalla_completa(activo: bool) -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if activo else DisplayServer.WINDOW_MODE_WINDOWED)
