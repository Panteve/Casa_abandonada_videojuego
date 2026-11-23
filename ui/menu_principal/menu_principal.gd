extends Control

## escena que se carga al pulsar JUGAR 
@export_file("*.tscn") var escena_juego := "res://main.tscn"

@onready var menu: Control = $Menu
@onready var panel_opciones: Control = $PanelOpciones
@onready var boton_jugar: Button = $Menu/Columna/Botones/Jugar
@onready var boton_opciones: Button = $Menu/Columna/Botones/Opciones
@onready var boton_salir: Button = $Menu/Columna/Botones/Salir
@onready var slider_volumen: HSlider = $PanelOpciones/Columna/Volumen/Slider
@onready var check_pantalla: CheckBox = $PanelOpciones/Columna/PantallaCompleta
@onready var boton_volver: Button = $PanelOpciones/Columna/Volver


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE   # esto es para q el juego capture el mouse

	boton_jugar.pressed.connect(_on_jugar)
	boton_opciones.pressed.connect(_mostrar_opciones.bind(true))
	boton_salir.pressed.connect(get_tree().quit)
	boton_volver.pressed.connect(_mostrar_opciones.bind(false))
	slider_volumen.value_changed.connect(_on_volumen)
	check_pantalla.toggled.connect(_on_pantalla_completa)

	slider_volumen.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	check_pantalla.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	boton_jugar.grab_focus()

func _on_jugar() -> void:
	get_tree().change_scene_to_file(escena_juego)

func _mostrar_opciones(mostrar: bool) -> void:
	menu.visible = not mostrar
	panel_opciones.visible = mostrar
	(boton_volver if mostrar else boton_opciones).grab_focus()

func _on_volumen(valor: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(valor))
	AudioServer.set_bus_mute(0, valor <= 0.001)

func _on_pantalla_completa(activo: bool) -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if activo else DisplayServer.WINDOW_MODE_WINDOWED)
