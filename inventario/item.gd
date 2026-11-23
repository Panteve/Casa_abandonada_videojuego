class_name Item
extends Resource

@export var nombre: String = ""
@export var icono: Texture2D


@export_enum("normal", "nota", "llave", "cuchillo") var tipo: String = "normal"

@export_multiline var contenido: String = ""
