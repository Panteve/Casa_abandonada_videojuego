class_name BotonSimbolo
extends Area3D
## Botón del panel. El jugador lo pulsa con la tecla de interactuar.

signal presionado(simbolo: StringName)

## Identificador del símbolo: luna, ojo, mano o puerta.
@export var simbolo: StringName
## Dibujo del símbolo (PNG con transparencia).
@export var textura: Texture2D

@onready var malla: MeshInstance3D = $Malla

var _material: StandardMaterial3D

func _ready() -> void:
	_material = StandardMaterial3D.new()
	_material.albedo_texture = textura
	_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	malla.material_override = _material

func interactuar(_interactor: Interactor) -> void:
	presionado.emit(simbolo)
	pulsar()

## Efecto de pulsación.
func pulsar() -> void:
	var tween := create_tween()
	malla.scale = Vector3.ONE * 0.85
	tween.tween_property(malla, "scale", Vector3.ONE, 0.15)

## Tiñe el símbolo (verde = acertado, rojo = error).
func marcar(color: Color) -> void:
	_material.albedo_color = color

func limpiar() -> void:
	_material.albedo_color = Color.WHITE
