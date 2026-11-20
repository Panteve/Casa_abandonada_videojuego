class_name Puerta
extends Node3D

@onready var animacion: AnimationPlayer = $"../../AnimationPlayer"

var abierta: bool = false


func abrir() -> void:

	if abierta:
		return

	abierta = true

	animacion.play("abrir_puerta")

	print("La puerta se está abriendo")
