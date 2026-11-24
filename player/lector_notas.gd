class_name LectorNotas
extends Node

const NotaUIScene := preload("res://objetos/primer_nota/nota_ui.tscn")

var _ui: CanvasLayer

var abierta: bool:
	get:
		return _ui != null and _ui.abierta


func _ready() -> void:
	_ui = NotaUIScene.instantiate()
	get_tree().current_scene.call_deferred("add_child", _ui)


func abrir(nombre: String, texto: String) -> void:
	if _ui:
		_ui.abrir_nota(nombre, texto)
