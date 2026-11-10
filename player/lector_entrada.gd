class_name LectorEntrada
extends Node

func leer_direccion() -> Vector3:
	var x := Input.get_axis("izquierda", "derecha")
	var z := Input.get_axis("adelante", "atras")
	return Vector3(x, 0, z).normalized()
