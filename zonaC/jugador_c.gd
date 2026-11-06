extends CharacterBody3D
## Jugador mínimo de la zona C (primera persona): solo camina con WASD.
## Va en la propia carpeta de la zona y sin class_name, para no chocar con los
## scripts de jugador de las otras zonas al juntar las ramas.

@export var velocidad := 5.0   # m/s


func _physics_process(_delta: float) -> void:
	var x := int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A))
	var z := int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W))
	velocity = Vector3(x, 0, z).normalized() * velocidad
	move_and_slide()
