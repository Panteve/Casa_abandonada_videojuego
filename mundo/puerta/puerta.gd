class_name Puerta
extends Node3D

@onready var animacion: AnimationPlayer = $"../AnimationPlayer"
@onready var colision: CollisionShape3D = $CollisionShape3D

var abierta: bool = false


func abrir() -> void:

	if abierta:
		return

	abierta = true
	colision.disabled = false

	animacion.play("abrir_puerta")

	print("La puerta se está abriendo")
