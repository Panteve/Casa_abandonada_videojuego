class_name Item
extends Resource

@export var nombre: String = ""
@export var icono: Texture2D


@export_enum("normal", "nota", "llave", "cuchillo", "fragmento") var tipo: String = "normal"

@export_multiline var contenido: String = ""

# Identificador del fragmento del retrato.
@export var id_fragmento: int = -1
