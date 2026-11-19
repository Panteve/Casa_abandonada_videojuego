extends Node3D

@onready var lbl1: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_KITCHEN
@onready var lbl2: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_LIVING_ROOM
@onready var lbl3: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_BEDROOM
@onready var lbl4: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_BATHROOM
@onready var lbl5: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_UTILITY
@onready var lbl6: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_CORRIDOR
@onready var lbl7: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_STAIR_HALL
@onready var lbl8: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_STAIRS_UP
@onready var lbl9: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_BASEMENT_STAIRS
@onready var lbl10: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_ENTRANCE
@onready var lbl11: MeshInstance3D = $Abandoned_Apartment_Floor_01/LBL_SEALED_CHASE

func _ready():
	lbl1.visible = false
	lbl2.visible = false
	lbl3.visible = false
	lbl4.visible = false
	lbl5.visible = false
	lbl6.visible = false
	lbl7.visible = false
	lbl8.visible = false
	lbl9.visible = false
	lbl10.visible = false
	lbl11.visible = false
