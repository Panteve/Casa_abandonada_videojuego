class_name Agarrador
extends Node3D

@export var modelo: Node3D
@export var mano: Node3D
@export var alcance := 3.0
@export var impulso_lanzamiento := 8.0

var cargada: RigidBody3D = null
var antes := false


func _physics_process(_delta: float) -> void:
	var presionada := Input.is_key_pressed(KEY_E)

	if presionada and not antes:
		if cargada == null:
			agarrar()
		else:
			lanzar()

	antes = presionada


func agarrar() -> void:
	var origen := global_position
	var direccion := -modelo.global_transform.basis.z
	var destino := origen + direccion * alcance

	var consulta := PhysicsRayQueryParameters3D.create(
		origen,
		destino,
		2
	)

	consulta.exclude = [get_parent().get_rid()]

	var resultado := get_world_3d().direct_space_state.intersect_ray(consulta)

	if resultado.is_empty():
		return

	var pelota = resultado.collider

	if not pelota is RigidBody3D:
		return

	cargada = pelota as RigidBody3D

	get_parent().add_collision_exception_with(cargada)

	cargada.freeze = true
	cargada.reparent(mano)
	cargada.position = Vector3.ZERO


func lanzar() -> void:
	var pelota := cargada
	var direccion := -modelo.global_transform.basis.z

	pelota.reparent(owner)
	pelota.global_position = mano.global_position

	get_parent().remove_collision_exception_with(pelota)

	pelota.freeze = false
	pelota.apply_central_impulse(
		direccion * impulso_lanzamiento
	)

	cargada = null
