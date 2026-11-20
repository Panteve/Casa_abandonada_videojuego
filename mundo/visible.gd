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

@onready var door1: MeshInstance3D = $Abandoned_Apartment_Floor_01/ARCH_Door_Bedroom
@onready var door2: MeshInstance3D = $Abandoned_Apartment_Floor_01/ARCH_Door_Bath
@onready var door3: MeshInstance3D = $Abandoned_Apartment_Floor_01/ARCH_Door_Closet
@onready var door4: MeshInstance3D = $Abandoned_Apartment_Floor_01/ARCH_Door_HallDoor
@onready var door5: MeshInstance3D = $Abandoned_Apartment_Floor_01/ARCH_Door_Basement



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
	door1.visible = false
	door2.visible = false
	door3.visible = false
	door4.visible = false
	door5.visible = false
