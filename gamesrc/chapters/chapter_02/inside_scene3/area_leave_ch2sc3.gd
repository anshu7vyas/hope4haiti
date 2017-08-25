extends Area2D

var area_count = 0
onready var worldNode = get_parent()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_leave_house_body_enter( body ):
	area_count += 1
	if area_count > 1 and worldNode.picked_up_pot:
		get_tree().change_scene("res://chapters/chapter_02/outside_scene4/ch2_outside_world_sc4.tscn")

